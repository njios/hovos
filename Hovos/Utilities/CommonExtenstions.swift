//
//  CommonExtenstions.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func goToRootVC(){
        if let nvc = self.navigationController{
            nvc.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func goback(_ sender:UIButton){
        if let nvc = self.navigationController{
        nvc.popViewController(animated: true)
        }
    }
    func showProgressAlert(){
        let alert = UIAlertController(title: "No Content", message: "Work in progress.", preferredStyle: .alert)
        let alertaction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alert.addAction(alertaction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func showAlert(_ sender:UIButton){
           if let nvc = self.navigationController{
          showProgressAlert()
           }
       }
    
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
