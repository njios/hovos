//
//  MembershipVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/27/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class MembershipVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var historyHieght:NSLayoutConstraint!
    @IBOutlet weak var historyTable:UITableView!
    @IBOutlet weak var holdSwitch:UISwitch!
     @IBOutlet weak var status:UILabel!
    var transaction:[Transactions]!{
        didSet{
            DispatchQueue.main.async {
                if self.transaction.count == 0{
                    self.historyTable.isHidden = true
                }
                self.historyTable.dataSource = self
                self.historyTable.delegate = self
                self.historyTable.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        status.text = (SharedUser.manager.auth.listing?.status ?? "") + ", free member"
        
        if (SharedUser.manager.auth.listing?.status ?? "") == "onhold"{
            holdSwitch.isOn = true
        }
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                                           "id":SharedUser.manager.auth.user?.listingId ?? "",
                                           "API_KEY":constants.Api_key.rawValue]
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.transactions.rawValue
        packet.method = "GET"
        packet.header = header
        
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                self.transaction = try! JSONDecoder().decode([Transactions].self, from: data!)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchAction(_ sender:UISwitch){
    
          var packet = NetworkPacket()
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                                           "id":SharedUser.manager.auth.user?.listingId ?? "",
                                           "API_KEY":constants.Api_key.rawValue]
                    
                      packet.apiPath = ApiEndPoints.volunteerStatus.rawValue
             
                      packet.header =  header
                      packet.method = "POST"
                      
        switch sender.tag{
        case 0:
          //  packet.data = ["action":"active"]
            break
        case 1:
            if sender.isOn {
            packet.data = ["action":"onhold"]
            }else{
                   packet.data = ["action":"active"]
            }
            break
        case 2:
            packet.data = ["action":"inactive"]
            break
        default:
            break
        }
        ApiCallWithJsonEncoding(packet: packet) { (data, status, code) in
            print(status,code)
            if sender.isOn {
                        SharedUser.manager.auth.listing?.status = "onhold"
                       }else{
                               SharedUser.manager.auth.listing?.status = "active"
                       }
           
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transaction.count >= 3{
            historyHieght.constant = 250
        }else{
            historyHieght.constant = CGFloat(50 * transaction.count)
        }
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        return transaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionCell
        cell.type.text = transaction[indexPath.row].title ?? ""
        cell.date.text  = transaction[indexPath.row].date ?? ""
        cell.amountcurrency1.text = (transaction[indexPath.row].currency ?? "") + " " + (transaction[indexPath.row].amount ?? "")
         cell.amountcurrency2.text = (transaction[indexPath.row].currency ?? "") + " " + (transaction[indexPath.row].amount ?? "")
        return cell
    }

}

struct Transactions:Codable{
    
        var title:String!
        var date: String!
        var amount: String!
        var currency: String!
        var userAmount: String!
        var userCurrency: String!
        var method: String!
        var ccExpiry: String!
        var ccNumber: String!
}

class TransactionCell:UITableViewCell{
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var type:UILabel!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var amountcurrency1:UILabel!
    @IBOutlet weak var amountcurrency2:UILabel!
}
