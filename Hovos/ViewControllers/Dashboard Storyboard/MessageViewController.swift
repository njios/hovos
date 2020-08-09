//
//  MessageViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/19/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var emptyImage:UIImageView!
    @IBOutlet weak var noMssg:UIButton!
    @IBOutlet weak var noChat:UIButton!
    @IBOutlet weak var dataTable:UITableView!
    var messages:[MessageModal]!
    override func viewDidLoad() {
        super.viewDidLoad()
        noChat.setTitle("CHATS (0)", for: .normal)
        noMssg.setTitle("MESSAGES (0)", for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMessages()
    }
    
    @IBAction func messageClicked(_ sender:UIButton){
        emptyImage.image = UIImage(named: "NoMssg")
        if messages.count != 0{
            dataTable.isHidden = false
            emptyImage.isHidden = true
            dataTable.reloadData()
        }
        
    }
    
     
    
    @IBAction func chatClicked(_ sender:UIButton){
        emptyImage.image = UIImage(named: "Nochat")
        self.dataTable.isHidden = true
        self.emptyImage.isHidden = false
    }
    
    func getMessages(){
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.user?.listingId ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var messagesPacket = NetworkPacket()
        messagesPacket.apiPath = ApiEndPoints.getMessages.rawValue
        messagesPacket.header = header
        messagesPacket.method = "GET"
        ViewHelper.shared().showLoader(self)
        ApiCall(packet: messagesPacket) { (data, status, code) in
            ViewHelper.shared().hideLoader()
            if code == 200{
                DispatchQueue.main.async {
                    self.messages = try? JSONDecoder().decode([MessageModal].self, from: data!)
                    self.dataTable.delegate = self
                    self.dataTable.dataSource = self
                    self.dataTable.reloadData()
                    self.noChat.setTitle("CHATS (0)", for: .normal)
                    self.noMssg.setTitle("MESSAGES (\(self.messages.count))", for: .normal)
                }
                
                
            }else{
                self.dataTable.isHidden = true
                self.emptyImage.isHidden = false
            }
        }
    }
    
    
    
    
}

extension MessageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.count == 0{
            tableView.isHidden = true
            emptyImage.isHidden = false
        }else{
            emptyImage.isHidden = true
        }
        return messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeessageCell") as! MeessageCell
        let messageItem = messages[indexPath.row]
        cell.profileImage.kf.indicatorType = .activity
        cell.profileImage.kf.setImage(with: URL(string: messageItem.image ?? ""))
        
        cell.name.text = messageItem.from ?? ""
        cell.place.text = (messageItem.country ?? "") + ", " + (messageItem.city ?? "")
        cell.place.text!.first == "," ? cell.place.text!.removeFirst() : cell.place.text!.first
        cell.mssgData.text = messageItem.text ?? ""
        
        if messageItem.isRead ?? false {
            cell.mssgIcon.image = UIImage(named: "mail_read")
        }else{
            cell.mssgIcon.image = UIImage(named: "mail_unread")
        }
        
        if messageItem.isMine ?? false{
            cell.mssgIcon.image = UIImage(named: "mail_sent")
        }
        cell.date.text = (messageItem.date ?? "").getDate().getMonth() + " " + (messageItem.date ?? "").getDate().getDay()
        cell.date.text = cell.date.text! + ", " + (messageItem.time ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let messageItem = messages[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.messageItem = messageItem
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

class MeessageCell:UITableViewCell{
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var mssgIcon:UIImageView!
    @IBOutlet weak var place:UILabel!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var mssgData:UILabel!
}
