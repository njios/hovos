//
//  MessageVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 5/11/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class MessageVC: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var titleText:UILabel!
    @IBOutlet weak var messageView:UITextView!
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var sendButton:UIButton!
    var user:VolunteerItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.text = "Contact \(user.member?.firstName ?? "")"
        messageView.text = "Write a message to \(user.member?.firstName ?? "") to help you with your project..."
        
        if SharedUser.manager.auth.role == "H"{
            headerView.backgroundColor = UIColor(named: "greenColor")
            sendButton.backgroundColor = UIColor(named: "greenColor")
        }
        
        if SharedUser.manager.auth.role == "V"{
            headerView.backgroundColor = UIColor(named: "orangeColor")
            sendButton.backgroundColor = UIColor(named: "orangeColor")
        }
        
//        if SharedUser.manager.auth.role == "H"{
//            sendButton.backgroundColor = UIColor(named: "orangeColor")
//        }
//        
//        if SharedUser.manager.auth.role == "V"{
//            sendButton.backgroundColor = UIColor(named: "greenColor")
//        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendMessage(_ sender:UIButton){
        if let messageView = messageView.text{
            
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "id":SharedUser.manager.auth.user?.listingId ?? "",
                          "API_KEY":constants.Api_key.rawValue]
            
            
            let postData = NSMutableData(data: "text=\(messageView)".data(using: String.Encoding.utf8)!)
            postData.append("&receiverId=\(user.memberId ?? "")".data(using: String.Encoding.utf8)!)
            postData.append("&receiverListingId=\(user.id ?? "")".data(using: String.Encoding.utf8)!)
            
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
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "", message: error?.localizedDescription, preferredStyle: .alert)
                        let btn = UIAlertAction(title: "Close", style: .default, handler: nil)
                        alert.addAction(btn)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        ViewHelper.shared().hideLoader()
                        self.dismiss(animated: true) {
                            let alert = UIAlertController(title: "", message: "Message sent successfully", preferredStyle: .alert)
                            let btn = UIAlertAction(title: "Close", style: .default, handler: nil)
                            alert.addAction(btn)
                            topViewController()?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            })
            
            dataTask.resume()
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write a message to \(user.member?.firstName ?? "") to help you with your project..."{
            textView.text = ""
        }
    }
    
}
