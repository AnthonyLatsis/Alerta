//
//  ActionController.swift
//  Alerta
//
//  Created by Anthony Latsis on 4/30/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

enum ActionControllerStyle {
    
    case actionSheet
    
    case alert
    
    var actionHeight: CGFloat {
        
        switch self {
        case .alert: return 45
        case .actionSheet: return 56
        }
    }
}

enum ActionStyle {
    
    case `default`
    
    case cancel
    
    case destructive
}


public protocol ActionItem {
    
    var title: String { get }
}

struct Action: ActionItem {
    
    let title: String
    
    let style: ActionStyle
}

protocol ActionControllerDelegate: class {
    
    func action(index: Int)
}

class ActionController: UIViewController {
    
    fileprivate let mainView = ActionView()
    
    weak var delegate: ActionControllerDelegate?
    
    
    fileprivate let collection = ActionCollection()
    
    
    fileprivate(set) var actions: [Action] = []
    
    fileprivate var cancelAction: Action?
    
    
    let style: ActionControllerStyle
    
    let layout: AlertaLayout
    
    let titleText: String?
    
    let message: String?
    
    var header: UIView?
    
    
    public init(title: String?, message: String?, style: ActionControllerStyle, layout: AlertaLayout = AlertaLayout()) {
        
        self.titleText = title
        self.message = message
        
        self.layout = layout
        self.style = style
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActionController {
    
    override func loadView() {
        
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        self.collection.delegate = self
        self.collection.dataSource = self
        
        self.mainView.delegate = self
        
        self.mainView.insert(table: self.collection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let actionCount = actions.count + (cancelAction == nil ? 0 : 1)
        
        let headerConfig = ActionHeaderConfiguration.init(title: titleText, message: message, header: header)
        
        let config = ActionViewConfiguration.init(style: self.style, actionCount: actionCount, cancelAction: cancelAction, headerConfig: headerConfig)
        
        self.mainView.setup(for: config, layout: layout)
        
        if self.actions.count < 8 {
            
            self.collection.isScrollEnabled = false
        }
        self.collection.scrollIndicatorInsets = UIEdgeInsets.init(bottom: layout.bodyCornerRadius)
        
        if let cancel = cancelAction, style == .alert {
            
            actions.append(cancel)
        }
    }
}

extension ActionController {
    
    func add(action: Action) {
        
        if action.style == .cancel {
            
            if cancelAction != nil {
                fatalError("You can't have more than one cancel action")
            }
            self.cancelAction = action
        } else {
            self.actions.append(action)
        }
    }
    
    func header(view: UIView) {
        
        self.header = view
    }
}

extension ActionController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return actions.count * 2 - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCollection.ReuseID.cell.rawValue, for: indexPath) as! ActionCollectionViewCell
            
            let index = indexPath.row / 2
            
            switch self.actions[index].style {
            case .cancel:
                cell.textLabel.textColor = self.layout.textColors[.action(.cancel)]
                cell.textLabel.font = self.layout.fonts[.action(.cancel)]
            case .default:
                cell.textLabel.textColor = self.layout.textColors[.action(.default)]
                cell.textLabel.font = self.layout.fonts[.action(.default)]
            case .destructive:
                cell.textLabel.textColor = self.layout.textColors[.action(.destructive)]
                cell.textLabel.font = self.layout.fonts[.action(.destructive)]
            }
            cell.textLabel.text = self.actions[index].title

            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ActionCollection.ReuseID.separator.rawValue, for: indexPath)
        }
    }
}

extension ActionController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.action(index: indexPath.row)
    }
}

extension ActionController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let height = self.style.actionHeight
            
        switch style {
        case .alert:
            if indexPath.row % 2 == 0 {
                
                if actions.count == 2 {
                    return CGSize.init(width: collectionView.bounds.width / 2 - AlertaLayout.separatorHeight / 2, height: height)
                }
                return CGSize.init(width: collectionView.bounds.width, height: height)
    
            } else {
                if actions.count == 2 {
                    return CGSize.init(width: AlertaLayout.separatorHeight, height: collectionView.bounds.height)
                }
                return CGSize.init(width: collectionView.bounds.width, height: AlertaLayout.separatorHeight)
            }
        case .actionSheet:
            
            if indexPath.row % 2 == 0 {
                return CGSize.init(width: collectionView.bounds.width, height: height)
            }
            return CGSize.init(width: collectionView.bounds.width, height: AlertaLayout.separatorHeight)
        }
    }
}

extension ActionController: ActionViewDelegate {

    func cancel() {
        
        self.delegate?.action(index: -1)
    }
}
