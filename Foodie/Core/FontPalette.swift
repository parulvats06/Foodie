//
//  FontPalette.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//
import UIKit

public enum Fonts {
    
    public enum Weight {
        case regular
        case light
        case bold
    }
    
    public enum Size: UInt {
        case xxxLarge = 24
        case xxLarge = 22
        case xLarge = 20
        case large = 18
        case medium = 16
        case small = 14
        case xSmall = 10
        case xxSmall = 8
        
        public var pointSize: CGFloat {
            return CGFloat(rawValue)
        }
    }
    
    public static func regular(_ size: Size) -> UIFont {
        return font(weight: .regular, size: size)
    }
    
    public static func light(_ size: Size) -> UIFont {
        return font(weight: .light, size: size)
    }
    
    public static func condensed(_ size: Size) -> UIFont {
        return font(weight: .bold, size: size)
    }

    private static func font(weight: Weight, size: Size) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "HeroLight-Regular", size: size.pointSize)!
        case .light:
            return UIFont(name: "HeroLight-Light", size: size.pointSize)!
        case .bold:
            return UIFont(name: "HeroLight-Bold", size: size.pointSize)!
        }
    }
}
