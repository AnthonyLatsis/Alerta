//
//  SimpleRoundedView.swift
//  Alerta
//
//  Created by Anthony Latsis on 7/26/19.
//  Copyright © 2019 Anthony Latsis. All rights reserved.
//

import UIKit.UIView

public enum DynamicCornerRadiusKind {

    case none
    case predefined(CGFloat)
    case widthFraction(CGFloat)
    case heightFraction(CGFloat)
    case circular
}

internal protocol DynamicCornerRadiusProtocol: UIView {

    var cornerRadiusKind: DynamicCornerRadiusKind { get set }
}

extension DynamicCornerRadiusProtocol {

    var computedRadius: CGFloat {
        switch cornerRadiusKind {
        case .none:
            return 0
        case .predefined(let value):
            return value
        case .heightFraction(let fraction):
            return bounds.height * fraction
        case .widthFraction(let fraction):
            return bounds.width * fraction
        case .circular:
            return min(bounds.height, bounds.width) / 2
        }
    }
}

internal final class SimpleRoundedView: UIView, DynamicCornerRadiusProtocol {

    var cornerRadiusKind: DynamicCornerRadiusKind = .none

    override var isOpaque: Bool {
        get {
            return false
        }
        set {
            super.isOpaque = false
        }
    }

    override var bounds: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    private var _backgroundColor: UIColor?
    override var backgroundColor: UIColor? {
        get {
            return _backgroundColor
        }
        set {
            _backgroundColor = newValue
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let color = _backgroundColor else {
            return
        }
        let bezier = UIBezierPath(roundedRect: bounds,
                                  cornerRadius: computedRadius)
        color.setFill()
        bezier.fill()
    }
}
