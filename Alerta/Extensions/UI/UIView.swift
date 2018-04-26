//
//  UIView.swift
//  Laser Nya
//
//  Created by Anthony Latsis on 18.11.16.
//  Copyright © 2016 Anthony Latsis. All rights reserved.
//

import UIKit

protocol View {
    
    func setTargets()
    
    func setUI()
    
    func setConstraints()
}

extension View {
    
    func setTargets() {}
    
    func setUI() {}
    
    func setConstraints() {}
}

internal extension UIView {
    
    func insert(subviews: [UIView], at index: Int? = nil) {
        
        for object in subviews {
            object.translatesAutoresizingMaskIntoConstraints = false
            guard let someIndex = index else {
                self.addSubview(object)
                continue
            }
            self.insertSubview(object, at: someIndex)
        }
    }
}

protocol UILayoutElement {
    
    var bottomAnchor: NSLayoutYAxisAnchor {get}
    
    var centerXAnchor: NSLayoutXAxisAnchor {get}
    
    var centerYAnchor: NSLayoutYAxisAnchor {get}
    
    var heightAnchor: NSLayoutDimension {get}
    
    var leadingAnchor: NSLayoutXAxisAnchor {get}
    
    var leftAnchor: NSLayoutXAxisAnchor {get}
    
    var rightAnchor: NSLayoutXAxisAnchor {get}
    
    var topAnchor: NSLayoutYAxisAnchor {get}
    
    var trailingAnchor: NSLayoutXAxisAnchor {get}
    
    var widthAnchor: NSLayoutDimension {get}
}

extension UIView: UILayoutElement {
    
    typealias Insets = (top: CGFloat?, left: CGFloat?, bottom: CGFloat?, right: CGFloat?)
    
    func anchor(to element: UILayoutElement, insets: Insets = (0, 0, 0, 0)) {
        
        if let top = insets.top {
            self.topAnchor.constraint(equalTo: element.topAnchor, constant: top).isActive = true
        }
        if let left = insets.left {
            self.leftAnchor.constraint(equalTo: element.leftAnchor, constant: left).isActive = true
        }
        if let right = insets.right {
            self.rightAnchor.constraint(equalTo: element.rightAnchor, constant: -right).isActive = true
        }
        if let bottom = insets.bottom {
            self.bottomAnchor.constraint(equalTo: element.bottomAnchor, constant: -bottom).isActive = true
        }
    }
}

extension UIView {
    
    private class func animationOption(for curve: UIViewAnimationCurve) -> UIViewAnimationOptions {
        
        switch curve {
        case .easeIn: return UIViewAnimationOptions.curveEaseIn
        case .easeInOut: return UIViewAnimationOptions.curveEaseInOut
        case .linear: return UIViewAnimationOptions.curveLinear
        case .easeOut: return UIViewAnimationOptions.curveEaseOut
        }
    }
    
  class func animate(duration: TimeInterval, delay: TimeInterval = 0, curve: UIViewAnimationCurve = .linear, animations: @escaping () -> (), completion: @escaping ((Bool) -> ())) {
    
    UIView.animate(withDuration: duration, delay: delay, options: animationOption(for: curve), animations: animations, completion: completion)
  }
  
  class func animate(duration: TimeInterval, delay: TimeInterval = 0, curve: UIViewAnimationCurve = .linear, animations: @escaping () -> ()) {
    
    UIView.animate(withDuration: duration, delay: delay, options: animationOption(for: curve), animations: animations, completion: nil)
  }
}


