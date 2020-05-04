//
//  EditProfile_HostNeedVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 5/4/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_HostNeedVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var listingTitleTextView:UITextView!
    @IBOutlet weak var describeTextField:UITextView!
    @IBOutlet weak var volunteerSlider:UISlider!
    @IBOutlet weak var worksHour:UISlider!
    @IBOutlet weak var worksDay:UISlider!
    var titlePlaceholder = "Example: Cozy farm needs help with milking"
    var describePlaceholder = "Example: We are the proud owners of a Chateau in the heart of Champagne region, surrounded by 25 hectares of land. we are making wine and champagne using traditional methosa. During the harvest season we need help for picking the grapes and processing it. We need someone who can assis us a bit with setting up a website about our farm."
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         var volImage = imageWith(name: "1")
         var hoursImage = imageWith(name: "1")
         var dayImage = imageWith(name: "1")
        
        if let value = SharedUser.manager.auth.listing?.volunteers {
            volImage = imageWith(name: value)
            volunteerSlider.value = Float(Int(value) ?? 1)
        }
        if let value = SharedUser.manager.auth.listing?.workingHours {
            hoursImage = imageWith(name: value)
               worksHour.value = Float(Int(value) ?? 1)
        }
        
        if let value = SharedUser.manager.auth.listing?.workingDays {
            dayImage = imageWith(name: value)
               worksDay.value = Float(Int(value) ?? 1)
            
        }
        
         volunteerSlider.setThumbImage(volImage, for: .normal)
         worksHour.setThumbImage(hoursImage, for: .normal)
         worksDay.setThumbImage(dayImage, for: .normal)
         
        
         listingTitleTextView.text = SharedUser.manager.auth.listing?.title
         describeTextField.text = SharedUser.manager.auth.listing?.description
    }

    @IBAction func volunterSliderAction(_ sender:UISlider){
        let img = imageWith(name: String(Int(sender.value)))
        SharedUser.manager.auth.listing?.volunteers = String(Int(sender.value))
        sender.setThumbImage(img, for: .normal)
    }
    
    @IBAction func workHoursSliderAction(_ sender:UISlider){
        let value =  String(Int(sender.value))
          let img = imageWith(name: value)
        SharedUser.manager.auth.listing?.workingHours = value
          sender.setThumbImage(img, for: .normal)
    }
    
    @IBAction func worksDaySliderAction(_ sender:UISlider){
          let value =  String(Int(sender.value))
          let img = imageWith(name: value)
        SharedUser.manager.auth.listing?.workingDays = value
          sender.setThumbImage(img, for: .normal)
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == listingTitleTextView{
            if textView.text == titlePlaceholder{
                textView.text = ""
            }
        }else{
            if textView.text == describePlaceholder{
                textView.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == listingTitleTextView{
            if textView.text == ""{
                textView.text = titlePlaceholder
            }else{
                SharedUser.manager.auth.listing?.title = textView.text
            }
        }else{
            if textView.text == ""{
                textView.text = describePlaceholder
            }else{
                 SharedUser.manager.auth.listing?.description = textView.text
            }
        }
    }
    
}
