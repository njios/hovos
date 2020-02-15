//
//  HostSearchVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/13/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class HostSearchVC: UIViewController,UITextFieldDelegate,SearchDelegate,Menudelegates {
  
  
    

     @IBOutlet weak var clearButton:UIButton!
     @IBOutlet weak var searchTextView:CustomEditViews!
     @IBOutlet weak var continentView:CustomEditViews!
     @IBOutlet weak var countriesView:CustomEditViews!
     @IBOutlet weak var countries:ContinentView!
     @IBOutlet weak var collView:UICollectionView!
     @IBOutlet weak var heightConstraint:NSLayoutConstraint!
     var vmObject = HostSearchVM()
   
     var searchModel = HostSearchModel(){
        didSet{
            if searchModel.jobs.count > 0 || searchModel.continent != "" || searchModel.exchangeDate != "" || searchModel.searchKeyword != "" {
                clearButton.isHidden = false
            }
            if searchModel.jobs.count == 0 && searchModel.continent == ""  && searchModel.exchangeDate == "" && searchModel.searchKeyword == ""{
                 clearButton.isHidden = true
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries.delegate = self
        countries.host = true
        searchTextView.delegate = self
        continentView.delegate = self
        countriesView.delegate = self
        collView.register(UINib(nibName: "JobsCell", bundle: nil), forCellWithReuseIdentifier: "JobsCell")
        ViewHelper.shared().showLoader(self)
        vmObject.getJobs {
            DispatchQueue.main.async {
                ViewHelper.shared().hideLoader()
                if self.vmObject.jobs != nil{
                    self.collView.delegate = self
                    self.collView.dataSource = self
                    self.collView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.heightConstraint.constant = self.collView.contentSize.height
                }
                }
            }
        }
    }
    
    @objc func jobsSelected(_ sender:UIButton){
        
        if (searchModel.jobs.contains(vmObject.jobs[sender.tag].title ?? "")){
            sender.isSelected = false
            sender.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            
            for i in 0 ..< (searchModel.jobs.count){
                if searchModel.jobs[i] == (vmObject.jobs[sender.tag].title ?? ""){
                searchModel.jobs.remove(at: i)
                break
                }
            }
            
        }else{
            sender.isSelected = true
            sender.backgroundColor = UIColor(named: "orangeColor")
            searchModel.jobs.append(vmObject.jobs[sender.tag].title ?? "")
        }
        
    }
   
    func SearchText(with text: String) {
        searchModel.searchKeyword = text
    }
    
    func showContinent() {
        countries.isHidden = false
      }
      
    func showCountries() {
          
      }
      
    
}

extension HostSearchVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmObject.jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "JobsCell", for: indexPath) as! JobsCell
        cell.jobsItem.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        if searchModel.jobs.contains(vmObject.jobs![indexPath.row].title ?? ""){
            cell.jobsItem.isSelected = true
            cell.jobsItem.backgroundColor = UIColor(named: "orangeColor")
        }else{
            cell.jobsItem.isSelected = false

        }
        cell.jobsItem.setTitle((vmObject.jobs![indexPath.row].title ?? "").capitalized, for: .normal)
        cell.jobsItem.tag = indexPath.row
        cell.jobsItem.addTarget(self, action: #selector(jobsSelected(_:)), for: .touchUpInside)
        
        cell.jobsItem.dropShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2 ), height: 50)
    }
    func menuItemDidSelect(for action: Action) {
           countries.isHidden = true
      }
      
    
}
