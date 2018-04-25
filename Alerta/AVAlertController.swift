//
//  AVAlertController.swift
//  Extractor
//
//  Created by Anthony Latsis on 4/28/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit
//
//public class AVAlertController: UIViewController {
//    
//    fileprivate var presentationWindow: UIWindow?
//    
//    fileprivate let mainView: AVAlertView
//    
//    
//    fileprivate let actionController: ActionController
//    
//    
//    fileprivate(set) var actions: [AlertActionItem] = []
//    
//    fileprivate var cancelAction: AlertActionItem?
//    
//    let style: AVAlertControllerStyle
//    
//    
//    public init(title: String?, message: String?, style: AVAlertControllerStyle, layout: AlertaLayout = AlertaLayout()) {
//        
//        self.mainView = AVAlertView.init(style: style)
//        
//        if style == .actionSheet {
//            
//            self.actionController = ActionController.init(title: title, message: message, style: .actionSheet, layout: layout)
//        } else {
//           self.actionController = ActionController.init(title: title, message: message, style: .alert, layout: layout)
//        }
//        self.style = style
//        
//        super.init(nibName: nil, bundle: nil)
//        
//        self.actionController.delegate = self
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

//
//extension AVAlertController: ActionControllerDelegate {
//
//    func action(index: Int) {
//
//        if index == -1 {
//            self.dismiss(animated: true, completion: nil)
//        } else {
//            if let handler = (actions[index] as! AVAlertAction).handler {
//                self.dismiss(animated: true, completion: handler)
//            } else {
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//}
//
//extension AVAlertController: AVAlertViewDelegate {
//
//    func tap() {
//
//        self.dismiss(animated: true, completion: nil)
//    }
//}
