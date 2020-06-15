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
     var vmObject:VolunteerSearchVM!
     var startSearch:((_ modal:[VolunteerItem])->())!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        countries.delegate = self
        countries.host = false
        searchTextView.delegate = self
        vmObject = VolunteerSearchVM(dependency: self)
     }

    func SearchText(with text: String) {
        vmObject.modal.qs = text
    }
    
    @IBAction func showContinent(_ sender:UIButton) {
       showCountries()
      }
    
    @IBAction func showSkills(_ sender:UIButton) {
    let skillVc = SkillsVC(nibName: "SkillsVC", bundle: nil)
        skillVc.vmObject = vmObject
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
        if clearButton.isHidden == false{
        ViewHelper.shared().showLoader(self)
        vmObject.getDataWithModal { (modal) in
            DispatchQueue.main.async {
                ViewHelper.shared().hideLoader()
                if modal != nil {
                self.startSearch(modal!)
                         self.goback(sender)
                }
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
    func menuItemDidSelect(for action: Action) {
      let countriesData = action.getData() as? [continents:[countries]]
      let keys = Array<continents>(countriesData!.keys)
        vmObject.modal.continent = keys.first?.title ?? ""
        vmObject.modal.countries = (countriesData?[keys.first!]?.map({ $0.title }))! as! [String]
        vmObject.modal.cntry = ((countriesData?[keys.first!]?.map({ $0.countryId }))! as! [String]).joined(separator: ",")
         vmObject.modal.conti = keys.first?.continentId
     
         countries.isHidden = true
    }
    
}

