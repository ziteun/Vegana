//
//  LeftEar.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 4/15/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class LeftEar: UIImageView, CritterAnimatable {
    private let p1 = CGPoint(x: 5.1, y: -18.3)
    private let p2 = CGPoint(x: 1.1, y: -12.2)
    
    convenience init() {
        self.init(image: UIImage.Critter.leftEar)
        frame = CGRect(x: p1.x, y: p1.y, width: 36.6, height: 36.6)
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
            .rotate(.z, by: -4.0.degrees)
    }
}
