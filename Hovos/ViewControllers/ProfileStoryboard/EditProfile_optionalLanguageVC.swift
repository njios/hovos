//
//  EditProfile_optionalLanguageVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/30/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_optionalLanguageVC:UIViewController,UITextViewDelegate {

        @IBOutlet weak var textView:UITextView!
        var placeholder = """
    I am Spanish so my main language is Spanish. My English is also very good, but in writing I am not so good
    """
        override func viewDidLoad() {
            super.viewDidLoad()

            if SharedUser.manager.auth.listing?.languageDesc != ""{
                  textView.text = SharedUser.manager.auth.listing?.languageDesc
            }else{
              textView.text = placeholder
            }
            // Do any additional setup after loading the view.
        }
        

        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == ""{
                textView.text = placeholder
            }else{
                SharedUser.manager.auth.listing?.languageDesc = textView.text
            }
        }
    }
