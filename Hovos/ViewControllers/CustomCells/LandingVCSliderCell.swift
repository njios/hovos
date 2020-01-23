//
//  LandingVCSliderCell.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 1/23/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class LandingVCSliderCell: UITableViewCell {
    
    @IBOutlet weak var sliderCollView:UICollectionView!
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var prevButton:UIButton!
    @IBOutlet weak var sliderTitle:CustomLabels!
    @IBOutlet weak var sliderSubTitle:UILabel!
    var sliderIndex = 0
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
    override func awakeFromNib() {
        super.awakeFromNib()
        sliderTitle.text = titlesOfimage[sliderIndex]
        sliderSubTitle.text = sliderTitle.text! + "Detail comming soon"
         sliderTitle.isComplete = true
        sliderCollView.delegate = self
        sliderCollView.dataSource = self
        sliderCollView.reloadData()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func nextSlide(_ sender:UIButton){
        sender.isUserInteractionEnabled = false
        if self.sliderCollView.scrollToNextItem(){
            sliderIndex = sliderIndex + 1
            sliderTitle.text = titlesOfimage[sliderIndex]
             sliderSubTitle.text = sliderTitle.text! + "Detail comming soon"
            sliderTitle.isComplete = true
          
        }
        
        
    }
    @IBAction func prevSlide(_ sender:UIButton){
                sender.isUserInteractionEnabled = false
        if self.sliderCollView.scrollToPreviousItem(){
            sliderIndex = sliderIndex - 1
            sliderTitle.text = titlesOfimage[sliderIndex]
             sliderSubTitle.text = sliderTitle.text! + "Detail comming soon"
             sliderTitle.isComplete = true
          
          
        }
       }
    
}
extension LandingVCSliderCell: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
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
        nextButton.isUserInteractionEnabled = true
        prevButton.isUserInteractionEnabled = true
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        nextButton.isUserInteractionEnabled = true
        prevButton.isUserInteractionEnabled = true
    }
}

class sliderCell:UICollectionViewCell{
    @IBOutlet weak var image:UIImageView?
}
