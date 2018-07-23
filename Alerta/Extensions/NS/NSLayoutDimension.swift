//
//  NSLayoutDimension.swift
//  Anchora
//
//  Created by Anthony Latsis on 2/8/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

import UIKit

internal extension NSLayoutDimension {
    @discardableResult func equals(_ constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(equalToConstant: constant).active()
    }

    @discardableResult func lessOrEquals(_ constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(lessThanOrEqualToConstant: constant).active()
    }

    @discardableResult func greaterOrEquals(_ constant: CGFloat) -> NSLayoutConstraint {
        return self.constraint(greaterThanOrEqualToConstant: constant).active()
    }
}

