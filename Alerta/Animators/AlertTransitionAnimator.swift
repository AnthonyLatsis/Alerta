//
//  AlertTransitionAnimator.swift
//  Alerta
//
//  Created by Anthony Latsis on 5/18/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit.UIViewControllerTransitioning

final class AlertTransitionAnimator: NSObject, ActionTransitionAnimator {

    private let dimmingView = UIView()

    private let dimDuration = 0.3

    internal var mode: TransitionKind = .present

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return mode == .present ? 0.3 : 0.2
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let alert = (mode == .present) ?
            transitionContext.view(forKey: .to)! :
            transitionContext.view(forKey: .from)!

        let containerView = transitionContext.containerView

        if mode == .present {
            dimmingView.backgroundColor = .clear

            containerView.insert(subviews: dimmingView, alert)

            dimmingView.anchor(to: containerView)

            if UIDevice.current.orientation.isLandscape {
                alert.widthAnchor.equals(UIScreen.main.bounds.height * 0.72)
            } else {
                alert.widthAnchor.equals(UIScreen.main.bounds.width * 0.72)
            }
            alert.topAnchor.greaterOrEquals(containerView.topAnchor, constant: bezel)
            alert.bottomAnchor.lessOrEquals(containerView.bottomAnchor, constant: -bezel)
            alert.centerXAnchor.equals(containerView.centerXAnchor)
            alert.centerYAnchor.equals(containerView.centerYAnchor)
        }
        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: dimDuration) {
            self.dimmingView.backgroundColor = (self.mode == .present)
                ? UIColor.black.withAlphaComponent(0.4)
                : .clear
        }
        if mode == .present {
            alert.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

            let animator = UIViewPropertyAnimator(duration: duration, controlPoint1: CGPoint(x: 0, y: 0.9), controlPoint2: CGPoint(x: 0.1, y: 1.0)) {

                alert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            animator.addCompletion { _ in
                transitionContext.completeTransition(true)
            }
            animator.startAnimation()
            return
        }
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            alert.alpha = 0.0
        }
        animator.addCompletion { _ in
            self.dimmingView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        animator.startAnimation()
    }
}


