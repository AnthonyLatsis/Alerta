//
//  NSLayoutDimension.swift
//  Anchora
//
//  Created by Anthony Latsis on 2/8/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

import UIKit

internal extension NSLayoutDimension {

    internal func equals(_ constant: CGFloat) {

        self.constraint(equalToConstant: constant).activate()
    }
}

