//
//  Nose.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class Nose: UIImageView, CritterAnimatable {
    private let p1 = CGPoint(x: -10.2, y: -4.2)
    private let p2 = CGPoint(x: -20.6, y: -1.2)

    convenience init() {
        self.init(image: UIImage.Critter.nose)
        frame = CGRect(x: p1.x, y: p1.y, width: 78, height: 19.6)
    }

    // MARK: - CritterAnimatable
    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)
    }
    
    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }
}
