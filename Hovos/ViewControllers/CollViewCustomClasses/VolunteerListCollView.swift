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
            hostVC.object = object
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
            volVC.object = object
           
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
    var modalObject:[VolunteerItem]?
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return modalObject?.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! listCell
            cell.imageV?.image = nil
          
            cell.imageV?.kf.indicatorType = .activity
            cell.imageV?.kf.setImage(with: URL(string: modalObject?[indexPath.row].member?.image?.medium?.replacingOccurrences(of: "medium", with: "small") ?? ""))
             
            
            cell.name?.text = (modalObject?[indexPath.row].member?.firstName ?? "") + " " + (modalObject?[indexPath.row].member?.lastName ?? "")
            
            
            cell.place?.text = (modalObject?[indexPath.row].location?.country ?? "") + ", " + (modalObject?[indexPath.row].location?.city ?? "")
            cell.matching?.text = (modalObject?[indexPath.row].totalMatching ?? "")
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
        @IBOutlet weak var personaldesc:UILabel!
        @IBOutlet weak var photosCount:CustomLabels!
        @IBOutlet weak var language:UILabel!
        @IBOutlet weak var additionalInfo:UILabel!
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
        
        var countries = [String]()
        var imageData = [images]()
        weak var dependency:UIViewController!
        
       
        func AddGesture(){
            let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(tapedOnimage))
               gestureRecogniser.numberOfTapsRequired = 2
               imageV?.addGestureRecognizer(gestureRecogniser)
        }
        
        @objc func tapedOnimage(){
            if imageData.count > 0 {
            let vc = GalleryVC(nibName: "GalleryVC", bundle: nil)
            vc.imageData = imageData
            vc.modalPresentationStyle = .fullScreen
            dependency.present(vc, animated: true, completion: nil)
            }
        }
    }

    class CountryCell:UITableViewCell{
        @IBOutlet weak var country:UILabel!
    }

extension listCell:UITableViewDelegate,UITableViewDataSource{
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return countries.count ?? 0
           }
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
            cell.country.text = countries[indexPath.row]
            return cell
           }
           
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
           
       }
