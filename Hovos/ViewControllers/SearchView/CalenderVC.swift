//
//  CalenderVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/16/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class CalenderVC: UIViewController {
    @IBOutlet weak var selectdateButton:UIButton!
    @IBOutlet weak var fromDate:UILabel!
    @IBOutlet weak var toDate:UILabel!
    @IBOutlet weak var calender:UITableView!
    var date = 0
    var datesSelected:((_ fromDate:String,_ toDate:String)->())!
    var firstDate:Date!{
        didSet{
            if firstDate != nil{
                fromDate.text = CalenderHelper.shared.mmmddyyy.string(from: firstDate!)
                selectdateButton.alpha = 0.5
                selectdateButton.isUserInteractionEnabled = false
            }else{
                 fromDate.text = "----"
            }
        }
    }
    var last_Date:Date!{
    didSet{
        
        if last_Date != nil{
            toDate.text = CalenderHelper.shared.mmmddyyy.string(from: last_Date!)
            if firstDate != nil{
                selectdateButton.alpha = 1.0
                selectdateButton.isUserInteractionEnabled = true
            }
        }else{
             toDate.text = "----"
        }
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       fromDate.text = "----"
         toDate.text = "----"
                    calender.delegate = self
                    calender.dataSource = self
                    calender.register(UINib(nibName: "CalenderMonthCell", bundle: nil), forCellReuseIdentifier: "CalenderMonthCell")
                    calender.reloadData()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
              
              
    }
    
    @IBAction func selectDateAction(_ sender:UIButton){
        datesSelected(fromDate.text!,toDate.text!)
        goback(sender)
    }
}

extension CalenderVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderMonthCell") as! CalenderMonthCell
        cell.month.text = CalenderHelper.shared.months[indexPath.row] + " \(String(CalenderHelper.shared.dateComponents.year!))"
        cell.dateCollView.delegate = self
        cell.dateCollView.dataSource = self
        cell.dateCollView.isScrollEnabled = false
        cell.dateCollView.reloadData()
        cell.dateCollView.tag = indexPath.row
        date = 0
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       let lastDate =  CalenderHelper.shared.lastDayOfcurrentMonth(month: CalenderHelper.shared.months[indexPath.row])
        
       let firstDay = CalenderHelper.shared.firstDayOfcurrentMonth(month: CalenderHelper.shared.months[indexPath.row])
        
        
        if firstDay > 5 && lastDate == 31{
              return (self.view.frame.size.width/8)*6 + 90
        }
        if firstDay > 6 && lastDate >= 30{
              return (self.view.frame.size.width/8)*6 + 90
        }
        
        return (self.view.frame.size.width/8)*5 + 90
    }
    
    
}

extension CalenderVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderDateCell", for: indexPath) as! CalenderDateCell
           cell.date.text = ""
           cell.isUserInteractionEnabled = false
           cell.date.textColor = .darkGray
        cell.date.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
           let lastDate = CalenderHelper.shared.lastDayOfcurrentMonth(month: CalenderHelper.shared.months[collectionView.tag])
        if CalenderHelper.shared.firstDayOfcurrentMonth(month:CalenderHelper.shared.months[collectionView.tag])-1 <= indexPath.row && date < lastDate{
            date = date + 1
            cell.isUserInteractionEnabled = true
            if date < CalenderHelper.shared.dateComponents.day! && CalenderHelper.shared.months[collectionView.tag] == CalenderHelper.shared.getMonth(CalenderHelper.shared.dateComponents.month!) {
                cell.isUserInteractionEnabled = false
            }else if  date == CalenderHelper.shared.dateComponents.day! && CalenderHelper.shared.months[collectionView.tag] == CalenderHelper.shared.getMonth(CalenderHelper.shared.dateComponents.month!){
                cell.date.backgroundColor = .darkGray
                cell.date.textColor = .white
            }
             cell.date.text = String(date)
            let component = DateComponents(calendar: CalenderHelper.shared.calendar, timeZone: CalenderHelper.shared.calendar.timeZone, era: nil, year: CalenderHelper.shared.dateComponents.year, month: CalenderHelper.shared.getMonth(CalenderHelper.shared.months[collectionView.tag]), day: date, hour: 5, minute: 31, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            cell.realDate = component.date
            if firstDate != nil  {
                if cell.realDate == firstDate {
                cell.date.backgroundColor = UIColor(named : "greenColor")
                cell.date.textColor = .white
            }
            }
            if firstDate != nil && self.last_Date != nil {
                   if cell.realDate >= firstDate && cell.realDate <= self.last_Date{
                       cell.date.backgroundColor = UIColor(named : "greenColor")
                       cell.date.textColor = .white
                   }
                   }
            
            
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width/8) - 1.6, height: (self.view.frame.size.width/8))
      

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalenderDateCell
        if firstDate == nil {
            firstDate = cell.realDate
        }else if firstDate != nil && last_Date == nil {
            last_Date = cell.realDate
        }else if firstDate != nil && last_Date != nil {
             firstDate = cell.realDate
             last_Date = nil
        }
        calender.reloadData()
    }
    
}
