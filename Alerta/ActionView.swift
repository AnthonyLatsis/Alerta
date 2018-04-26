//
//  ActionView.swift
//  Extractor
//
//  Created by Anthony Latsis on 5/10/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

let bezel: CGFloat = 10.0

struct ActionViewConfiguration {
    
    let style: ActionControllerStyle
    
    let actionCount: Int
    
    let cancelAction: Action?
    
    let headerConfig: ActionHeaderConfiguration
}

protocol ActionViewDelegate: class {
    
    func cancel()
}

final class ActionView: UIView {
    

    weak var delegate: ActionViewDelegate?
    
    
    fileprivate let mainDimmingKnockoutView = UIView()
    
    fileprivate let blurView = UIVisualEffectView()
    
    fileprivate let body = UIView()
    
    fileprivate let separatorView = UIVisualEffectView()
    
    fileprivate let actionsContainer = UIView()
    
    fileprivate let headerContainer = UIView()
    
    fileprivate var header: ActionHeader?
    
    
    fileprivate let cancelDimmingKnockoutView = UIView()
    
    fileprivate let cancelBlurView = UIVisualEffectView()
    
    fileprivate var cancelContainer = UIView()
    
    fileprivate var cancelAction: UIView?
    
    
    fileprivate var layout: AlertaLayout!
    
    fileprivate var config: ActionViewConfiguration!

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ActionView {
    
    override func layoutSubviews() {

        super.layoutSubviews()
        
        let mask1 = UIView.init(frame: mainDimmingKnockoutView.bounds)
        let mask2 = UIView.init(frame: cancelDimmingKnockoutView.bounds)
        
        let layer1 = CAShapeLayer()
        let layer2 = CAShapeLayer()
        
        layer1.path = UIBezierPath.rect(mask1.bounds, cornerRadius: layout.bodyCornerRadius).cgPath
        layer2.path = UIBezierPath.rect(mask2.bounds, cornerRadius: layout.cancelActionCornerRadius).cgPath
        
        layer1.frame = mask1.bounds
        layer2.frame = mask2.bounds
        
        mask1.layer.addSublayer(layer1)
        mask2.layer.addSublayer(layer2)
        
        blurView.mask = mask1
        cancelBlurView.mask = mask2
        
        let layer3 = CAShapeLayer()

        layer3.path = UIBezierPath.rect(mainDimmingKnockoutView.bounds, cornerRadius: layout.bodyCornerRadius).cgPath

        mainDimmingKnockoutView.layer.mask = layer3
       
        let layer4 = CAShapeLayer()
        
        layer4.path = UIBezierPath.rect(cancelDimmingKnockoutView.bounds, cornerRadius: layout.cancelActionCornerRadius).cgPath
        
        cancelDimmingKnockoutView.layer.mask = layer4
    }
}


extension ActionView: View {
    
    func setUI() {
        
        self.backgroundColor = .clear
        self.layer.setValue(false, forKey: "allowsGroupBlending")
        
        mainDimmingKnockoutView.layer.compositingFilter = "overlayBlendMode"
        mainDimmingKnockoutView.backgroundColor = UIColor.white
        mainDimmingKnockoutView.clipsToBounds = true
    
        separatorView.effect = UIVibrancyEffect.init(blurEffect: UIBlurEffect.init(style: .extraLight))
        separatorView.contentView.backgroundColor = .white
        
        blurView.effect = UIBlurEffect.init(style: .extraLight)
        blurView.layer.masksToBounds = true

        actionsContainer.backgroundColor = .clear
        cancelContainer.backgroundColor = .clear
        
        cancelBlurView.effect = UIBlurEffect.init(style: .extraLight)
        cancelBlurView.layer.masksToBounds = true
        
        self.insert(subviews: [mainDimmingKnockoutView, blurView])

        self.blurView.contentView.insert(subviews: [body])
        
        self.body.insert(subviews: [actionsContainer, separatorView])
    }

    func setConstraints() {
        
        mainDimmingKnockoutView.anchor(to: self, insets: (0, 0, nil, 0))

        blurView.anchor(to: mainDimmingKnockoutView)
        
        body.anchor(to: blurView.contentView)
        
        actionsContainer.anchor(to: body, insets: (nil, 0, 0, 0))
        
        separatorView.anchor(to: self, insets: (nil, 0, nil, 0))
        separatorView.bottomAnchor.equals(actionsContainer.topAnchor)
        separatorView.heightAnchor.equals(0.5)
    }
    
    func setTargets() {
        
        if let cancel = cancelAction {
            
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.cancel))
            
            cancel.addGestureRecognizer(gesture)
        }
    }
}

extension ActionView {
    
    func setup(for config: ActionViewConfiguration, layout: AlertaLayout) {
        
        self.config = config
        self.layout = layout
        
        if let cancel = config.cancelAction, config.style == .actionSheet {
            
            cancelDimmingKnockoutView.layer.compositingFilter = "overlayBlendMode"
            cancelDimmingKnockoutView.backgroundColor = UIColor.white
            cancelDimmingKnockoutView.clipsToBounds = true
            
            self.insert(subviews: [cancelDimmingKnockoutView, cancelBlurView])

            cancelBlurView.contentView.insert(subviews: [cancelContainer])
            
            cancelDimmingKnockoutView.anchor(to: self, insets: (nil, 0, 0, 0))
            
            cancelDimmingKnockoutView.topAnchor.equals(mainDimmingKnockoutView.bottomAnchor, constant: bezel)
            cancelDimmingKnockoutView.heightAnchor.equals(config.style.actionHeight)

            cancelBlurView.anchor(to: cancelDimmingKnockoutView)
            cancelContainer.anchor(to: cancelBlurView.contentView)
            
            let label = UILabel()
            
            label.textAlignment = .center
            label.textColor = layout.textColors[.action(.cancel)]
            label.font = layout.fonts[.action(.cancel)]
            label.text = cancel.title
            label.backgroundColor = UIColor.white
            
            cancelContainer.insert(subviews: [label])
            
            label.anchor(to: cancelContainer)
            
            self.cancelAction = label

        } else {
            mainDimmingKnockoutView.bottomAnchor.equals(self.bottomAnchor)
        }
        if config.headerConfig.hasHeader {
            
            self.body.insert(subviews: [headerContainer])
            
            let header = ActionHeader()
            
            header.setup(for: config.headerConfig, layout: layout)
            
            self.headerContainer.insert(subviews: [header])
            
            header.anchor(to: self.headerContainer)
            
            self.header = header
            
            self.headerContainer.anchor(to: self.body, insets: (0, 0, nil, 0))
            
            self.headerContainer.bottomAnchor.equals(self.separatorView.topAnchor)
        } else {
            self.actionsContainer.topAnchor.equals(self.body.topAnchor)
        }
        func height(actions: Int) {
            
            let visible = (actions > 7) ? 7 : actions

            var height = CGFloat(visible) * config.style.actionHeight + CGFloat(visible - 1) * AlertaLayout.separatorHeight
            
            height += (actions > 7) ? (config.style.actionHeight * 0.3) : 0.0
            
            self.actionsContainer.heightAnchor.equals(height)
        }
        if config.cancelAction != nil && config.style == .actionSheet {
            
            height(actions: config.actionCount - 1)
        } else {
            if config.actionCount == 2 && config.style == .alert {
                
                height(actions: 1)
            }
            height(actions: config.actionCount)
        }
        self.setTargets()
    }
}

extension ActionView {
    
    func insert(table: UIView) {
        
        self.actionsContainer.insert(subviews: [table], at: 10)
        
        table.anchor(to: self.actionsContainer)
    }
}

extension ActionView {
    
    @objc func cancel() {
        
        self.delegate?.cancel()
    }
}


