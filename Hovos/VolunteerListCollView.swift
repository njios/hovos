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
            cell.imageV?.kf.setImage(with: URL(string: modalObject?[indexPath.row].image ?? ""))
             
            
            cell.name?.text = modalObject?[indexPath.row].name
            cell.place?.text = (modalObject?[indexPath.row].location?.country ?? "") + ", " + (modalObject?[indexPath.row].location?.city ?? "")
            
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
        @IBOutlet weak var name:UILabel?
        @IBOutlet weak var place:UILabel?
        @IBOutlet weak var lastSeen_memberSince:UILabel!
        @IBOutlet weak var volunteerSlogan:UILabel!
        @IBOutlet weak var jobs:UILabel!
        @IBOutlet weak var location:UILabel!
        @IBOutlet weak var status:UILabel!
        @IBOutlet weak var schedule:UILabel!
        @IBOutlet weak var language:UILabel!
        @IBOutlet weak var additionalInfo:UILabel!
        @IBOutlet weak var skills:UILabel!
        @IBOutlet weak var placeDescription:UILabel!
        @IBOutlet var verifiedStatus:[UILabel]!
        @IBOutlet var startSelection:[UIImageView]!
        @IBOutlet weak var countryHeight:NSLayoutConstraint!
        @IBOutlet weak var countryTable:UITableView!
        var countries:[String]?
       
    }

    class CountryCell:UITableViewCell{
        @IBOutlet weak var country:UILabel!
    }

extension listCell:UITableViewDelegate,UITableViewDataSource{
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return countries?.count ?? 0
           }
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
            cell.country.text = countries![indexPath.row]
            return cell
           }
           
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
           
       }
