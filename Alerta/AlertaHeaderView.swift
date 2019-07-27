//
//  AlertaHeaderView.swift
//  Alerta
//
//  Created by Anthony Latsis on 5/18/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit.UIView

struct ActionHeaderConfiguration {

    let style: ActionControllerStyle

    let title: String?

    let message: String?

    let header: UIView?

    var hasHeader: Bool {
        return (title != nil || message != nil || header != nil)
    }
}

internal final class AlertaHeaderView: UIView {

    private let verticalInset: CGFloat = 14.5
    private let textSpacing: CGFloat = 12
    private let horizontalInset: CGFloat = 16

    private let stackView = UIStackView()
    
    private var titleLabel: UILabel?
    private var messageLabel: UILabel?

    private var customView: UIView?

    private var config: ActionHeaderConfiguration?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins.left = horizontalInset
        stackView.layoutMargins.right = horizontalInset
        stackView.layoutMargins.top = verticalInset
        stackView.layoutMargins.bottom = verticalInset
        stackView.spacing = textSpacing
        
        insert(subview: stackView)
        
        stackView.anchorToSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlertaHeaderView {

    func setup(for config: ActionHeaderConfiguration,
               layout: AlertaLayoutContext) {

        self.config = config

        if let header = config.header {
            customView = header

            insert(subview: header)

            header.anchorToSuperview()
            return
        }
        if let title = config.title {
            let titleLabel = UILabel()
            
            titleLabel.textColor = layout.textColors[config.style]?[.title]
            titleLabel.font = layout.fonts[config.style]?[.title]
            titleLabel.numberOfLines = 0

            let attrStr = NSMutableAttributedString(string: title)

            let style = NSMutableParagraphStyle()
            style.lineSpacing = config.style == .alert ? 2 : 2.5
            style.alignment = .center

            attrStr.addAttribute(.paragraphStyle, value: style,
                                 range: NSMakeRange(0, attrStr.length))

            titleLabel.attributedText = attrStr

            stackView.addArrangedSubview(titleLabel)

            self.titleLabel = titleLabel
        }
        if let message = config.message {
            let messageLabel = UILabel()
            
            messageLabel.textColor = layout.textColors[config.style]?[.message]
            messageLabel.font = layout.fonts[config.style]?[.message]
            messageLabel.numberOfLines = 0

            let attrStr = NSMutableAttributedString(string: message)

            let style = NSMutableParagraphStyle()
            style.lineSpacing = config.style == .actionSheet
                ? 2.5 : 0.5
            style.alignment = .center

            attrStr.addAttribute(.paragraphStyle, value: style,
                                 range: NSMakeRange(0, attrStr.length))

            messageLabel.attributedText = attrStr

            stackView.addArrangedSubview(messageLabel)
            
            self.messageLabel = messageLabel
        }
    }
}

