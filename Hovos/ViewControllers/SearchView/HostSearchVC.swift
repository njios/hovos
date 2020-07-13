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
     @IBOutlet weak var fromLabel:UILabel!
     @IBOutlet weak var toLabel:UILabel!
     @IBOutlet weak var anytime:UIButton!
     @IBOutlet weak var dateRange:UIButton!
     @IBOutlet weak var searchTextView:CustomEditViews!
     @IBOutlet weak var continentView:CustomEditViews!
     @IBOutlet weak var countriesView:CustomEditViews!
     @IBOutlet weak var countries:ContinentView!
     @IBOutlet weak var collView:UICollectionView!
     @IBOutlet weak var heightConstraint:NSLayoutConstraint!
     var vmObject = HostSearchVM()
    weak var dependency:HostsVC!
    var copySearchModel:HostSearchModel!
     var searchModel = HostSearchModel(){
        didSet{
            if searchModel.jobs.count > 0 || searchModel.conti != nil || searchModel.dt != nil || searchModel.qs != nil {
                continentView.serachText.text = searchModel.continent
                countriesView.serachText.text = searchModel.countries.joined(separator: ",")
                
                clearButton.isHidden = false
            }
            if searchModel.jobs.count == 0 && searchModel.conti == nil  && searchModel.dt == nil && searchModel.qs == nil{
                 clearButton.isHidden = true
            }
         }
    }
    var startSearch:((_ modal:HostSearchModel)->())!
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
    
    @IBAction func clearClicked(_ sender:UIButton){
        searchModel = HostSearchModel()
        searchTextView.serachText.text = ""
        continentView.serachText.text = ""
        countriesView.serachText.text = ""
        anytime.isSelected = true
        dateRange.isSelected = false
        self.fromLabel.text = "Start Date"
        self.toLabel.text = "End Date"
        collView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if copySearchModel != nil{
               searchModel = copySearchModel
               }
        
               if let value = searchModel.qs, value != ""{
                   searchTextView.serachText.text = value
               }
               
               if searchModel.continent != "" {
                   continentView.serachText.text = searchModel.continent
               }
               if searchModel.countries.count > 0 {
                   countriesView.serachText.text = searchModel.countries.joined(separator: ",")
               }
               
               if let value = searchModel.dt,value != "" {
                   self.fromLabel.text = String(searchModel.dt.split(separator: "|").first!)
                   self.toLabel.text = String(searchModel.dt.split(separator: "|").last!)
                anytime.isSelected = false
                                  dateRange.isSelected = true
               }else{
                anytime.isSelected = true
                      dateRange.isSelected = false
        }
               
               collView.reloadData()
    }
    
    @objc func jobsSelected(_ sender:UIButton){
        
        if (searchModel.jobsArray.contains(vmObject.jobs[sender.tag].title ?? "")){
            sender.isSelected = false
            sender.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
           
            for i in 0 ..< (searchModel.jobsArray.count){
                if searchModel.jobsArray[i] == (vmObject.jobs[sender.tag].title ?? ""){
                searchModel.jobsArray.remove(at: i)
                    searchModel.jobs.remove(at: i)
                break
                }
            }
            
        }else{
            sender.isSelected = true
            sender.backgroundColor = UIColor(named: "orangeColor")
            searchModel.jobs.append(vmObject.jobs[sender.tag].value ?? "")
            searchModel.jobsArray.append(vmObject.jobs[sender.tag].title ?? "")
        }
     
        print("--->",searchModel.jobsArray.joined(separator: "|"))
        print("--->",searchModel.jobs)
    }
   
    func SearchText(with text: String) {
        searchModel.qs = text
    }
    
    func showContinent() {
        countries.isHidden = false
      }
      
    func showCountries() {
           countries.isHidden = false
      }
    
    @IBAction func searchClicked(_ sender:UIButton){
        ViewHelper.shared().showLoader(self)
        dependency.searchModal = searchModel
        
        dependency.searchHostApi(completion: {
            DispatchQueue.main.async {
                ViewHelper.shared().hideLoader()
                self.goback(sender)
            }
        })
           
       }
    
    @IBAction func showContinent(_ sender:UIButton){
        searchTextView.resignFirstResponder()
      showContinent()
    }
    
    @IBAction func showCountries(_ sender:UIButton){
        searchTextView.resignFirstResponder()
      showCountries()
    }
    
    @IBAction func anyTimeClicked(_ sender:UIButton){
        anytime.isSelected = true
        dateRange.isSelected = false
        self.fromLabel.text = "Start Date"
        self.toLabel.text = "End Date"
        self.searchModel.dt = nil
    }
    
    @IBAction func showCalender(_ sender:UIButton){
        anytime.isSelected = false
        dateRange.isSelected = true
        let vc = CalenderVC(nibName: "CalenderVC", bundle: nil)
        vc.datesSelected = { fromDate,toDate in
            self.fromLabel.text = fromDate
            self.toLabel.text = toDate
            self.searchModel.dt = fromDate + "|" + toDate
        }
        
        vc.modalPresentationStyle = .overCurrentContext
       
        self.present(vc, animated: false, completion: nil)
    }
    
}

extension HostSearchVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmObject.jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "JobsCell", for: indexPath) as! JobsCell
        cell.jobsItem.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        if searchModel.jobsArray.contains(vmObject.jobs![indexPath.row].title ?? ""){
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
        let countriesData = action.getData() as? [continents:[countries]]
        let keys = Array<continents>(countriesData!.keys)
        searchModel.continent = keys.first?.title ?? ""
        searchModel.countries = (countriesData?[keys.first!]?.map({ $0.title }))! as! [String]
        searchModel.conti = keys.first?.continentId
        searchModel.cntry = ((countriesData?[keys.first!]?.map({ $0.countryCode }))! as! [String]).joined(separator: "|")
        countries.isHidden = true
      }
      
    
}
