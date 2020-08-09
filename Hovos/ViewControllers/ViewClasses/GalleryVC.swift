//
//  GalleryVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/10/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Kingfisher
class GalleryVC: UIViewController {

    @IBOutlet weak var headerView:ThemeView!
    @IBOutlet weak var titleOfImage:UILabel!
    @IBOutlet weak var nameOfUser:UILabel!
    @IBOutlet weak var countOfImager:UILabel!
    @IBOutlet weak var image:UIImageView!
    var imageData = [images]()
    var name:String!
    var role = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if role == "V"{
            headerView.backgroundColor = UIColor(named: "greenColor")
        }else  if role == "H"{
             headerView.backgroundColor = UIColor(named: "orangeColor")
        }
        nameOfUser.text = "\(name!)'s images"
       let leftGestureRecogniser  = UISwipeGestureRecognizer(target: self, action: #selector(swipeMethod(gesture:)))
        leftGestureRecogniser.direction = UISwipeGestureRecognizer.Direction.left
         self.view.addGestureRecognizer(leftGestureRecogniser)
        let rightGestureRecogniser  = UISwipeGestureRecognizer(target: self, action: #selector(swipeMethod(gesture:)))
        rightGestureRecogniser.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightGestureRecogniser)
        image.kf.indicatorType = .activity
        image.kf.setImage(with: URL(string: imageData[0].medium ?? ""))
        image.tag = 0
        titleOfImage.text = imageData[0].title ?? ""
        countOfImager.text = "\(image.tag+1)/\(imageData.count)"
        // Do any additional setup after loading the view.
    }
    
    @objc func swipeMethod(gesture: UISwipeGestureRecognizer){
     
        switch gesture.direction {
        case .right:
            image.tag = (image.tag - 1) < 0 ? 0 : (image.tag - 1)
            image.kf.indicatorType = .activity
            image.kf.setImage(with: URL(string: imageData[image.tag].medium ?? ""))
            titleOfImage.text = imageData[image.tag].title ?? ""
            countOfImager.text = "\(image.tag+1)/\(imageData.count)"
        case .left:
            image.tag = (image.tag + 1) >= imageData.count ? imageData.count - 1 : (image.tag + 1)
            image.kf.indicatorType = .activity
            image.kf.setImage(with: URL(string: imageData[image.tag].medium ?? ""))
            titleOfImage.text = imageData[image.tag].title ?? ""
             countOfImager.text = "\(image.tag+1)/\(imageData.count)"
        default:
            break
        }
    }
    

}
