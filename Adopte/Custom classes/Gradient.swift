//
//  Gradient.swift
//  Maya
//
//  Created by Ptitin Light on 20/10/2020.
//  Copyright © 2020 Faustin Veyssiere. All rights reserved.
//

import UIKit

@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor  = #colorLiteral(red: 0.1477041224, green: 0.3442277977, blue: 0.6148004491, alpha: 1) { didSet { updateColors() }}
    @IBInspectable var middleColor:  UIColor  = #colorLiteral(red: 0.07944549912, green: 0.1851495324, blue: 0.3306822297, alpha: 1) { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor  = #colorLiteral(red: 0.1051751115, green: 0.1151767614, blue: 0.1999193753, alpha: 1) { didSet { updateColors() }}
    @IBInspectable var startLocation: Double  =  0.00   { didSet { updateLocations() }}
    @IBInspectable var middleLocation: Double =  0.50   { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double  =  1.00   { didSet { updateLocations() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, middleLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, middleColor.cgColor, endColor.cgColor]
    }
}

