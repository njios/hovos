//
//  ChatViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/20/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITextViewDelegate {
 @IBOutlet weak var chatTable:UITableView!
 @IBOutlet weak var profileImage:UIImageView!
 @IBOutlet weak var name:UILabel!
 @IBOutlet weak var textViewContainer:UIView!
@IBOutlet weak var messageText:UITextView!
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
    
    @IBAction func sentClicked(_ sender:UIButton){
        if let messageText = messageText.text{
            
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                                "id":SharedUser.manager.auth.user?.listingId ?? "",
                                "API_KEY":constants.Api_key.rawValue]
        

            let postData = NSMutableData(data: "text=\(messageText)".data(using: String.Encoding.utf8)!)
            postData.append("&receiverId=\(messageItem.memberId ?? "")".data(using: String.Encoding.utf8)!)
            postData.append("&receiverListingId=\(messageItem.listingId ?? "")".data(using: String.Encoding.utf8)!)

            let request = NSMutableURLRequest(url: NSURL(string: "https://www.hovos.com/api/user/message/")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = header
            request.httpBody = postData as Data

            let session = URLSession.shared
            ViewHelper.shared().showLoader(self)
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
              if (error != nil) {
                print((error?.localizedDescription) ?? "")
              } else {
               
                print(String(data: data!, encoding: .utf8) ?? "")
                DispatchQueue.main.async {
                    self.messageText.text = "Write a message"
                    ViewHelper.shared().hideLoader()
                }
                }
            })

            dataTask.resume()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write a message"{
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Write a message"
        }
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

extension ChatViewController{
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        textViewContainer.constraints.forEach { (constraints) in
            if constraints.firstAttribute == .height{
                constraints.constant = estimateSize.height + 10
            }
        }
    }
}


class ChatCell:UITableViewCell{
    @IBOutlet weak var baloonImage:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var data:UILabel!
    @IBOutlet weak var time:UILabel!
}
