//
//  EditProfile_ExchangeDealVc.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 5/4/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_ExchangeDealVc: UIViewController,UITextViewDelegate {

    @IBOutlet var mealOptions:[UIButton]!
    @IBOutlet var paymentOptions:[UIButton]!
    @IBOutlet weak var mealdescription:UITextView!
    @IBOutlet weak var paymentDescription:UITextView!
    @IBOutlet weak var accDescription:UITextView!
    var mealPlaceHolder = "Example: We'll prepare lunch and dinner, but you'll have to prepare breakfast yourself."
    var paymentPlaceholder = "Describe in your own words if money applies to the work to be done"
    var accPlaceholder = "Example: Two rooms in the house with its own lock are available for the volunteers. In the room you have wifi, a tv, a comfortable bed and your own bathroom as well."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if let descString = SharedUser.manager.auth.listing?.mealDescription, descString != "" {
            mealdescription.text =  descString
        }else{
            mealdescription.text = mealPlaceHolder
        }
        
        if let paymentdesc = SharedUser.manager.auth.listing?.paymentDescription, paymentdesc != ""{
            paymentDescription.text =  paymentdesc
        }else{
            paymentDescription.text = paymentPlaceholder
        }
        
        if let accDesc = SharedUser.manager.auth.listing?.accDescription, accDesc != ""{
            accDescription.text =  accDesc
        }else{
            accDescription.text = accPlaceholder
        }
        
        if SharedUser.manager.auth.listing?.paymentOption != nil{
            paymentOptions[(Int(SharedUser.manager.auth.listing?.paymentOption ?? "1") ?? 1)-1].isSelected = true
               }else{
                    paymentOptions[0].isSelected = true
               }
        if SharedUser.manager.auth.listing?.mealsOption != nil{
        mealOptions[(Int(SharedUser.manager.auth.listing?.mealsOption ?? "1") ?? 1)-1].isSelected = true
           }else{
                mealOptions[0].isSelected = true
           }
        
    }
    
    @IBAction func mealUpdate(_ sender:UIButton){
        for item in mealOptions{
            item.isSelected = false
        }
        mealOptions[sender.tag-1].isSelected = true
        SharedUser.manager.auth.listing?.mealsOption = String(sender.tag)
    }
    
    @IBAction func paymentUpdate(_ sender:UIButton){
        for item in paymentOptions{
                   item.isSelected = false
               }
        paymentOptions[sender.tag-1].isSelected = true
        SharedUser.manager.auth.listing?.paymentOption = String(sender.tag)
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == mealdescription{
            if textView.text == mealPlaceHolder{
                textView.text = ""
            }
        }
        if textView == accDescription{
            if textView.text == accPlaceholder{
                textView.text = ""
            }
        }
        if textView == paymentDescription{
            if textView.text == paymentPlaceholder{
                textView.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == mealdescription{
            if textView.text == "" {
                textView.text = mealPlaceHolder
            }else{
                SharedUser.manager.auth.listing?.mealDescription = textView.text
            }
        }
        if textView == accDescription{
            if textView.text == ""{
                textView.text = accPlaceholder
            }else{
                SharedUser.manager.auth.listing?.accDescription = textView.text
            }
        }
        if textView == paymentDescription{
            if textView.text == ""{
                textView.text = paymentPlaceholder
            }else{
                SharedUser.manager.auth.listing?.paymentDescription = textView.text
            }
        }
    }
}
