//
//  NSLayoutConstraint.swift
//  Alerta
//
//  Created by Anthony Latsis on 2/10/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

import UIKit.NSLayoutConstraint

internal extension NSLayoutConstraint {

    func active() -> NSLayoutConstraint {
        isActive = true
        return self
    }
}
