//
//  ActionHeader.swift
//  Extractor
//
//  Created by Anthony Latsis on 5/18/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

struct ActionHeaderConfiguration {

    let style: ActionControllerStyle

    let title: String?

    let message: String?

    let header: UIView?

    var hasHeader: Bool {
        return (title != nil || message != nil || header != nil)
    }
}

class ActionHeader: UIView {

    fileprivate let topIndent: CGFloat = 14.5
    fileprivate let interIndent: CGFloat = 12
    fileprivate let indentX: CGFloat = 15

    fileprivate let titleLabel = UILabel()

    fileprivate let messageLabel = UILabel()

    fileprivate var customView = UIView()

    fileprivate var config: ActionHeaderConfiguration?

    fileprivate var titleHeightConstraint: NSLayoutConstraint?
    fileprivate var messageHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActionHeader {

    override func layoutSubviews() {
        super.layoutSubviews()

        let width = self.bounds.width - indentX * 2

        let titleHeight = self.titleLabel.sizeThatFits(CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)).height

        let messageHeight = self.messageLabel.sizeThatFits(CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)).height

        titleHeightConstraint?.constant = titleHeight
        messageHeightConstraint?.constant = messageHeight

        titleHeightConstraint?.isActive = true
        messageHeightConstraint?.isActive = true
    }
}

extension ActionHeader {

    func setup(for config: ActionHeaderConfiguration, layout: AlertaLayout) {

        self.config = config

        if let header = config.header {
            self.customView = header

            self.insert(subviews: [customView], at: 10)

            customView.anchor(to: self)
        } else {
            if let title = config.title {
                self.titleLabel.textColor = layout.textColors[config.style]?[.title]
                self.titleLabel.font = layout.fonts[config.style]?[.title]
                self.titleLabel.numberOfLines = 0

                let attrstr = NSMutableAttributedString.init(string: title)

                let style = NSMutableParagraphStyle.init()
                style.lineSpacing = config.style == .alert ? 2 : 2.5
                style.alignment = .center

                attrstr.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attrstr.length))

                self.titleLabel.attributedText = attrstr

                self.insert(subviews: [titleLabel], at: 0)

                self.titleLabel.anchor(to: self, insets: (nil, indentX, nil, indentX))

                titleHeightConstraint = self.titleLabel.heightAnchor.equals(0).inactive()
            }
            if let message = config.message {
                self.messageLabel.textColor = layout.textColors[config.style]?[.message]
                self.messageLabel.font = layout.fonts[config.style]?[.message]
                self.messageLabel.numberOfLines = 0

                if config.style == .actionSheet {
                    let attrstr = NSMutableAttributedString.init(string: message)

                    let style = NSMutableParagraphStyle.init()
                    style.lineSpacing = 2.5
                    style.alignment = .center

                    attrstr.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attrstr.length))

                    self.messageLabel.attributedText = attrstr
                } else {
                    self.messageLabel.text = message
                    self.messageLabel.textAlignment = .center
                }
                self.insert(subviews: [messageLabel], at: 0)

                self.messageLabel.anchor(to: self, insets: (nil, indentX, nil, indentX))

                messageHeightConstraint = self.messageLabel.heightAnchor.equals(0).inactive()
            }
            if config.title != nil && config.message != nil {

                self.titleLabel.topAnchor.equals(self.topAnchor, constant: topIndent)
                self.messageLabel.bottomAnchor.equals(self.bottomAnchor, constant: -15)
                self.messageLabel.topAnchor.equals(titleLabel.bottomAnchor, constant: interIndent)
            }
            if config.message == nil && config.title != nil {

                self.titleLabel.anchor(to: self, insets: (topIndent, nil, 14, nil))
            }
            if config.message != nil && config.title == nil {

                self.messageLabel.anchor(to: self, insets: (topIndent, nil, 14, nil))
            }
        }
    }
}
