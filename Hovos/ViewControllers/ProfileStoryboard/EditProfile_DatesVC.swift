//
//  EditProfile_DatesVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/27/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_DatesVC: UIViewController {

   
    @IBOutlet weak var anytime:UIButton!
    @IBOutlet weak var dateRange:UIButton!
    @IBOutlet weak var datesView1:UIView!
    @IBOutlet weak var datesView2:UIView!
    @IBOutlet weak var datesView3:UIView!
    @IBOutlet weak var cancelView:UIButton!
    @IBOutlet weak var cancelView1:UIButton!
    @IBOutlet weak var cancelView2:UIButton!
    @IBOutlet weak var fromLabel:UILabel!
    @IBOutlet weak var toLabel:UILabel!
    @IBOutlet weak var fromLabel2:UILabel!
    @IBOutlet weak var toLabel2:UILabel!
    @IBOutlet weak var fromLabel3:UILabel!
    @IBOutlet weak var toLabel3:UILabel!
    @IBOutlet weak var addDateButton:UIButton!
    var step = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        anytime.isSelected = true
               dateRange.isSelected = false
               datesView1.isHidden = true
               datesView2.isHidden = true
               datesView3.isHidden = true
          addDateButton.isHidden = true
        
        if let schedules = SharedUser.manager.auth.listing?.schedules{
            anytime.isSelected = false
            dateRange.isSelected = true
            
               if schedules.count == 0{
            anytime.isSelected = true
            dateRange.isSelected = false
            }
           
            if schedules.count > 0{
                datesView1.isHidden = false
                self.fromLabel.text = schedules[0].start ?? ""
                self.toLabel.text = schedules[0].end ?? ""
                 addDateButton.isHidden = false
            }
            if schedules.count > 1{
                datesView2.isHidden = false
                self.fromLabel2.text = schedules[1].start ?? ""
                self.toLabel2.text = schedules[1].end ?? ""
                 addDateButton.isHidden = false
            }
            if schedules.count > 2{
                 datesView3.isHidden = false
                self.fromLabel3.text = schedules[2].start ?? ""
                self.toLabel3.text = schedules[2].start ?? ""
                 addDateButton.isHidden = true
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func showCalender(_ sender:UIButton){
        step = 1
          addDateButton.isHidden = false
           anytime.isSelected = false
           dateRange.isSelected = true
        datesView1.isHidden = false
        cancelView.isHidden = false
        SharedUser.manager.auth.listing?.isFlaxibleDates = "N"
           let vc = CalenderVC(nibName: "CalenderVC", bundle: nil)
        
           vc.datesSelected = { fromDate,toDate in
               self.fromLabel.text = fromDate
               self.toLabel.text = toDate
            SharedUser.manager.auth.listing?.schedules?.append(Schedules(end: toDate, start: fromDate))
         
           }
           vc.modalPresentationStyle = .overCurrentContext
           self.present(vc, animated: false, completion: nil)
       }
   
    @IBAction func showCalender2(_ sender:UIButton){
           
           
              let vc = CalenderVC(nibName: "CalenderVC", bundle: nil)
           
              vc.datesSelected = { fromDate,toDate in
                  self.fromLabel2.text = fromDate
                  self.toLabel2.text = toDate
                SharedUser.manager.auth.listing?.schedules?.append(Schedules(end: toDate, start: fromDate))
            
              }
              vc.modalPresentationStyle = .overCurrentContext
              self.present(vc, animated: false, completion: nil)
          }
    
    @IBAction func showCalender3(_ sender:UIButton){
           
       
              let vc = CalenderVC(nibName: "CalenderVC", bundle: nil)
           
              vc.datesSelected = { fromDate,toDate in
                  self.fromLabel3.text = fromDate
                  self.toLabel3.text = toDate
                SharedUser.manager.auth.listing?.schedules?.append(Schedules(end: toDate, start: fromDate))
            
              }
              vc.modalPresentationStyle = .overCurrentContext
              self.present(vc, animated: false, completion: nil)
          }
    
    @IBAction func anySelection(_ sender:UIButton){
        anytime.isSelected = true
        dateRange.isSelected = false
        datesView1.isHidden = true
        datesView2.isHidden = true
        datesView3.isHidden = true
        SharedUser.manager.auth.listing?.isFlaxibleDates = "Y"
        SharedUser.manager.auth.listing?.schedules?.removeAll()
    }

       @IBAction func addDate(_ sender:UIButton){
        
        if datesView1.isHidden{
             datesView1.isHidden = false
        }
        else if datesView2.isHidden{
            datesView2.isHidden = false
        }
        else if datesView3.isHidden{
             datesView3.isHidden = false
        }
        
        if datesView3.isHidden == false && datesView1.isHidden == false && datesView2.isHidden == false{
            addDateButton.isHidden = true
        }
    }
    
    @IBAction func removeDate(_ sender:UIButton){
       
        switch sender.tag {
        case 0:
            SharedUser.manager.auth.listing?.schedules?.remove(at: 0)
            datesView1.isHidden = true
         
            addDateButton.isHidden = false
            self.fromLabel.text = "Start date"
            self.toLabel.text = "End Date"
            case 1:
            SharedUser.manager.auth.listing?.schedules?.remove(at: 1)
            datesView2.isHidden = true
           
            addDateButton.isHidden = false
            self.fromLabel2.text = "Start date"
            self.toLabel2.text = "End Date"
            case 2:
                
            SharedUser.manager.auth.listing?.schedules?.remove(at: 2)
            datesView3.isHidden = true
            
            addDateButton.isHidden = false
            self.fromLabel3.text = "Start date"
            self.toLabel3.text = "End Date"
        default:
            break
        }
    }
}
