//
//  VolunteerSearchVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/24/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//


import UIKit

class VolunteerSearchVC: UIViewController,UITextFieldDelegate,SearchDelegate,Menudelegates {
    
    
    @IBOutlet weak var clearButton:UIButton!
    @IBOutlet weak var fromLabel:UILabel!
    @IBOutlet weak var toLabel:UILabel!
    @IBOutlet weak var anytime:UIButton!
    @IBOutlet weak var dateRange:UIButton!
    @IBOutlet weak var skillsButton:UIButton!
    @IBOutlet weak var countriesButton:UIButton!
    @IBOutlet weak var languageButton:UIButton!
    @IBOutlet weak var skillsLabel:CustomLabels!
    @IBOutlet weak var countrieslabel:CustomLabels!
    @IBOutlet weak var languageLabel:CustomLabels!
    @IBOutlet weak var searchTextView:CustomEditViews!
    @IBOutlet weak var countries:ContinentView!
    @IBOutlet weak var age1:UIButton!
    @IBOutlet weak var age2:UIButton!
    @IBOutlet weak var age3:UIButton!
    @IBOutlet weak var age4:UIButton!
    @IBOutlet weak var gender1:UIButton!
    @IBOutlet weak var gender2:UIButton!
    @IBOutlet weak var gender3:UIButton!
    var vmObject:VolunteerSearchVM!
    var startSearch:((_ modal:Volunteer,_ searchModal:VolunteerSearchModel)->())!
    var copySearchModel:VolunteerSearchModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        countries.delegate = self
        countries.host = false
        searchTextView.delegate = self
        vmObject = VolunteerSearchVM(dependency: self)
    }
    
    
    @IBAction func clearClicked(_ sender:UIButton){
        vmObject.modal = VolunteerSearchModel()
        //          searchTextView.serachText.text = ""
        //          continentView.serachText.text = ""
        //          countriesView.serachText.text = ""
        //          anytime.isSelected = true
        //          dateRange.isSelected = false
        //          self.fromLabel.text = "Start Date"
        //          self.toLabel.text = "End Date"
        //          collView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if copySearchModel != nil{
            vmObject.modal = copySearchModel
        }
        
        
    }
    
    
    func SearchText(with text: String) {
        vmObject.modal.qs = text
    }
    
    @IBAction func showContinent(_ sender:UIButton) {
        showCountries()
    }
    
    @IBAction func selectGender(_ sender:UIButton) {
        switch sender.tag {
        case 0:
            gender1.isSelected = true
            gender2.isSelected = false
            vmObject.modal.gender = "M"
        case 1:
            gender1.isSelected = false
            gender2.isSelected = true
            vmObject.modal.gender = "F"
        case 2:
            
            gender3.isSelected = !gender3.isSelected
            if gender3.isSelected{
            vmObject.modal.isCompanion = "Y"
            }else{
            vmObject.modal.isCompanion = ""
            }
            
        default:
            break
        }
        
    }
    
    @IBAction func showSkills(_ sender:UIButton) {
        let skillVc = SkillsVC(nibName: "SkillsVC", bundle: nil)
        skillVc.vmObject = vmObject
        skillVc.type = "V"
        skillVc.modalPresentationStyle = .overCurrentContext
        self.present(skillVc, animated: false, completion: nil)
    }
    @IBAction func showLanguages(_ sender:UIButton) {
        let skillVc = languageVC(nibName: "languageVC", bundle: nil)
        skillVc.vmObject = vmObject
        skillVc.modalPresentationStyle = .overCurrentContext
        self.present(skillVc, animated: false, completion: nil)
    }
    func showCountries() {
        countries.isHidden = false
    }
    
    func changeApperance(button:UIButton, text:String, textLabel:CustomLabels){
        button.backgroundColor = .clear
        button.setTitleColor(.clear, for: .normal)
        textLabel.text = text
        textLabel.isComplete = true
        
    }
    
    func resetApperance(button:UIButton,textLabel:CustomLabels){
        button.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        button.setTitleColor(.darkGray, for: .normal)
        textLabel.text = ""
    }
    
    @IBAction func searchClicked(_ sender:UIButton){
        
            ViewHelper.shared().showLoader(self)
            vmObject.getDataWithModal { (modal) in
                DispatchQueue.main.async {
                    ViewHelper.shared().hideLoader()
                    if modal != nil {
                        self.startSearch(modal!,self.vmObject.modal)
                        self.goback(sender)
                    }
                }
            }
        
    }
    
    @IBAction func anyTimeClicked(_ sender:UIButton){
        anytime.isSelected = true
        dateRange.isSelected = false
        self.fromLabel.text = "Start Date"
        self.toLabel.text = "End Date"
        vmObject.modal.dt = nil
    }
    
    @IBAction func ageGroupSelected(_ sender:UIButton){
        let temp = Array(vmObject.modal.age.split(separator: "|"))
        var ages = temp.map({String($0)})
        switch sender.tag {
        case 0:
            age1.isSelected = !age1.isSelected
            if age1.isSelected{
                ages.append((sender.titleLabel?.text!)!)
                
            }else{
                ages = ages.filter({String($0) != (sender.titleLabel?.text!)!})
            }
            
        case 1:
            age2.isSelected = !age2.isSelected
            if age2.isSelected{
                ages.append((sender.titleLabel?.text!)!)
                
            }else{
                ages = ages.filter({String($0) != (sender.titleLabel?.text!)!})
            }
        case 2:
            age3.isSelected = !age3.isSelected
            if age3.isSelected{
                ages.append((sender.titleLabel?.text!)!)
                
            }else{
                ages = ages.filter({String($0) != (sender.titleLabel?.text!)!})
            }
        case 3:
            age4.isSelected = !age4.isSelected
            if age4.isSelected{
                ages.append((sender.titleLabel?.text!)!)
                
            }else{
                ages = ages.filter({String($0) != (sender.titleLabel?.text!)!})
            }
        default:
            break
        }
        
        if sender.isSelected{
            sender.backgroundColor = UIColor(named: "greenColor")
            sender.setTitleColor(.white, for: .normal)
        }else{
            sender.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            sender.setTitleColor(.darkGray, for: .normal)
        }
        vmObject.modal.age = ages.joined(separator: "|")
    }
    
    @IBAction func showCalender(_ sender:UIButton){
        anytime.isSelected = false
        dateRange.isSelected = true
        let vc = CalenderVC(nibName: "CalenderVC", bundle: nil)
        vc.datesSelected = { fromDate,toDate in
            self.fromLabel.text = fromDate
            self.toLabel.text = toDate
            self.vmObject.modal.dt = fromDate + "|" + toDate
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    func menuItemDidSelect(for action: MenuAction) {
        let countriesData = action.getData() as? [continents:[countries]]
        let keys = Array<continents>(countriesData!.keys)
        vmObject.modal.continent = keys.first?.title ?? ""
        vmObject.modal.countries = (countriesData?[keys.first!]?.map({ $0.title }))! as! [String]
        vmObject.modal.cntry = ((countriesData?[keys.first!]?.map({ $0.countryCode }))! as! [String]).joined(separator: "|")
        vmObject.modal.conti = keys.first?.continentId
        
        countries.isHidden = true
    }
    
}

