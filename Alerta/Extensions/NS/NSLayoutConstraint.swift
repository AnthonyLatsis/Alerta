//
//  NSLayoutConstraint.swift
//  Anchora
//
//  Created by Anthony Latsis on 2/10/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

import UIKit

internal extension NSLayoutConstraint {

    func with(m: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint.init(item: self.firstItem as Any, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: m, constant: self.constant)
    }

    func active() -> NSLayoutConstraint {
        isActive = true
        return self
    }

    func inactive() -> NSLayoutConstraint {
        isActive = false
        return self
    }
}
