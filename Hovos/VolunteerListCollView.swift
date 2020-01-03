//
//  VolunteerListCollView.swift
//  Hovos
//
//  Created by Neeraj Joshi on 17/12/2019.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
class VolunteerListCollView: NSObject, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    var cache = [String:UIImage?]()
    var modalObject:[VolunteerItem]?
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return modalObject?.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! listCell
            cell.imageV?.image = nil
          
            
                if self.cache.contains(where: { (k,v) -> Bool in
                               if self.modalObject?[indexPath.row].member?.id ?? String(indexPath.row) == k {
                                   return true
                               }else{
                                   return false
                               }
                           }){
                   
                        cell.imageV?.image = self.cache[self.modalObject?[indexPath.row].member?.id ?? String(indexPath.row)]!
                
                           }else{
                    DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string:(self.modalObject?[indexPath.row].image)!)!)
                let image = UIImage(data: data ?? Data())
                self.cache[self.modalObject?[indexPath.row].member?.id ?? String(indexPath.row)] = image
                DispatchQueue.main.async {
                  cell.imageV?.image = self.cache[self.modalObject?[indexPath.row].member?.id ?? String(indexPath.row)]!
                }
            }
            }
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
        
    }

    class listCell:UICollectionViewCell{
        @IBOutlet weak var imageV:UIImageView?
        @IBOutlet weak var name:UILabel?
        @IBOutlet weak var place:UILabel?
    }
