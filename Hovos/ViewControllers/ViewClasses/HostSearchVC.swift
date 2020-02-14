//
//  HostSearchVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/13/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class HostSearchVC: UIViewController {

    @IBOutlet weak var collView:UICollectionView!
     @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.register(UINib(nibName: "JobsCell", bundle: nil), forCellWithReuseIdentifier: "JobsCell")
        collView.delegate = self
        collView.dataSource = self
        collView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heightConstraint.constant = self.collView.contentSize.height
        }
        // Do any additional setup after loading the view.
    }
    
}

extension HostSearchVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "JobsCell", for: indexPath) as! JobsCell
        cell.jobsItem.setTitle("Test", for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2 ), height: 50)
    }
    
}
