//
//  ActionController.swift
//  Alerta
//
//  Created by Anthony Latsis on 4/30/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

public enum ActionControllerStyle {

    case actionSheet

    case alert

    internal var actionHeight: CGFloat {

        switch self {
        case .alert: return 45
        case .actionSheet: return 56
        }
    }
}

public enum ActionStyle {

    case `default`

    case cancel

    case destructive
}

public protocol Action {

    var title: String { get }

    var style: ActionStyle { get }
}

public final class AlertaAction: Action {

    public init(title: String, style: ActionStyle, handler: (() -> ())? = nil) {

        self.title = title
        self.style = style

        self.handler = handler
    }
    public let title: String

    public let style: ActionStyle

    fileprivate let handler: (() -> ())?
}

public final class ActionController: UIViewController {

    fileprivate let mainView: ActionView

    fileprivate let transition: UIViewControllerAnimatedTransitioning & ActionTransitionAnimator


    fileprivate let collection = ActionCollection()


    fileprivate(set) var actions: [Action] = []

    fileprivate var cancelAction: Action?


    public let blurEffect = UIBlurEffect(style: .extraLight)

    public let style: ActionControllerStyle

    let layout: AlertaLayout

    public let titleText: String?

    public let message: String?

    var header: UIView?


    public init(title: String?, message: String?, style: ActionControllerStyle, layout: AlertaLayout = AlertaLayout()) {

        self.titleText = title
        self.message = message
        self.layout = layout
        self.style = style

        transition = (style == .alert) ? AlertTransitionAnimator() :
                                         ActionSheetTransitionAnimator()

        mainView = ActionView(blurEffect: blurEffect)

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overFullScreen
        transitioningDelegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension ActionController {

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collection.delegate = self
        collection.dataSource = self

        mainView.delegate = self

        mainView.insert(table: collection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let headerConfig = ActionHeaderConfiguration(style: style, title: titleText, message: message, header: header)

        let config = ActionViewConfiguration(style: style, actionCount: actions.count, cancelAction: cancelAction, headerConfig: headerConfig)

        mainView.setup(for: config, layout: layout)

        if actions.count < layout.actionCountLimit(style) {
            collection.isScrollEnabled = false
        }
        collection.scrollIndicatorInsets.bottom = layout.bodyCornerRadius
    }
}

public extension ActionController {

    func add(action: Action) {

        if action.style == .cancel {
            if let _ = cancelAction {
                fatalError("You can't have more than one cancel action")
            }
            cancelAction = action

            if style == .alert {
                switch actions.count {
                case 1: actions.insert(action, at: 0)
                case 0, 2...: actions.append(action)
                default: fatalError()
                }
            }
            return
        }
        if let cancel = cancelAction, style == .alert {
            switch actions.count {
            case 1: actions.append(action)
            case 2:
                actions.remove(at: 0)
                actions.append(action)
                actions.append(cancel)
            case 3...: actions.insert(action, at: actions.endIndex - 1)
            default: fatalError()
            }
        } else {
            actions.append(action)
        }
    }

    func add(actions: Action...) {
        for action in actions { self.add(action: action) }
    }

    func header(view: UIView) {
        header = view
    }
}

extension ActionController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return actions.count * 2 - 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCollection.ReuseID.cell.rawValue, for: indexPath) as! ActionCollectionViewCell

            let index = indexPath.row / 2

            switch actions[index].style {
            case .cancel:
                cell.textLabel.textColor = layout.textColors[style]?[.action(.cancel)]
                cell.textLabel.font = layout.fonts[style]?[.action(.cancel)]
            case .default:
                cell.textLabel.textColor = layout.textColors[style]?[.action(.default)]
                cell.textLabel.font = layout.fonts[style]?[.action(.default)]
            case .destructive:
                cell.textLabel.textColor = layout.textColors[style]?[.action(.destructive)]
                cell.textLabel.font = layout.fonts[style]?[.action(.destructive)]
            }
            cell.textLabel.text = actions[index].title

            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ActionCollection.ReuseID.separator.rawValue, for: indexPath)
        }
    }
}

extension ActionController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            dismiss(animated: true,
                    completion: (actions[indexPath.row / 2] as? AlertaAction)?.handler)
        }
    }
}

extension ActionController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = self.style.actionHeight

        switch style {
        case .alert:
            if indexPath.row % 2 == 0 {

                if actions.count == 2 {
                    return CGSize(width: collectionView.bounds.width / 2 - AlertaLayout.separatorHeight / 2, height: height)
                }
                return CGSize(width: collectionView.bounds.width, height: height)

            } else {
                if actions.count == 2 {
                    return CGSize(width: AlertaLayout.separatorHeight, height: collectionView.bounds.height)
                }
                return CGSize(width: collectionView.bounds.width, height: AlertaLayout.separatorHeight)
            }
        case .actionSheet:
            if indexPath.row % 2 == 0 {
                return CGSize(width: collectionView.bounds.width, height: height)
            }
            return CGSize(width: collectionView.bounds.width, height: AlertaLayout.separatorHeight)
        }
    }
}

extension ActionController: ActionViewDelegate {
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ActionController {

    @objc fileprivate func tappedOutside() {
        if style == .actionSheet { self.dismiss(animated: true) }
    }
}

extension ActionController: UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.mode = .present
        return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.mode = .dismiss
        return transition
    }
}
