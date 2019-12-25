//
//  CustomLabels.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/25/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
class CustomLabels: UILabel {
    
    @IBInspectable var isComplete:Bool = false{
        didSet{
            let data = self.text?.split(separator: " ")
                let yourAttributes = [NSAttributedString.Key.foregroundColor: self.textColor!, NSAttributedString.Key.font: self.font!,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
                let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: self.textColor, NSAttributedString.Key.font: self.font]
               var complete = ""
               for i in 1..<data!.count{
                   complete = complete + data![i] + " "
               }
                if isComplete == false{
                
                let partOne = NSMutableAttributedString(string: String(data![0]), attributes: yourAttributes as [NSAttributedString.Key : Any])
                let partTwo = NSMutableAttributedString(string: " "+complete, attributes: yourOtherAttributes as [NSAttributedString.Key : Any])
                let combination = NSMutableAttributedString()
                combination.append(partOne)
                combination.append(partTwo)
                self.attributedText = combination
                }else{
                    let partOne = NSMutableAttributedString(string: String(data![0]), attributes: yourAttributes as [NSAttributedString.Key : Any])
                    let partTwo = NSMutableAttributedString(string: " "+complete, attributes: yourAttributes as [NSAttributedString.Key : Any])
                    let combination = NSMutableAttributedString()
                    combination.append(partOne)
                    combination.append(partTwo)
                    self.attributedText = combination
                }
                
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
      
    }
    
    
}
