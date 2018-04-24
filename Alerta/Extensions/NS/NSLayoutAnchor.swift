//
//  NSLayoutAnchor.swift
//  Anchora
//
//  Created by Anthony Latsis on 2/13/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

import UIKit

internal extension NSLayoutAnchor {
    
    @objc internal func equals(_ anchor: NSLayoutAnchor<AnchorType>, multiplier m: CGFloat = 1.0, constant c: CGFloat = 0.0) {
        
        self.constraint(equalTo: anchor, constant: c).with(m: m).activate()
    }
}

