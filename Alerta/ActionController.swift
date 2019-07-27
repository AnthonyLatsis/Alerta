//
//  ActionController.swift
//  Alerta
//
//  Created by Anthony Latsis on 4/30/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit.UIViewController

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

    private let mainView: AlertaView

    private let transition: ActionTransitionAnimator


    private(set) var actions: [Action] = []

    private var cancelAction: Action?


    public let blurEffect = UIBlurEffect(style: .extraLight)

    public let style: ActionControllerStyle

    let layout: AlertaLayoutContext

    public let titleText: String?

    public let message: String?

    var header: UIView?


    public init(title: String?, message: String?, style: ActionControllerStyle, layout: AlertaLayoutContext = AlertaLayoutContext()) {

        self.titleText = title
        self.message = message
        self.layout = layout
        self.style = style

        transition = (style == .alert) ? AlertTransitionAnimator() :
                                         ActionSheetTransitionAnimator()

        mainView = AlertaView(blurEffect: blurEffect)

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

        mainView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let headerConfig = ActionHeaderConfiguration(style: style, title: titleText, message: message, header: header)

        let config = ActionViewConfiguration(style: style, actionCount: actions.count, actions: actions, cancelAction: cancelAction, headerConfig: headerConfig)

        mainView.setup(for: config, layout: layout)

//        if actions.count < layout.actionCountLimit(style) {
//            collection.isScrollEnabled = false
//        }
//        collection.scrollIndicatorInsets.bottom = layout.bodyCornerRadius
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

extension ActionController: AlertaViewActionHandler {
    
    func didSelectAction(at index: Int) {
        dismiss(animated: true,
                completion: (actions[index] as? AlertaAction)?.handler)
    }
    
    func cancel() {
        self.dismiss(animated: true)
    }
}

extension ActionController {

    @objc private func tappedOutside() {
        if style == .actionSheet {
            self.dismiss(animated: true)
        }
    }
}

extension ActionController: UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return transition.forMode(.present)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return transition.forMode(.dismiss)
    }
}
