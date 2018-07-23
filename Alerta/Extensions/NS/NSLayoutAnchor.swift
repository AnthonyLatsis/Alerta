//
//  NSLayoutAnchor.swift
//  Anchora
//
//  Created by Anthony Latsis on 2/13/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

import UIKit

internal extension NSLayoutAnchor {

    @objc @discardableResult func equals(_ anchor: NSLayoutAnchor<AnchorType>, multiplier m: CGFloat = 1, constant c: CGFloat = 0) -> NSLayoutConstraint {

        return constraint(equalTo: anchor, constant: c).with(m: m).active()
    }

    @objc @discardableResult func lessOrEquals(_ anchor: NSLayoutAnchor<AnchorType>, multiplier m: CGFloat = 1, constant c: CGFloat = 0) -> NSLayoutConstraint {

        return constraint(lessThanOrEqualTo: anchor, constant: c).with(m: m).active()
    }

    @objc @discardableResult func greaterOrEquals(_ anchor: NSLayoutAnchor<AnchorType>, multiplier m: CGFloat = 1, constant c: CGFloat = 0) -> NSLayoutConstraint {

        return constraint(greaterThanOrEqualTo: anchor, constant: c).with(m: m).active()
    }
}

