//
//  CAMediaTimingFunction.swift
//  Laser Nya
//
//  Created by Anthony Latsis on 17.11.16.
//  Copyright © 2016 Anthony Latsis. All rights reserved.
//

import UIKit

internal extension CAMediaTimingFunction {

    static var linear: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .linear)
    }
    static var easeIn: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeIn)
    }
    static var easeOut: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeOut)
    }
    static var easeInEaseOut: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: .easeInEaseOut)
    }
}

