//
//  NSLayoutDimension.swift
//  Anchora
//
//  Created by Anthony Latsis on 2/8/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

import UIKit

internal extension NSLayoutDimension {
    @discardableResult internal func equals(_ constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalToConstant: constant).active()
    }
}

