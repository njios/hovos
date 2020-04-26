//
//  EditProfile_AboutYouselfVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/26/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import DropDown
class EditProfile_AboutYouselfVC: UIViewController,UITextViewDelegate {
 
@IBOutlet weak var descriptionText:UITextView!
@IBOutlet weak var agebutton:UIButton!
@IBOutlet weak var genderButton:UIButton!
let dropDown = DropDown()
var placeholder = "Tell a bit yourself. Your hosts are interested to know what kind of person you are. Write a few words about your work, education, hobbies and what drives you."
    override func viewDidLoad() {
        super.viewDidLoad()
        if  EditProfile.sharedManger().profilePassById.describeYourself == ""{
        descriptionText.text = placeholder
        }else{
             EditProfile.sharedManger().profilePassById.describeYourself = descriptionText.text
        }
        
        agebutton.setTitle(EditProfile.sharedManger().profilePassById.age, for: .normal)
        genderButton.setTitle(EditProfile.sharedManger().profilePassById.gender, for: .normal)
        // Do any additional setup after loading the view.
    }

    func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text == ""{
               textView.text = placeholder
           }else{
               EditProfile.sharedManger().profilePassById.describeYourself = textView.text
           }
       }
       
       func textViewDidBeginEditing(_ textView: UITextView) {
           if  textView.text == placeholder{
           textView.text = ""
           }
       }
    
    @IBAction func ageSelected(_ sender:UIButton){
        dropDown.anchorView =  sender // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        var ages = [String]()
        for i in 18..<80{
            ages.append(String(i))
        }
        dropDown.dataSource = ages
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        EditProfile.sharedManger().profilePassById.age = item
            self.dropDown.hide()
            self.agebutton.setTitle(EditProfile.sharedManger().profilePassById.age, for: .normal)
                 }
        dropDown.show()
    }
    
    @IBAction func genderSelected(_ sender:UIButton){
        dropDown.anchorView = sender // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["male", "female"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            EditProfile.sharedManger().profilePassById.gender = item
            self.genderButton.setTitle(EditProfile.sharedManger().profilePassById.gender, for: .normal)
            self.dropDown.hide()
        }
          dropDown.show()
    }
       
}
