//
//  CustomEditViews.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/13/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit

protocol SearchDelegate {
    func SearchText(with text:String)
    func showContinent()
    func showCountries()
}
extension SearchDelegate{
    func showContinent(){
        
    }
}

@IBDesignable
class CustomEditViews:UIView,UITextFieldDelegate{
    private var keybord = true
    @IBOutlet weak var serachText:UITextField!
    @IBOutlet weak var img:UIImageView!
    @IBInspectable var isKeyBordVisible: Bool {
        set{
            keybord = newValue
        }get{
            return keybord
        }
    }
    
    @IBInspectable var placeHolder: String {
        set{
            serachText.attributedPlaceholder = NSAttributedString(string: newValue,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
         
        }get{
            return serachText.attributedPlaceholder!.string
        }
    }
    
    @IBInspectable var image: UIImage {
           set{
               img.image = newValue
           }get{
            return img.image!
           }
       }
    var delegate:SearchDelegate!
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           commonInit()
       }
       
       private func commonInit(){
           let vc = Bundle.main.loadNibNamed("CustomEditViews", owner: self, options: nil)?[0] as? UIView
        vc?.frame.size.width = self.frame.width
        vc?.frame.size.height = self.frame.height
           self.addSubview(vc!)
    
       }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isKeyBordVisible == false{
            textField.resignFirstResponder()
        }
        if self.tag == 222{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                textField.resignFirstResponder()
            }
            
            delegate?.showContinent()
        }
        if self.tag == 333{
           DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                   textField.resignFirstResponder()
               }
            delegate?.showCountries()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        if self.tag == 111{
        delegate?.SearchText(with: textField.text!)

        textField.resignFirstResponder()
        }
    }
}
