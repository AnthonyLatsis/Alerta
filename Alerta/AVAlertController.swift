//
//  AVAlertController.swift
//  Extractor
//
//  Created by Anthony Latsis on 4/28/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

public enum AVAlertControllerStyle {
    
    case alert
    
    case actionSheet
}

public enum AVAlertActionStyle: String {
    
    case `default`
    
    case cancel
    
    case destructive
}

public protocol AlertActionItem: ActionItem {
    
    var title: String { get }
    
    var style: AVAlertActionStyle { get }
}

public final class AVAlertAction: AlertActionItem {
    
    public init(title: String, style: AVAlertActionStyle, handler: (() -> ())? = nil) {
        
        self.title = title
        self.style = style
        
        self.handler = handler
    }
    
    public let title: String
    
    public let style: AVAlertActionStyle

    fileprivate let handler: (() -> ())?
}

public class AVAlertController: UIViewController {
    
    fileprivate var presentationWindow: UIWindow?
    
    fileprivate let mainView: AVAlertView
    
    
    fileprivate let transition: UIViewControllerAnimatedTransitioning
    
    fileprivate let actionController: ActionController
    
    
    fileprivate(set) var actions: [AlertActionItem] = []
    
    fileprivate var cancelAction: AlertActionItem?
    
    let style: AVAlertControllerStyle
    
    
    public init(title: String?, message: String?, style: AVAlertControllerStyle, layout: AlertaLayout = AlertaLayout()) {
        
        self.mainView = AVAlertView.init(style: style)
        
        if style == .actionSheet {
            
            self.actionController = ActionController.init(title: title, message: message, style: .actionSheet, layout: layout)
            
            self.transition = ActionSheetTransitionAnimator()
        } else {
           self.actionController = ActionController.init(title: title, message: message, style: .alert, layout: layout)
            
            self.transition = AlertTransitionAnimator()
        }
        self.style = style
        
        super.init(nibName: nil, bundle: nil)
        
        self.actionController.delegate = self
        
        self.modalPresentationStyle = .overFullScreen
        self.transitioningDelegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension AVAlertController {
    
    override func loadView() {
        
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.actionController.delegate = self
        
        self.mainView.delegate = self
        
        self.addChildViewController(self.actionController)
        self.actionController.didMove(toParentViewController: self)
        
        self.mainView.insert(alert: self.actionController.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        for (i, action) in actions.enumerated() {
            if action.style == .cancel {
                let cancel = actions.remove(at: i)
                actions.append(cancel)
            }
        }
    }
}

public extension AVAlertController {
    
    public func addAction(_ action: AVAlertAction) {
        
        if action.style == .cancel {
            self.cancelAction = action
        } else {
            actions.append(action)
        }
        var act: Action? = nil
        
        switch action.style {
        case .cancel:
            act = Action.init(title: action.title, style: .cancel)
        case .destructive:
            act = Action.init(title: action.title, style: .destructive)
        case .default:
            act = Action.init(title: action.title, style: .default)
        }
        actionController.add(action: act!)
    }
    
    public func setHeader(_ header: UIView, height: CGFloat) {
        
        actionController.header(view: header)
    }
}

extension AVAlertController: ActionControllerDelegate {
    
    func action(index: Int) {
        
        if index == -1 {
            self.dismiss(animated: true, completion: nil)
        } else {
            if let handler = (actions[index] as! AVAlertAction).handler {
                self.dismiss(animated: true, completion: handler)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

public extension AVAlertController {

    func show() {
        
        self.presentationWindow = UIWindow.init(frame: UIScreen.main.bounds)
        
        self.presentationWindow?.rootViewController = UIViewController.init()
        
        self.presentationWindow?.windowLevel = UIWindowLevelAlert
        
        self.presentationWindow?.makeKeyAndVisible()
        
        self.presentationWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}

extension AVAlertController {
    
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
        super.dismiss(animated: flag) {
            
            self.presentationWindow?.isHidden = true
            self.presentationWindow = nil
            
            completion?()
        }
    }
}

extension AVAlertController: AVAlertViewDelegate {
    
    func tap() {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension AVAlertController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        (transition as! ActionTransitionAnimator).mode = .present
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        (transition as! ActionTransitionAnimator).mode = .dismiss
        return transition
    }    
}
