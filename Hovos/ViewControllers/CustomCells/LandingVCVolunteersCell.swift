//
//  LandingVCVolunteersCell.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 1/27/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class LandingVCVolunteersCell: UITableViewCell {
      
     @IBOutlet weak var collView:UICollectionView!
     weak var VMObject:LandingVM!
     var listDelegates = VolunteerListCollView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func getVolunteers(vc:LandingVC){
        VMObject.getVolunteerList { (Volunteers) in
            DispatchQueue.main.async {
                self.listDelegates.modalObject = Volunteers
                self.listDelegates.delegate = vc
                self.collView.delegate = self.listDelegates
                self.collView.dataSource = self.listDelegates
                self.collView.reloadData()
            }
        }
     }
}
