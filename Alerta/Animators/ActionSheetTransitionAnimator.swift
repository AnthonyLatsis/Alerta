//
//  ActionSheetTransitionAnimator.swift
//  Alerta
//
//  Created by Anthony Latsis on 5/10/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

enum AnimationControllerMode {
    case present
    case dismiss
}

protocol ActionTransitionAnimator: class {

    var mode: AnimationControllerMode { get set }
}

final class ActionSheetTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, ActionTransitionAnimator {

    fileprivate let dimmingView = UIView()
    fileprivate let actionSheetFrameGuide = UILayoutGuide()

    private weak var toVC: UIViewController?

    var mode: AnimationControllerMode = .present

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return 0.404
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let alert = (mode == .present) ?
            transitionContext.view(forKey: .to)! :
            transitionContext.view(forKey: .from)!

        let containerView = transitionContext.containerView

        if mode == .present {
            let to = transitionContext.view(forKey: .to)!

            toVC = transitionContext.viewController(forKey: .to)

            dimmingView.backgroundColor = .clear

            let tap = UITapGestureRecognizer(
                target: self, action: #selector(attemptDismissPresentedViewController))
            dimmingView.addGestureRecognizer(tap)

            containerView.insert(subviews: [dimmingView, alert])
            containerView.addLayoutGuide(actionSheetFrameGuide)

            dimmingView.anchor(to: containerView)

            if UIDevice.current.orientation.isLandscape {
                alert.widthAnchor.equals(UIScreen.main.bounds.height - bezel * 2)
                alert.centerXAnchor.equals(containerView.centerXAnchor)
            } else {
                alert.anchor(to: containerView, insets: (nil, bezel, nil, bezel))
            }
            if let window = containerView.window, #available(iOS 11.0, *),
                    window.safeAreaInsets.bottom > 0 {
                alert.bottomAnchor.equals(containerView.safeAreaLayoutGuide.bottomAnchor)
                alert.topAnchor.greaterOrEquals(containerView.safeAreaLayoutGuide.topAnchor)
            } else {
                alert.bottomAnchor.equals(containerView.bottomAnchor, constant: -bezel)
                alert.topAnchor.greaterOrEquals(containerView.topAnchor, constant: bezel)
            }
            actionSheetFrameGuide.anchor(to: to)
        }
        let duration = transitionDuration(using: transitionContext)

        let spring = UISpringTimingParameters(
            mass: 1, stiffness: 522.3503149568596, damping: 45.70996893268949,
            initialVelocity: CGVector.zero)

        UIView.animate(withDuration: duration) {
            self.dimmingView.backgroundColor = (self.mode == .present)
                ? UIColor.black.withAlphaComponent(0.4)
                : .clear
        }
        let layoutFrame = actionSheetFrameGuide.layoutFrame

        let startY = containerView.bounds.height + layoutFrame.height / 2
        if mode == .present {
            let layoutFrame = actionSheetFrameGuide.layoutFrame

            alert.center.y = startY

            let animator = UIViewPropertyAnimator(duration: duration, timingParameters: spring)

            animator.addAnimations {
                alert.center.y = layoutFrame.origin.y + layoutFrame.height / 2
            }
            animator.addCompletion { _ in
                transitionContext.completeTransition(true)
            }
            animator.startAnimation()
            return
        }
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: spring)

        animator.addAnimations {
            alert.center.y = startY
        }
        animator.addCompletion { _ in
            alert.removeFromSuperview()
            self.dimmingView.removeFromSuperview()
            containerView.removeLayoutGuide(self.actionSheetFrameGuide)
            transitionContext.completeTransition(true)
        }
        animator.startAnimation()
    }
}

extension ActionSheetTransitionAnimator {
    @objc fileprivate func attemptDismissPresentedViewController() {
        toVC?.dismiss(animated: true)
    }
}

