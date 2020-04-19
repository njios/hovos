//
//  ChatViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/20/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
 @IBOutlet weak var chatTable:UITableView!
 @IBOutlet weak var profileImage:UIImageView!
 @IBOutlet weak var name:UILabel!
 var messageItem:MessageModal!
    var chat = [MessageModal]()
    override func viewDidLoad() {
        super.viewDidLoad()
        chat = messageItem.chat!.reversed()
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: URL(string: messageItem.image ?? ""))
        name.text = messageItem.from ?? ""
        // Do any additional setup after loading the view.
    }
    
}

extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageItem.chat?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        let chatItem = chat[indexPath.row]
        
        if chatItem.isMine ?? false{
             cell.name.text = "You wrote..."
            cell.baloonImage.image = UIImage(named:"chatbubbleRight")
            cell.baloonImage.alpha = 0.5
        }else{
             cell.name.text = chatItem.from ?? ""
            cell.baloonImage.image = UIImage(named:"chatbubbleLeft")
            cell.baloonImage.alpha = 1.0
        }
        
       
        cell.data.text = chatItem.text ?? ""
        cell.time.text = chatItem.time ?? ""
        return cell
      
    }
    
    
}

class ChatCell:UITableViewCell{
    @IBOutlet weak var baloonImage:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var data:UILabel!
    @IBOutlet weak var time:UILabel!
}
