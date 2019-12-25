//
//  Dashboardslider.swift
//  Hovos
//
//  Created by Neeraj Joshi on 17/12/2019.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
class Dashboardslider: NSObject, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    var vc:LandingVC!
    var images = ["gardening",
                  "construction",
                  "farm_work",
                  "language_practice",
                  "help_in_the_house",
                  "teaching",
                  "maintenance",
                  "tourist_support2",
                  "elderly_care",
                  "eco_project",
                  "animalcare",
                  "charity",
                  "artproject",
                  "computer",
                  "internetsupport",
                  "child_care",
                  "boating",
                  "pet_sitting",
                  "housesitting",
                  "aupair"]
     var titlesOfimage = ["Gardening Project",
                          "Construction",
                          "Farm Work",
                          "Language practice",
                          "Help in the house",
                          "Teaching projects",
                          "Maintenance tasks",
                          "Tourist support",
                          "Elderly care",
                          "Eco project",
                          "Animal care",
                          "Charity Work",
                          "Art Projects",
                          "Computer",
                          "Internet Support",
                          "Child care",
                          "Boat Handler",
                          "Pet sitting",
                          "House sitting",
                          "Au Pair"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! sliderCell
        cell.image?.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.frame.size.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        vc.nextButton.isUserInteractionEnabled = true
        vc.prevButton.isUserInteractionEnabled = true
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        vc.nextButton.isUserInteractionEnabled = true
               vc.prevButton.isUserInteractionEnabled = true
    }
}

class sliderCell:UICollectionViewCell{
    @IBOutlet weak var image:UIImageView?
}
