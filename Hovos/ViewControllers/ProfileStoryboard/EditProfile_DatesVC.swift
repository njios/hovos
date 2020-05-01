//
//  EditProfile_DatesVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/27/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_DatesVC: UIViewController {

    @IBOutlet weak var fromLabel:UILabel!
    @IBOutlet weak var toLabel:UILabel!
    @IBOutlet weak var anytime:UIButton!
    @IBOutlet weak var dateRange:UIButton!
     @IBOutlet weak var datesView:UIView!
     @IBOutlet weak var cancelView:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        anytime.isSelected = true
               dateRange.isSelected = false
               datesView.isHidden = true
               cancelView.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func showCalender(_ sender:UIButton){
           anytime.isSelected = false
           dateRange.isSelected = true
        datesView.isHidden = false
        cancelView.isHidden = false
           let vc = CalenderVC(nibName: "CalenderVC", bundle: nil)
        
           vc.datesSelected = { fromDate,toDate in
               self.fromLabel.text = fromDate
               self.toLabel.text = toDate
         
           }
           vc.modalPresentationStyle = .overCurrentContext
           self.present(vc, animated: false, completion: nil)
       }
   
    @IBAction func anySelection(_ sender:UIButton){
        anytime.isSelected = true
        dateRange.isSelected = false
        datesView.isHidden = true
        cancelView.isHidden = true
    }

}
