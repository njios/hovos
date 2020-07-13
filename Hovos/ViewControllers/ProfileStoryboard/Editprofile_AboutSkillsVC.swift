//
//  Editprofile_AboutSkillsVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/26/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class Editprofile_AboutSkillsVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var textView:UITextView!
    var placeholder = """
[Example]
I am travelling through Europe and I would like to get involved with project and help along the way. I want to learn new skills and use my current skills to help others. I am a quick learner and really love meetings others and share good moments.
"""
    override func viewDidLoad() {
        super.viewDidLoad()

        if SharedUser.manager.auth.listing?.skillDescription != "" && SharedUser.manager.auth.listing?.skillDescription != nil{
              textView.text = SharedUser.manager.auth.listing?.skillDescription
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
            SharedUser.manager.auth.listing?.skillDescription = textView.text
        }
    }
}
