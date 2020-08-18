//
//  VolunteerListCollView.swift
//  Hovos
//
//  Created by Neeraj Joshi on 17/12/2019.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import ExpandableLabel

protocol ListViewDelegate {
    func collViewdidUpdate(index:IndexPath)
    func collViewUpdateWithObject(index:IndexPath,object:[VolunteerItem],type:String)
    
}
extension ListViewDelegate{
    
    func collViewUpdateWithObject(index:IndexPath,object:[VolunteerItem],type:String){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if SharedUser.manager.auth.user?.role!.lowercased() == "v"{
            let hostVC = storyBoard.instantiateViewController(withIdentifier: "HostsVC") as! HostsVC
            hostVC.indexpath = index
            hostVC.object.hosts = object
            
            if type == "New"{
                hostVC.showMatching = false
            }else{
                hostVC.showMatching = true
            }
            
            if let vc =  getNavigationController(){
                vc.pushViewController(hostVC, animated: false)
                //vc.present(hostVC, animated: false, completion: nil)
            }
            
        }else{
            
            let volVC = storyBoard.instantiateViewController(withIdentifier: "VolunteerVC") as! VolunteerVC
            volVC.indexpath = index
            volVC.object?.travellers = object
            
            if type == "New"{
                volVC.type = .latest
            }
            
            if type == "nearBy"{
                volVC.type = .neraby
            }
            
            if type == "Recom"{
                volVC.type = .recommended
            }
            
            if let vc =  getNavigationController(){
                vc.pushViewController(volVC, animated: false)
                //  vc.present(volVC, animated: false, completion: nil)
            }
        }
        
    }
}
class VolunteerListCollView: NSObject, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    var cache = [String:UIImage]()
    var delegate:ListViewDelegate!
    var modalObject:Volunteer? = Volunteer()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modalObject?.travellers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! listCell
        cell.imageV?.image = nil
        
        cell.imageV?.kf.indicatorType = .activity
        cell.imageV?.kf.setImage(with: URL(string: modalObject?.travellers![indexPath.row].member?.image?.medium ?? ""))
        
        
        
        cell.name?.text = (modalObject?.travellers![indexPath.row].member?.firstName ?? "") + " " + (modalObject?.travellers![indexPath.row].member?.lastName ?? "")
        
        
        cell.place?.text = (modalObject?.travellers![indexPath.row].location?.country ?? "") + ", " + (modalObject?.travellers![indexPath.row].location?.city ?? "")
        cell.matching?.text = (modalObject?.travellers![indexPath.row].totalMatching ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0{
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height )
        }else{
            return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.height )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.collViewdidUpdate(index: indexPath)
    }
    
}

class listCell:UICollectionViewCell{
    @IBOutlet weak var imageV:UIImageView?
    @IBOutlet weak var memberPic:UIImageView?
    @IBOutlet weak var name:UILabel?
    @IBOutlet weak var place:CustomLabels?
    @IBOutlet weak var lastSeen_memberSince:UILabel!
    @IBOutlet weak var volunteerSlogan:UILabel!
    @IBOutlet weak var jobs:UILabel!
    @IBOutlet weak var location:UILabel!
    @IBOutlet weak var status:UILabel!
    @IBOutlet weak var schedule:UILabel!
    @IBOutlet weak var year:UILabel!
    @IBOutlet weak var language2:UILabel!
    @IBOutlet weak var lastSeen:UILabel!
    @IBOutlet weak var personaldesc:ExpandableLabel!
    @IBOutlet weak var photosCount:CustomLabels!
    @IBOutlet weak var language:UILabel!
    @IBOutlet weak var additionalInfo:ExpandableLabel!
    @IBOutlet weak var mealDesc:UILabel!
    @IBOutlet weak var skills:UILabel!
    @IBOutlet weak var placeDescription:UILabel!
    @IBOutlet weak var paymentDescription:UILabel!
    @IBOutlet weak var hoursLabel:UILabel!
    @IBOutlet weak var daysLabel:UILabel!
    @IBOutlet var verifiedStatus:[UILabel]!
    @IBOutlet var startSelection:[UIImageView]!
    @IBOutlet weak var countryHeight:NSLayoutConstraint!
    @IBOutlet weak var countryTable:UITableView!
    @IBOutlet weak var photosCollview:UICollectionView!
    @IBOutlet weak var photosHeight:NSLayoutConstraint!
    @IBOutlet weak var matching:UILabel!
    @IBOutlet weak var countryButton:UIButton!
    @IBOutlet weak var aboutMelabel:UILabel!
    //Reviews Outlet
    @IBOutlet weak var reviewsTitle:UILabel!
    @IBOutlet weak var liked:UIButton!
    @IBOutlet weak var disliked:UIButton!
    @IBOutlet weak var reviewsTable:UITableView!
    @IBOutlet weak var reviewsHieght:NSLayoutConstraint!
    
    var reviews = [review](){
        didSet{
            
            reviewsTitle?.text = "Reviews (\(reviews.count))"
            reviewsTable?.tag = 100
            reviewsHieght?.constant = CGFloat(reviews.count * 300)
            reviewsTable.reloadData()
           
        }
    }
    
    var countries = [String]()
    var imageData = [images](){
        didSet{
            
        }
    }
    var imageMain = ""
    var nameText = ""
    var role = ""
    weak var dependency:UIViewController!
    
    override func awakeFromNib() {
        personaldesc?.numberOfLines = 3
        personaldesc?.collapsed = true
        
        let attributedString = NSMutableAttributedString(string:"read more")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "orangeColor")  , range: NSRange(location: 0, length: attributedString.length))
        personaldesc?.collapsedAttributedLink = attributedString
        
       
        
    }
    
    
    
    func AddGesture(){
        
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(tapedOnimage))
        gestureRecogniser.numberOfTapsRequired = 2
        imageV?.addGestureRecognizer(gestureRecogniser)
    }
    
    @objc func tapedOnimage(){
        removeNil()
        if imageData.count > 0{
            let vc = GalleryVC(nibName: "GalleryVC", bundle: nil)
            
            if role == "V"{
                vc.role = "V"
            }
            vc.imageData = imageData
            vc.name = nameText
            vc.modalPresentationStyle = .fullScreen
            dependency.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func openTheGallery(_ sender:UIButton){
        removeNil()
        if imageData.count > 0{
        let vc = GalleryVC(nibName: "GalleryVC", bundle: nil)
        vc.role = "H"
        vc.imageData =  imageData
        vc.name = nameText
        vc.modalPresentationStyle = .fullScreen
        dependency?.present(vc, animated: true, completion: nil)
        }
    }
    
    
    private func removeNil(){
        imageData = imageData.filter({ (img) -> Bool in
            if img.medium != nil{
                return true
            }else{
                return false
            }
        })
    }
}

class CountryCell:UITableViewCell{
    @IBOutlet weak var country:UILabel!
}
class ReviewCell:UITableViewCell{
    @IBOutlet weak var memberPic:UIImageView!
    @IBOutlet weak var memberName:UILabel!
    @IBOutlet weak var reviewDate:UILabel!
    @IBOutlet weak var review:UILabel!
    
    
}

extension listCell:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100{
            return reviews.count
        }else{
            return countries.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100{
            let reviewItem = reviews[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
            cell.memberPic.kf.indicatorType = .activity
            cell.memberPic.kf.setImage(with: URL(string: reviewItem.member?.image?.medium ?? ""))
            cell.reviewDate.text = reviewItem.time ?? ""
            cell.memberName.text = (reviewItem.member?.firstName ?? "") 
            cell.review.text = reviewItem.review ?? ""
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
            cell.country.text = countries[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 100{
            return 300.0
        }else{
            return 30.0
        }
    }
    
}
