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

class ActionSheetTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, ActionTransitionAnimator {
 
    fileprivate let dimmingView = UIView()
 
    fileprivate let dimDuration = 0.3
    
    fileprivate var completion: () -> () = {}
    
    var mode: AnimationControllerMode = .present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        let alert = (mode == .present) ?
            transitionContext!.view(forKey: .to)! :
            transitionContext!.view(forKey: .from)!
        
        let height = alert.bounds.height
        
        if mode == .present {
            if height < UIScreen.main.bounds.height * 0.25 {
                return 0.5
            } else {
                return 0.4
            }
        } else {
            if height < UIScreen.main.bounds.height * 0.25 {
                return 0.35
            } else {
                return 0.3
            }
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let alert = (mode == .present) ?
            transitionContext.view(forKey: .to)! :
            transitionContext.view(forKey: .from)!
        
        let containerView = transitionContext.containerView

        if mode == .present {
            let to = transitionContext.view(forKey: .to)!
            
            dimmingView.backgroundColor = .clear
        
            containerView.insert(subviews: [dimmingView, to])
            
            dimmingView.anchor(to: containerView)
            
            if UIDevice.current.orientation.isLandscape {
                to.bottomAnchor.equals(containerView.bottomAnchor, constant: -bezel)
                to.widthAnchor.equals(UIScreen.main.bounds.height * 0.5 - bezel * 2)
                to.centerXAnchor.equals(containerView.centerXAnchor)
            } else {
                to.anchor(to: containerView, insets: (nil, bezel, bezel, bezel))
            }
        }
        let animation = CABasicAnimation.init(keyPath: "position.y")
        
        animation.delegate = self
        animation.duration = transitionDuration(using: transitionContext)
        
        if mode == .present {
            let to = transitionContext.view(forKey: .to)!
            
            animation.fromValue = UIScreen.main.bounds.height * 1.5
            animation.toValue = UIScreen.main.bounds.height * 0.5
            animation.timingFunction = CAMediaTimingFunction.init(controlPoints: 0, 0.9, 0.1, 1.0)
            
            to.layer.add(animation, forKey: nil)
            
            UIView.animate(withDuration: dimDuration) {
                self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            }
        } else {
            animation.fromValue = UIScreen.main.bounds.height * 0.5
    
            let height = alert.bounds.height
            
            if height > UIScreen.main.bounds.height * 0.25 {
                animation.toValue = UIScreen.main.bounds.height * 1.5
            } else {
                animation.toValue = UIScreen.main.bounds.height
            }
            animation.timingFunction = CAMediaTimingFunction.easeOut
            
            alert.layer.position.y = UIScreen.main.bounds.height * 1.5
            
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

extension ActionSheetTransitionAnimator: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        completion()
    }
}

