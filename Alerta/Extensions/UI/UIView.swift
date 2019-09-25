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
    func anchor(to element: UILayoutElement,
                using axis: XAxisKind = .leadTrail) {
        topAnchor.constraint(equalTo: element.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: element.bottomAnchor).isActive = true

        if axis == .leadTrail {
            leadingAnchor.constraint(
                equalTo: element.leadingAnchor).isActive = true
            trailingAnchor.constraint(
                equalTo: element.trailingAnchor).isActive = true
        } else {
            leftAnchor.constraint(equalTo: element.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: element.rightAnchor).isActive = true
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

    static func animate(duration: TimeInterval, delay: TimeInterval = .zero,
                        curve: UIView.AnimationCurve = .linear,
                        animations: @escaping () -> Void,
                        completion: @escaping ((Bool) -> Void)) {

        UIView.animate(withDuration: duration, delay: delay,
                       options: UIView.AnimationOptions(
                        rawValue: UInt(bitPattern: curve.rawValue << 16)),
                       animations: animations, completion: completion)
    }

    static func animate(duration: TimeInterval, delay: TimeInterval = .zero,
                        curve: UIView.AnimationCurve = .linear,
                        animations: @escaping () -> Void) {

        UIView.animate(withDuration: duration, delay: delay,
                       options: UIView.AnimationOptions(
                        rawValue: UInt(bitPattern: curve.rawValue << 16)),
                       animations: animations, completion: nil)
    }
}


