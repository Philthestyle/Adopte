//
//  PaddingLabel.swift
//  Maya
//
//  Created by Faustin Veyssiere on 25/03/2021.
//  Copyright © 2021 Faustin Veyssiere. All rights reserved.
//

import Foundation
import UIKit


class PaddingLabel: UILabel {
    
    @IBInspectable var iPhoneFontSize:CGFloat = 0 {
        didSet {
            overrideFontSize(fontSize: iPhoneFontSize)
        }
    }
    
    func overrideFontSize(fontSize:CGFloat){
        let currentFontName = self.font.fontName
        var calculatedFont: UIFont?
        
        switch UIDevice.current.screenType {
        case .iPhones_X_XS, .iPhone_11Pro, .iPhone_XR_11, .iPhone_XSMax_ProMax, .iPhones_6Plus_6sPlus_7Plus_8Plus:
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.9)
            self.font = calculatedFont
            break
            
        case .iPhones_6_6s_7_8:
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.8)
            self.font = calculatedFont
            break
            
        case .iPhones_4_4S:
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.4)
            self.font = calculatedFont
            break
        case .iPhones_5_5s_5c_SE:
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.7)
            self.font = calculatedFont
            break
        case .iPhone_12_Mini:
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.9)
            self.font = calculatedFont
            break
        default:
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 1.3)
            self.font = calculatedFont
            break
        }
        
        
        
    }
    
    var insets = UIEdgeInsets.zero
    
    func padding(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}

