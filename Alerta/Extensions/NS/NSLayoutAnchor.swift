//
//  NSLayoutAnchor.swift
//  Alerta
//
//  Created by Anthony Latsis on 2/13/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

import UIKit.NSLayoutAnchor

internal extension NSLayoutAnchor {

    @objc @discardableResult
    func equals(_ anchor: NSLayoutAnchor<AnchorType>,
                constant c: CGFloat = 0) -> NSLayoutConstraint {

        return constraint(equalTo: anchor,
                          constant: c).active()
    }

    @objc @discardableResult
    func lessOrEquals(_ anchor: NSLayoutAnchor<AnchorType>,
                      constant c: CGFloat = 0) -> NSLayoutConstraint {

        return constraint(lessThanOrEqualTo: anchor,
                          constant: c).active()
    }

    @objc @discardableResult
    func greaterOrEquals(_ anchor: NSLayoutAnchor<AnchorType>,
                         constant c: CGFloat = 0) -> NSLayoutConstraint {

        return constraint(greaterThanOrEqualTo: anchor,
                          constant: c).active()
    }
}

