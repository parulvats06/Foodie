//
//  ColorPalette.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//
import UIKit

extension UIColor {
    convenience init(rgbaValue: UInt32) {
        let red = CGFloat((rgbaValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbaValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbaValue & 0xFF)/256.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// foodie pink
    static let foodiePink = UIColor(rgbaValue: 0xD87D7D)
    
    /// foodie gray
    static let foodieGray = UIColor(rgbaValue: 0x9B9B9B)
    
    /// foodie green
    static let foodieGreen = UIColor(rgbaValue: 0x16B957)
    
    /// foodie red
    static let foodieRed = UIColor(rgbaValue: 0xCF1010)
}
