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
    var images = ["artproject",
                  "aupair",
                  "internetsupport",
                  "housesitting",
                  "animalcare",
                  "boating",
                  "charity",
                  "child_care",
                  "computer",
                  "construction",
                  "eco_project",
                  "elderly_care",
                  "farm_work",
                  "gardening",
                  "help_in_the_house",
                  "language_practice",
                  "maintenance",
                  "pet_sitting",
                  "teaching",
                  "tourist_support2",
                  "music_practice",
                  "hostel_support",
                  "spiritual",
                  "forest_work"
                 ]
    
    var titlesOfimage = [ "Art Projects",
                          "Au Pair",
                          "Internet Support",
                          "House sitting",
                          "Animal care",
                          "Boat Handler",
                          "Charity Work",
                          "Child care",
                          "Computer",
                          "Construction",
                          "Eco project",
                          "Elderly care",
                          "Farm Work",
                          "Gardening Project",
                          "Help in the house",
                          "Language practice",
                          "Maintenance tasks",
                          "Pet sitting",
                          "Teaching projects",
                          "Tourist support",
                          "Music Practice",
                          "Hostel Support",
                          "Spiritual Projects",
                          "Forest Work"
                     ]
    
    var detailOfImage = [  "Put your creativity to work and create art while you volunteer.",
                           "if you have experience with children, this volunteer opportunity is perfect!",
                           "Internet Savvy? Help your host with their online projects and websites.",
                           "Experience life around the world as you take care of someone\'s home.",
                           "Work with a variety of animals in exchange for room and board.",
                           "Boating experience? Put it to good use and volunteer with these hosts.",
                           "Help others and make a difference while you travel around the globe.",
                           "Good with kids? Volunteer and experience family life in a new country.",
                           "Put your tech skills to use and volunteer in exchange for room and board.",
                           "Volunteer to help with construction and renovation projects as you travel.",
                           "Use your passion for the environment to help you see the world!",
                           "Assist the elderly with day to day tasks and explore in your time off.",
                           "Volunteer at farms around the world in exchange for room and board.",
                           "Green thumb? Volunteer to help with gardening and landscaping projects.",
                           "Save money while you travel by helping out around the house!",
                           "Teach your language or participate in language exchange opportunities!",
                           "Help with repairs and maintenance and save money while you travel!",
                           "Love Animals? Volunteer to care for pets and explore in your free time.",
                           "Have valuable skills? Teach music, languages, art, etc… as you travel.",
                           "Get to know people from around the world as you volunteer and travel.",
                           "Teach music and instruments to your hosts and share what you love.",
                           "Work in vibrant tourist hubs in exchange for room and board.",
                           "Volunteer with these hosts for unique experiences and opportunities.",
                           "Volunteer for forestry projects and enjoy the beautiful countryside."
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sliderTitle.text = titlesOfimage[sliderIndex]
        sliderSubTitle.text = detailOfImage[sliderIndex]
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
            sliderSubTitle.text = detailOfImage[sliderIndex]
            sliderTitle.isComplete = true
            
        }else{
            sliderIndex = 0
            sliderTitle.text = titlesOfimage[sliderIndex]
            sliderSubTitle.text = detailOfImage[sliderIndex]
            sliderTitle.isComplete = true
            let contentOffset = CGFloat(0.0)
            self.sliderCollView.moveToFrame(contentOffset: contentOffset)
           
        }
        
        
    }
    @IBAction func prevSlide(_ sender:UIButton){
        sender.isUserInteractionEnabled = false
        if self.sliderCollView.scrollToPreviousItem(){
            sliderIndex = sliderIndex - 1
            sliderTitle.text = titlesOfimage[sliderIndex]
            sliderSubTitle.text = detailOfImage[sliderIndex]
            sliderTitle.isComplete = true
            
            
        }else{
            sliderIndex = titlesOfimage.count - 1
            sliderTitle.text = titlesOfimage[sliderIndex]
            sliderSubTitle.text = detailOfImage[sliderIndex]
            sliderTitle.isComplete = true
            self.sliderCollView.setContentOffset(CGPoint(x:(self.sliderCollView.contentSize.width - self.sliderCollView.frame.width) , y: 0.0), animated: true)
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
