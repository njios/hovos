//
//  PaymentConfirmVC.swift
//  Hovos
//
//  Created by neeraj joshi on 12/07/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class PaymentConfirmVC: UIViewController {

    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var time:UILabel!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var email:UILabel!
    @IBOutlet weak var photo:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let day = CalenderHelper.shared.dateComponents.day!
        let month = CalenderHelper.shared.getMonth(CalenderHelper.shared.dateComponents.month!)
        let year = CalenderHelper.shared.dateComponents.year!
        
        let minute = CalenderHelper.shared.dateComponents.minute!
        let hour = CalenderHelper.shared.dateComponents.hour!
        let second = CalenderHelper.shared.dateComponents.second!
        if let user = SharedUser.manager.auth.user{
            email.text = "\( email.text!)  \(user.email ?? "")"
            photo.kf.indicatorType  = .activity
            name.text = user.firstName! + " " + user.lastName!
        }
        date.text =  "\(day)-\(month)-\(year)"
        if hour > 12{
        time.text = "\(hour - 12):\(minute):\(second) PM"
        }else{
           time.text = "\(hour):\(minute):\(second) AM"
        }
    }

   
}
