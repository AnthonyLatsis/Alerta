//
//  ActionSheetTransitionAnimator.swift
//  Alerta
//
//  Created by Anthony Latsis on 5/10/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit.UIViewControllerTransitioning

let bezel: CGFloat = 10.0

internal enum TransitionKind {
    case present
    case dismiss
}

protocol ActionTransitionAnimator: UIViewControllerAnimatedTransitioning {

    var mode: TransitionKind { get set }
}

extension ActionTransitionAnimator {

    func forMode(_ mode: TransitionKind) -> Self {
        self.mode = mode
        return self
    }
}

internal final class ActionSheetTransitionAnimator: NSObject, ActionTransitionAnimator {

    private let dimmingView = UIView()
    private let actionSheetFrameGuide = UILayoutGuide()

    private weak var toVC: UIViewController?

    internal var mode: TransitionKind = .present

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return 0.404
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let alert = mode == .present
            ? transitionContext.view(forKey: .to)!
            : transitionContext.view(forKey: .from)!

        let containerView = transitionContext.containerView

        if mode == .present {
            let to = transitionContext.view(forKey: .to)!

            toVC = transitionContext.viewController(forKey: .to)

            dimmingView.backgroundColor = .clear
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(attemptDismissPresentedViewController)))

            containerView.insert(subviews: dimmingView, alert)
            containerView.addLayoutGuide(actionSheetFrameGuide)

            dimmingView.anchorToSuperview()

            alert.widthAnchor.equals(
                min(UIScreen.main.bounds.height,
                    UIScreen.main.bounds.width) - bezel * 2)
            alert.centerXAnchor.equals(containerView.centerXAnchor)

            if let window = containerView.window, #available(iOS 11.0, *),
                window.safeAreaInsets.bottom > 0 {
            alert.bottomAnchor.equals(
                containerView.safeAreaLayoutGuide.bottomAnchor)
            alert.topAnchor.greaterOrEquals(
                containerView.safeAreaLayoutGuide.topAnchor)
            } else {
                alert.bottomAnchor.equals(
                    containerView.bottomAnchor, constant: -bezel)
                alert.topAnchor.greaterOrEquals(
                    containerView.topAnchor, constant: bezel)
            }
            actionSheetFrameGuide.anchor(to: to)
        }
        let duration = transitionDuration(using: transitionContext)

        let spring = UISpringTimingParameters(
            mass: 1, stiffness: 522.3503149568596,
            damping: 45.70996893268949, initialVelocity: .zero)

        UIView.animate(withDuration: duration) {
            self.dimmingView.backgroundColor = self.mode == .present
                ? UIColor.black.withAlphaComponent(0.4)
                : .clear
        }
        let layoutFrame = actionSheetFrameGuide.layoutFrame

        let startY = containerView.bounds.height + layoutFrame.height / 2

        let animator = UIViewPropertyAnimator(duration: duration,
                                              timingParameters: spring)
        if mode == .present {
            let layoutFrame = actionSheetFrameGuide.layoutFrame

            alert.center.y = startY

            animator.addAnimations {
                alert.center.y = layoutFrame.origin.y + layoutFrame.height / 2
            }
            animator.addCompletion { _ in
                transitionContext.completeTransition(true)
            }
            animator.startAnimation()
            return
        }
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
    @objc private func attemptDismissPresentedViewController() {
        toVC?.dismiss(animated: true)
    }
}

