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
    fileprivate let baseView = UIView()
 
    fileprivate let dimDuration = 0.3

    var mode: AnimationControllerMode = .present

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        let alert = (mode == .present) ?
            transitionContext!.view(forKey: .to)! :
            transitionContext!.view(forKey: .from)!

        let height = alert.bounds.height

        if mode == .present {
            return 0.5 - 0.1 * Double(height / UIScreen.main.bounds.height)
        }
        return 0.35 - 0.05 * Double(height / UIScreen.main.bounds.height)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let alert = (mode == .present) ?
            transitionContext.view(forKey: .to)! :
            transitionContext.view(forKey: .from)!

        let containerView = transitionContext.containerView

        if mode == .present {
            let to = transitionContext.view(forKey: .to)!

            dimmingView.backgroundColor = .clear

            containerView.insert(subviews: [dimmingView, baseView])
            baseView.insert(subviews: [to])

            dimmingView.anchor(to: containerView)
            baseView.anchor(to: containerView)

            if UIDevice.current.orientation.isLandscape {
                to.widthAnchor.equals(UIScreen.main.bounds.height - bezel * 2)
                to.centerXAnchor.equals(baseView.centerXAnchor)
            } else {
                to.anchor(to: baseView, insets: (nil, bezel, nil, bezel))
            }
            to.bottomAnchor.equals(baseView.bottomAnchor, constant: -bezel)
        }
        let duration = transitionDuration(using: transitionContext)

        let animation = CABasicAnimation.init(keyPath: "position.y")
        animation.duration = duration

        UIView.animate(withDuration: dimDuration) {
            self.dimmingView.backgroundColor = (self.mode == .present)
                ? UIColor.black.withAlphaComponent(0.4)
                : .clear
        }
        if mode == .present {
            self.baseView.center.y = UIScreen.main.bounds.height * 1.5

            let animator = UIViewPropertyAnimator.init(duration: duration, controlPoint1: CGPoint.init(x: 0, y: 0.9), controlPoint2: CGPoint.init(x: 0.1, y: 1.0)) {

                self.baseView.center.y = UIScreen.main.bounds.height * 0.5
            }
            animator.addCompletion { _ in
                transitionContext.completeTransition(true)
            }
            animator.startAnimation()
            return
        }
        let animator = UIViewPropertyAnimator.init(duration: duration, curve: .easeOut) {

            let height = alert.bounds.height

            self.baseView.center.y = (height > UIScreen.main.bounds.height * 0.25)
                ? UIScreen.main.bounds.height * 1.5
                : UIScreen.main.bounds.height
        }
        animator.addCompletion { _ in
            self.dimmingView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        animator.startAnimation()
    }
}

