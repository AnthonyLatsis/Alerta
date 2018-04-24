//
//  AVAlertView.swift
//  Alerta
//
//  Created by Anthony Latsis on 4/28/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

protocol AVAlertViewDelegate: class {
    
    func tap()
}

class AVAlertView: UIView {
    
    weak var delegate: AVAlertViewDelegate?
    
    
    fileprivate let actionSheetIndent: CGFloat = bezel * 1.5
    
    fileprivate let alertIndent: CGFloat = UIScreen.main.bounds.width * 0.15
    
    
    fileprivate let alertContainer = UIView()
    
    
    fileprivate var style: AVAlertControllerStyle?
    
    init(style: AVAlertControllerStyle) {
        
        self.style = style
        
        super.init(frame: CGRect.zero)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AVAlertView: View {
    
    func setUI() {
        
        alertContainer.backgroundColor = .clear
        
        self.insert(subviews: [alertContainer], at: 10)
    }
    
    func setConstraints() {
        
        if style == .actionSheet {
            
            if UIDevice.current.orientation.isLandscape {
                
                alertContainer.bottomAnchor.equals(self.bottomAnchor, constant: -bezel)
                alertContainer.widthAnchor.equals(UIScreen.main.bounds.height * 0.5 - bezel * 2)
                alertContainer.centerXAnchor.equals(self.centerXAnchor)
            } else {
                alertContainer.anchor(to: self, insets: (nil, bezel, bezel, bezel))
            }
        } else {
            if UIDevice.current.orientation.isPortrait {
                
                alertContainer.leftAnchor.equals(self.leftAnchor)
                alertContainer.rightAnchor.equals(self.rightAnchor)
            } else {
                alertContainer.widthAnchor.equals(UIScreen.main.bounds.width * 0.45)
                alertContainer.centerXAnchor.equals(self.centerXAnchor)
            }
            alertContainer.centerYAnchor.equals(self.centerYAnchor)
        }
    }
}

extension AVAlertView {
    
    func insert(alert: UIView) {
        
        alertContainer.insert(subviews: [alert], at: 10)
        
        alertContainer.heightAnchor.equals(alert.heightAnchor)
        
        alert.anchor(to: self.alertContainer)
    }
}

extension AVAlertView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let style = style {
            let location = touches[touches.startIndex].location(in: self)
            if !self.alertContainer.frame.contains(location) && style == .actionSheet {
                self.delegate?.tap()
            }
        }
    }
}

extension AVAlertView {
    
    func alertContainerHeight(for transitionContext: UIViewControllerContextTransitioning) -> CGFloat {
        return alertContainer.bounds.height
    }
}
