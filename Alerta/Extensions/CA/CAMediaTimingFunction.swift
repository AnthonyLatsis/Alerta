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
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    }
    static var easeIn: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    }
    static var easeOut: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    }
    static var easeInEaseOut: CAMediaTimingFunction {
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    }
}

