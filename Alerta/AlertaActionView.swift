//
//  AlertaActionView.swift
//  Alerta
//
//  Created by Anthony Latsis on 5/30/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit.UIView

internal final class AlertaActionView: UIView {

    enum State {
        case normal, highlighted
    }

    private let colorBurnFilterLayer = CALayer()
    private let plusDFilterLayer = CALayer()

    private let highlightView = UIView()

    internal let textLabel = UILabel()

    var state: State = .normal {
        didSet {
            highlightView.isHidden = state == .normal
        }
    }

    override var bounds: CGRect {
        didSet {
            colorBurnFilterLayer.frame = bounds
            plusDFilterLayer.frame = bounds
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = false

        textLabel.textAlignment = .center

        colorBurnFilterLayer.backgroundColor =
            UIColor(white: 0.6, alpha: 1).cgColor
        colorBurnFilterLayer.compositingFilter = "colorBurnBlendMode"

        plusDFilterLayer.backgroundColor =
            UIColor.black.withAlphaComponent(0.04).cgColor
        plusDFilterLayer.compositingFilter = "plusD"

        highlightView.isHidden = true
        highlightView.layer.isOpaque = true
        highlightView.layer.setValue(false, forKey: "allowsGroupBlending")
        highlightView.layer.addSublayer(colorBurnFilterLayer)
        highlightView.layer.addSublayer(plusDFilterLayer)

        insert(subviews: highlightView, textLabel)

        highlightView.anchorToSuperview()
        textLabel.anchorToSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
