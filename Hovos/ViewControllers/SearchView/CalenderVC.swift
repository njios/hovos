//
//  CalenderVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/16/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class CalenderVC: UIViewController {

    @IBOutlet weak var fromDate:UILabel!
    @IBOutlet weak var toDate:UILabel!
    @IBOutlet weak var calender:UITableView!
    var date = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
                    calender.delegate = self
                    calender.dataSource = self
                    calender.register(UINib(nibName: "CalenderMonthCell", bundle: nil), forCellReuseIdentifier: "CalenderMonthCell")
                    calender.reloadData()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
              
              
    }
    
    @IBAction func selectDateAction(_ sender:UIButton){
        
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
        cell.dateCollView.reloadData()
        cell.dateCollView.tag = indexPath.row
        date = 0
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.size.width/8)*5 + 90
    }
    
    
}

extension CalenderVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderDateCell", for: indexPath) as! CalenderDateCell
           cell.date.text = ""
           let lastDate = CalenderHelper.shared.lastDayOfcurrentMonth(month: CalenderHelper.shared.months[collectionView.tag])
        if CalenderHelper.shared.firstDayOfcurrentMonth(month:CalenderHelper.shared.months[collectionView.tag])-1 <= indexPath.row && date < lastDate{
            date = date + 1
             cell.date.text = String(date)
             
        }
       
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width/8) - 1.6, height: (self.view.frame.size.width/8))
      

    }
    
}
