//
//  ViewCustomization.swift
//  Hovos
//
//  Created by Neeraj Joshi on 16/12/2019.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable extension UIView{
    
    @IBInspectable var border:CGFloat{
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    @IBInspectable var corners:CGFloat{
        get{
            return self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    @IBInspectable var borderColor:UIColor?{
        get {
               return UIColor(cgColor: self.layer.borderColor!)
            }
            set {
               self.layer.borderColor = newValue?.cgColor
            }
    }
    
    @IBInspectable var shadow:Bool{
        get{
            return true
        }
        set{
                        if newValue == true{
                            layer.masksToBounds = false
                            layer.shadowColor = UIColor.black.cgColor
                            layer.shadowOpacity = 0.3
                            layer.shadowRadius = 2
                            layer.shadowOffset = .zero
            
                            layer.shouldRasterize = true
                            layer.rasterizationScale = UIScreen.main.scale
                        }
        }
    }
    
    
}
