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

class NewHosts: NSObject, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    var cache = [String:UIImage]()
    var delegate:ListViewDelegate!
    var modalObject:[VolunteerItem]?
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return modalObject?.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! listCell
          cell.imageV?.image = UIImage(named: "bg")
            if let imageUrl = modalObject?[indexPath.row].image {
          cell.imageV?.kf.indicatorType = .activity
          cell.imageV?.kf.setImage(with: URL(string: imageUrl))
            }else{
                  cell.imageV?.image = UIImage(named: "bg")
            }
          cell.lastSeen.text = "Signed up: \((modalObject?[indexPath.row].addedOn ?? "").getDate().getDay()) \((modalObject?[indexPath.row].addedOn ?? "").getDate().getMonth()) "
            
         
            if SharedUser.manager.auth.role!.lowercased() == "v"{
          cell.name?.text = (modalObject?[indexPath.row].title ?? "")
            }else{
                cell.memberPic?.isHidden = true
              cell.name?.text = (modalObject?[indexPath.row].name ?? "")
          }
            
         if SharedUser.manager.auth.role!.lowercased() == "v"{
                                           cell.name?.textColor = UIColor(named: "orangeColor")
                                       }else{
                           
                                           cell.name?.textColor = UIColor(named: "greenColor")
                                       }
            
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
        delegate.collViewUpdateWithObject(index: indexPath, object: modalObject!, type: "New")
    }
        
    }
