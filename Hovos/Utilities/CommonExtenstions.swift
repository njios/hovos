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
        }else{
        self.dismiss(animated: true, completion: nil)
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


extension String{
    func getDate()->Date{
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self) ?? Date()
    }
}

extension Date{
    func getYear()->String{
        let calenderComp = Calendar.current
        let comp = calenderComp.dateComponents(in: NSTimeZone.local, from: self)
        return "\( comp.year ?? 0 )"
    }
    
    func getMonth()->String{
        let calenderComp = Calendar.current
        let comp = calenderComp.dateComponents(in: NSTimeZone.local, from: self)
        return CalenderMonth.month(month: comp.month ?? 0).getMonth()
    }
    
    func getDay()->String{
        let calenderComp = Calendar.current
        let comp = calenderComp.dateComponents(in: NSTimeZone.local, from: self)
        return "\(comp.day ?? 0)"
    }
}

extension UICollectionView {
    func scrollToNextItem()->Bool {
        if self.contentOffset.x + self.bounds.size.width < self.contentSize.width{
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
            return true
        }else{
            return false
        }
    }

    func scrollToPreviousItem()->Bool {
         if self.contentOffset.x  > 0{
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
              return true
         }else{
            return false
        }
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowRadius = 3
    layer.shadowOffset = .zero
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

func getMonth(_ monthinInt:Int)->String{
    switch monthinInt {
    case 0:
        return "December"
        case 1:
               return "January"
        case 2:
               return "February"
        case 3:
               return "March"
        case 4:
               return "April"
        case 5:
               return "May"
        case 6:
               return "June"
        case 7:
               return "July"
        case 8:
               return "August"
        case 9:
               return "September"
        case 10:
               return "October"
        case 11:
        return "November"
     
        
    default:
        return ""
    }
}
