//
//  AlertTransitionAnimator.swift
//  Alerta
//
//  Created by Anthony Latsis on 5/18/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

class AlertTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, ActionTransitionAnimator {
    
    fileprivate let dimmingView = UIView()
    
    fileprivate let dimDuration = 0.3
    
    fileprivate var completion: () -> () = {}
    
    var mode: AnimationControllerMode = .present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return (mode == .present) ? 0.3 : 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let alert = (mode == .present) ?
            transitionContext.view(forKey: .to)! :
            transitionContext.view(forKey: .from)!
        
        let containerView = transitionContext.containerView
        
        if mode == .present {
            dimmingView.backgroundColor = .clear
            
            containerView.insert(subviews: [dimmingView, alert])
            
            dimmingView.anchor(to: containerView)
            
            if UIDevice.current.orientation.isPortrait {
                
                alert.leftAnchor.equals(containerView.leftAnchor)
                alert.rightAnchor.equals(containerView.rightAnchor)
            } else {
                alert.widthAnchor.equals(UIScreen.main.bounds.width * 0.6)
                alert.centerXAnchor.equals(containerView.centerXAnchor)
            }
            alert.centerYAnchor.equals(containerView.centerYAnchor)
        }
        let duration = transitionDuration(using: transitionContext)
        
        if mode == .present {
            
            let scaleAnimation = CABasicAnimation.init(keyPath: "transform")
            
            scaleAnimation.duration = duration

            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0))
            scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
            scaleAnimation.timingFunction = CAMediaTimingFunction.init(controlPoints: 0, 0.9, 0.1, 1.0)
        
            let group = CAAnimationGroup()
            
            group.animations = [scaleAnimation]
            
            group.delegate = self
            group.duration = duration

            alert.layer.add(group, forKey: nil)
            
            UIView.animate(withDuration: dimDuration) {
                self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            }
        } else {
            let animation = CABasicAnimation.init(keyPath: "opacity")
            
            alert.layer.opacity = 0.0
            
            animation.delegate = self
            animation.fromValue = 1.0
            animation.toValue = 0.0
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction.easeOut
            
            alert.layer.add(animation, forKey: nil)
            
            UIView.animate(withDuration: dimDuration) {
                self.dimmingView.backgroundColor = .clear
            }
        }
        completion = {
            if self.mode == .dismiss {
                self.dimmingView.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        }
    }
}

extension AlertTransitionAnimator: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        completion()
    }
}



