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
    
    func setUnderLine(){
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
      
    }
    
    
}


class CustomButtons: UIButton {
    
    @IBInspectable var isComplete:Bool = false{
        didSet{
            let data = self.titleLabel?.text?.split(separator: " ")
            let yourAttributes = [NSAttributedString.Key.foregroundColor: self.titleLabel?.textColor! ?? UIColor.white, NSAttributedString.Key.font: self.titleLabel?.font! ?? UIFont.systemFont(ofSize: 15),NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
            let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: self.titleLabel?.textColor, NSAttributedString.Key.font: self.titleLabel?.font!]
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
                    self.titleLabel?.attributedText = combination
                }else{
                    let partOne = NSMutableAttributedString(string: String(data![0]), attributes: yourAttributes as [NSAttributedString.Key : Any])
                    let partTwo = NSMutableAttributedString(string: " "+complete, attributes: yourAttributes as [NSAttributedString.Key : Any])
                    let combination = NSMutableAttributedString()
                    combination.append(partOne)
                    combination.append(partTwo)
                    self.titleLabel?.attributedText = combination
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

func imageWith(name: String?) -> UIImage? {
     let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
     let nameLabel = UILabel(frame: frame)
     nameLabel.textAlignment = .center
     nameLabel.backgroundColor = UIColor(named: "orangeColor")
     nameLabel.textColor = .white
     nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
     nameLabel.text = name
    nameLabel.layer.cornerRadius = 15
    nameLabel.layer.masksToBounds = true
     UIGraphicsBeginImageContext(frame.size)
      if let currentContext = UIGraphicsGetCurrentContext() {
         nameLabel.layer.render(in: currentContext)
         let nameImage = UIGraphicsGetImageFromCurrentImageContext()
         return nameImage
      }
      return nil
}
