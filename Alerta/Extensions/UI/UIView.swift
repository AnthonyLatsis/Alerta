//
//  UIView.swift
//  Alerta
//
//  Created by Anthony Latsis on 18.11.16.
//  Copyright © 2016 Anthony Latsis. All rights reserved.
//

import UIKit.UIView

protocol UILayoutElement {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var heightAnchor: NSLayoutDimension { get }
    var widthAnchor: NSLayoutDimension { get }
}

extension UILayoutGuide: UILayoutElement {}
extension UIView: UILayoutElement {}

public enum XAxisKind {
    
    case leadTrail
    
    case leftRight
}

extension UILayoutElement {

    typealias Insets = (top: CGFloat?, left: CGFloat?,
        bottom: CGFloat?, right: CGFloat?)
    
    func anchor(to element: UILayoutElement,
                using axis: XAxisKind = .leadTrail,
                insets: Insets = (0, 0, 0, 0)) {
        
        if let top = insets.top {
            self.topAnchor.constraint(equalTo: element.topAnchor,
                                      constant: top).isActive = true
        }
        if let left = insets.left {
            if axis == .leadTrail {
                leadingAnchor.constraint(
                    equalTo: element.leadingAnchor,
                    constant: left).isActive = true
            } else {
                leftAnchor.constraint(equalTo: element.leftAnchor,
                                      constant: left).isActive = true
            }
        }
        if let right = insets.right {
            if axis == .leadTrail {
                trailingAnchor.constraint(
                    equalTo: element.trailingAnchor,
                    constant: right).isActive = true
            } else {
                rightAnchor.constraint(equalTo: element.rightAnchor,
                                       constant: -right).isActive = true
            }
        }
        if let bottom = insets.bottom {
            bottomAnchor.constraint(equalTo: element.bottomAnchor,
                                    constant: -bottom).isActive = true
        }
    }
}

internal extension UIView {

    func anchorToSuperview(using axis: XAxisKind = .leadTrail) {
        superview.map {
            anchor(to: $0, using: axis)
        }
    }
}

internal extension UIView {
    func insert(subviews: UIView...) {
        for object in subviews {
            object.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(object)
        }
    }
    
    func insert(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
    }
}

internal extension UIView {
    
    static func animate(duration: TimeInterval, delay: TimeInterval = 0, curve: UIView.AnimationCurve = .linear, animations: @escaping () -> (), completion: @escaping ((Bool) -> ())) {
        
        UIView.animate(withDuration: duration, delay: delay,
                       options: UIView.AnimationOptions(
                        rawValue: UInt(bitPattern: curve.rawValue << 16)),
                       animations: animations, completion: completion)
    }
    
    static func animate(duration: TimeInterval, delay: TimeInterval = 0, curve: UIView.AnimationCurve = .linear, animations: @escaping () -> ()) {
        
        UIView.animate(withDuration: duration, delay: delay,
                       options: UIView.AnimationOptions(
                        rawValue: UInt(bitPattern: curve.rawValue << 16)),
                       animations: animations, completion: nil)
    }
}


