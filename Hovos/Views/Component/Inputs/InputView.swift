//
//  InputView.swift
//  Hovos
//
//  Created by neeraj joshi on 13/07/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit

protocol InputViewDelegates {
    func secureActionPressed(textField:UITextField)
}
extension InputViewDelegates{
    func secureActionPressed(textField:UITextField){
        textField.isSecureTextEntry = !textField.isSecureTextEntry
    }
}

@IBDesignable
class InputView:UIView,InputViewDelegates{
    
    @IBOutlet weak var titleImage:UIImageView!
    @IBOutlet weak var inputTextView:UITextField!
    @IBOutlet weak var actionButton:UIButton!
    private var title_image:UIImage!
    private var input_text:String!
    private var action_button_image:UIImage!
    
    var delegate:InputViewDelegates!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.frame = super.frame
    }
    
    @IBInspectable var leftIcon:UIImage?{
        get{
            return title_image
        }
        set{
            title_image = newValue
        }
    }
    
    @IBInspectable var textFieldPlaceHolder:String?{
        get{
            return input_text
        }
        set{
            
            input_text = newValue
        }
    }
    
    @IBInspectable var actionButtonImage:UIImage?{
        get{
            return action_button_image
        }
        set{
            
            action_button_image = newValue
        }
    }
    
    @IBAction func actionButtonClicked(_ sender:UIButton){
        if (delegate == nil){
            delegate = self
        }
        delegate.secureActionPressed(textField: inputTextView)
    }
    
}
