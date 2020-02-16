//
//  CalenderMonthCell.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/16/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
class CalenderMonthCell:UITableViewCell{
@IBOutlet weak var dateCollView:UICollectionView!
@IBOutlet weak var month:UILabel!
    
    override func awakeFromNib() {
        dateCollView.register(UINib(nibName: "CalenderDateCell", bundle: nil), forCellWithReuseIdentifier: "CalenderDateCell")
    }
}
