//
//  ActionView.swift
//  Alerta
//
//  Created by Anthony Latsis on 5/10/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit.UIView


struct ActionViewConfiguration {

    let style: ActionControllerStyle

    let actionCount: Int

    let actions: [Action]

    let cancelAction: Action?

    let headerConfig: ActionHeaderConfiguration
}

internal protocol AlertaViewActionHandler: class {

    func didSelectAction(at index: Int)

    func cancel()
}

internal final class AlertaView: UIView {

    weak var delegate: AlertaViewActionHandler?

    private let selectionFeedback = UISelectionFeedbackGenerator()

    private let mainDimmingKnockoutView = UIView()
    private let bodyBlurView: UIVisualEffectView

    private let bodyStackView = UIStackView()

    private let actionStackView = UIStackView()

    private let cancelDimmingKnockoutView = UIView()
    private var cancelBlurView: UIVisualEffectView?

    private var blurEffect: UIBlurEffect

    private var highlightedAction: AlertaActionView?
    private var highlightedActionIndex: Int?

    private var layout: AlertaLayoutContext!

    init(blurEffect: UIBlurEffect) {
        self.blurEffect = blurEffect
        bodyBlurView = UIVisualEffectView(effect: blurEffect)

        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Masking

internal extension AlertaView {

    override func layoutSubviews() {
        super.layoutSubviews()

        if let mask = bodyBlurView.mask {
            mask.frame = mainDimmingKnockoutView.bounds
        } else {
            let mask = SimpleRoundedView(
                frame: mainDimmingKnockoutView.bounds)
            mask.backgroundColor = .white
            mask.cornerRadiusKind = .predefined(layout.bodyCornerRadius)
            
            bodyBlurView.mask = mask
        }
        if let cancelBlurView = self.cancelBlurView {
            if let mask = cancelBlurView.mask {
                mask.frame = cancelDimmingKnockoutView.bounds
            } else {
                let mask = SimpleRoundedView(
                    frame: cancelDimmingKnockoutView.bounds)
                mask.backgroundColor = .white
                mask.cornerRadiusKind =
                    .predefined(layout.cancelActionCornerRadius)

                cancelBlurView.mask = mask
            }
        }
        let bezier1 = UIBezierPath(
            roundedRect: mainDimmingKnockoutView.bounds,
            cornerRadius: layout.bodyCornerRadius).cgPath

        let bezier2 = UIBezierPath(
            roundedRect: cancelDimmingKnockoutView.bounds,
            cornerRadius: layout.cancelActionCornerRadius).cgPath

        if let mask = mainDimmingKnockoutView.layer.mask
            as? CAShapeLayer {

            mask.path = bezier1
        } else {
            let layer3 = CAShapeLayer()
            layer3.path = bezier1
            
            mainDimmingKnockoutView.layer.mask = layer3
        }
        if let mask = cancelDimmingKnockoutView.layer.mask
            as? CAShapeLayer {
            
            mask.path = bezier2
        } else {
            let layer3 = CAShapeLayer()
            layer3.path = bezier2
            
            cancelDimmingKnockoutView.layer.mask = layer3
        }
    }
}

// MARK: - UI Setup

internal extension AlertaView {

    private func setupUI() {
        self.backgroundColor = .clear
        self.layer.setValue(false, forKey: "allowsGroupBlending")

        mainDimmingKnockoutView.layer.compositingFilter = "overlayBlendMode"
        mainDimmingKnockoutView.backgroundColor = .white
        mainDimmingKnockoutView.clipsToBounds = true

        bodyBlurView.layer.masksToBounds = true

        bodyStackView.axis = .vertical
        bodyStackView.alignment = .fill
        bodyStackView.distribution = .fill

        actionStackView.axis = .vertical
        actionStackView.alignment = .fill
        actionStackView.distribution = .fill

        insert(subviews: mainDimmingKnockoutView, bodyBlurView)

        bodyBlurView.contentView.insert(subview: bodyStackView)

        bodyStackView.addArrangedSubview(actionStackView)

        mainDimmingKnockoutView.topAnchor.equals(topAnchor)
        mainDimmingKnockoutView.leadingAnchor.equals(leadingAnchor)
        mainDimmingKnockoutView.trailingAnchor.equals(trailingAnchor)

        bodyBlurView.anchor(to: mainDimmingKnockoutView)

        bodyStackView.anchorToSuperview()
    }
}

// MARK: - Configuration

extension AlertaView {

    func setup(for config: ActionViewConfiguration, layout: AlertaLayoutContext) {

        self.layout = layout

        // MARK: Cancel Action

        if let cancel = config.cancelAction, config.style == .actionSheet {
            
            let cancelBlurView = UIVisualEffectView(effect: blurEffect)
            cancelBlurView.layer.masksToBounds = true
            
            cancelDimmingKnockoutView.layer.compositingFilter = "overlayBlendMode"
            cancelDimmingKnockoutView.backgroundColor = .white
            cancelDimmingKnockoutView.clipsToBounds = true

            insert(subviews: cancelDimmingKnockoutView,
                   cancelBlurView)

            let actionView = AlertaActionView()
            actionView.isUserInteractionEnabled = true
            actionView.textLabel.textColor = layout.textColors[config.style]?[.action(.cancel)]
            actionView.textLabel.font = layout.fonts[config.style]?[.action(.cancel)]
            actionView.textLabel.text = cancel.title

            if #available(iOS 13, *) {
                actionView.backgroundColor = .secondarySystemGroupedBackground
            } else {
                actionView.backgroundColor = .white
            }

            cancelBlurView.contentView.insert(subview: actionView)

            cancelDimmingKnockoutView.leadingAnchor.equals(leadingAnchor)
            cancelDimmingKnockoutView.trailingAnchor.equals(trailingAnchor)
            cancelDimmingKnockoutView.bottomAnchor.equals(bottomAnchor)
            cancelDimmingKnockoutView.topAnchor.equals(
                mainDimmingKnockoutView.bottomAnchor,
                constant: layout.cancelActionSpacing)
            cancelDimmingKnockoutView.heightAnchor.equals(
                config.style.actionHeight)

            cancelBlurView.anchor(to: cancelDimmingKnockoutView)
            actionView.anchorToSuperview()
            
            self.cancelBlurView = cancelBlurView

            actionView.addGestureRecognizer(UITapGestureRecognizer(
                target: self, action: #selector(self.cancel)))
        } else {
            mainDimmingKnockoutView.bottomAnchor.equals(bottomAnchor)
        }

        // MARK: Header

        if config.headerConfig.hasHeader {
            let separator = UIVisualEffectView(
                effect: UIVibrancyEffect(blurEffect: blurEffect))
            separator.contentView.backgroundColor = .white
            separator.isUserInteractionEnabled = false

            bodyStackView.insertArrangedSubview(separator, at: .zero)

            separator.heightAnchor.equals(
                AlertaLayoutContext.separatorHeight)
            
            let header: UIView
            if let customHeader = config.headerConfig.header {
                header = customHeader
            } else {
                let standardHeader = AlertaHeaderView()
                standardHeader.setup(for: config.headerConfig,
                                     layout: layout)
                header = standardHeader
            }
            bodyStackView.insertArrangedSubview(header, at: .zero)
        }

        // MARK: All Actions

        for (i, action) in config.actions.enumerated() {
            let actionView = AlertaActionView()
            actionView.textLabel.text = action.title
            actionView.tag = i

            switch action.style {
            case .cancel:
                actionView.textLabel.textColor = layout.textColors[config.style]?[.action(.cancel)]
                actionView.textLabel.font = layout.fonts[config.style]?[.action(.cancel)]
            case .default:
                actionView.textLabel.textColor = layout.textColors[config.style]?[.action(.default)]
                actionView.textLabel.font = layout.fonts[config.style]?[.action(.default)]
            case .destructive:
                actionView.textLabel.textColor = layout.textColors[config.style]?[.action(.destructive)]
                actionView.textLabel.font = layout.fonts[config.style]?[.action(.destructive)]
            }
            actionStackView.addArrangedSubview(actionView)
            
            actionView.heightAnchor.equals(config.style.actionHeight)
            
            if i == config.actions.indices.last {
                break
            }
            let separator = UIVisualEffectView(
                effect: UIVibrancyEffect(
                    blurEffect: UIBlurEffect(style: .extraLight)))
            separator.contentView.backgroundColor = .white
            separator.isUserInteractionEnabled = false

            actionStackView.addArrangedSubview(separator)
            
            separator.heightAnchor.equals(AlertaLayoutContext.separatorHeight)
        }
        func height(actions: Int) {
            let limit = layout.actionCountLimit(config.style)

            let visible = (actions > limit) ? limit : actions

            var height = CGFloat(visible) * config.style.actionHeight + CGFloat(visible - 1) * AlertaLayoutContext.separatorHeight

            height += (actions > limit) ? (config.style.actionHeight * 0.2) : 0

//            self.actionStackView.heightAnchor.equals(height)
        }
        if config.actionCount == 2 && config.style == .alert {
            height(actions: 1)
        } else {
            height(actions: config.actionCount)
        }
    }
}

extension AlertaView {
    @objc private func cancel() {
        self.delegate?.cancel()
    }
}

// MARK: - Touches

extension AlertaView {
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {

        guard touches.count == 1 else {
            return
        }
        let location = touches[touches.startIndex]
            .location(in: actionStackView)

        selectionFeedback.prepare()

        if actionStackView.bounds.contains(location) == false {
            return
        }
        for case let (i, subview as AlertaActionView)
            in actionStackView.subviews.enumerated() {
            if subview.frame.contains(location) {
                if i > 0 {
                    actionStackView.subviews[i - 1].alpha = 0
                }
                subview.state = .highlighted
                if i < actionStackView.subviews.endIndex - 1 {
                    actionStackView.subviews[i + 1].alpha = 0
                }
                highlightedAction = subview
                highlightedActionIndex = i
                break
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {

        guard touches.count == 1 else {
            return
        }
        let location = touches[touches.startIndex]
            .location(in: actionStackView)

        if let i = highlightedActionIndex,
            actionStackView.bounds.contains(location) == false {
            
            if i > 0 {
                actionStackView.subviews[i - 1].alpha = 1
            }
            highlightedAction?.state = .normal
            if i < actionStackView.subviews.endIndex - 1 {
                actionStackView.subviews[i + 1].alpha = 1
            }
            highlightedAction = nil
            highlightedActionIndex = nil

            return
        }
        if highlightedAction?.frame.contains(location) == true {
            return
        }
        for case let (i, subview as AlertaActionView)
            in actionStackView.subviews.enumerated() {

            if subview.frame.contains(location) {
                // First off set up the new state to reduce upstream
                // latency.
                if i != 0 && highlightedActionIndex != i - 2 {
                    actionStackView.subviews[i - 1].alpha = 0
                }
                subview.state = .highlighted
                if i != actionStackView.subviews.endIndex - 1 &&
                    highlightedActionIndex != i + 2 {
                    actionStackView.subviews[i + 1].alpha = 0
                }
                selectionFeedback.selectionChanged()
                selectionFeedback.prepare()
                
                // Now deal with the past state. We aren't as concerned
                // for when this happens as long as the time interval
                // is negligible to the human eye.
                if let oldIdx = highlightedActionIndex {
                    if oldIdx != 0 && oldIdx < i {
                        actionStackView.subviews[oldIdx - 1].alpha = 1
                    }
                    highlightedAction?.state = .normal
                    if oldIdx != actionStackView.subviews.endIndex - 1
                        && oldIdx > i {
                        actionStackView.subviews[oldIdx + 1].alpha = 1
                    }
                }
                highlightedAction = subview
                highlightedActionIndex = i
                break
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let i = highlightedActionIndex else {
            return
        }
        if i != 0 {
            actionStackView.subviews[i - 1].alpha = 1
        }
        highlightedAction?.state = .normal
        if i != actionStackView.subviews.endIndex - 1 {
            actionStackView.subviews[i + 1].alpha = 1
        }
        highlightedAction = nil
        highlightedActionIndex = nil

        delegate?.didSelectAction(at: actionStackView.subviews[i].tag)
    }
}
