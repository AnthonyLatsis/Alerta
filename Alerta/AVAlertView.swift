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
}

extension AVAlertView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        if let style = style {
//            let location = touches[touches.startIndex].location(in: self)
//            if !self.alertContainer.frame.contains(location) && style == .actionSheet {
//                self.delegate?.tap()
//            }
//        }
    }
}
