//
//  EditProfile_ContriesVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/25/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_ContriesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tbleView:UITableView!
    @IBOutlet weak var selectedContinentName:UILabel!
    @IBOutlet weak var selectAllButton:UIButton!
   
    var facetdata:facets!
    var country:[countries]!{
        didSet{
            if country.count > 0{
            tbleView.reloadData()
            }
        }
    }
    var countriesSelected:(()->())!
    var continentId = ""
    var selectedContinent = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedContinentName.text = "Countries in \(selectedContinent)"
        country = facetdata.countries.filter{$0.continentId == continentId}
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContinentCell") as! ContinentCell
       
        cell.ttlLable.text = country[indexPath.row].title
        if EditProfile.sharedManger().profilePassById.selectedContinets[continentId]?.contains(country[indexPath.row].countryId ?? "") ?? false{
            cell.selectImage.image = UIImage(named: "selectedBlueTick")
            cell.ttlLable.textColor = UIColor(named: "greenColor")
        }else{
             cell.selectImage.image = UIImage(named: "greyCheck")
            cell.ttlLable.textColor = .lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var found = false
        EditProfile.sharedManger().profilePassById.selectedContinets[continentId] = EditProfile.sharedManger().profilePassById.selectedContinets[continentId]?.filter({ (index) -> Bool in
            if index == country[indexPath.row].countryId{
                found = true
                selectAllButton.isSelected = false
                return false
            }else{
                return true
            }
        })
        
        EditProfile.sharedManger().profileForDisplay.selectedContinents[selectedContinent] =
            EditProfile.sharedManger().profileForDisplay.selectedContinents[selectedContinent]?.filter({ (index) -> Bool in
            if index == country[indexPath.row].title{
                found = true
                selectAllButton.isSelected = false
                return false
            }else{
                return true
            }
        })
        
        if found == false{
            if (EditProfile.sharedManger().profilePassById.selectedContinets[continentId]?.count ?? 0) > 0{  EditProfile.sharedManger().profilePassById.selectedContinets[continentId]?.append(country[indexPath.row].countryId ?? "")
        EditProfile.sharedManger().profileForDisplay.selectedContinents[selectedContinent]?.append(country[indexPath.row].title ?? "")
            }else{
                EditProfile.sharedManger().profilePassById.selectedContinets[continentId] = [country[indexPath.row].countryId ?? ""]
                EditProfile.sharedManger().profileForDisplay.selectedContinents[selectedContinent] = [country[indexPath.row].title ?? ""]
            }
        }
        tableView.reloadData()
        
    }
    
    
    
    @IBAction func selectedClicked(_ sender:UIButton){
        
        if sender.isSelected {
            sender.isSelected = false
            EditProfile.sharedManger().profilePassById.selectedContinets.removeValue(forKey: continentId)
            EditProfile.sharedManger().profileForDisplay.selectedContinents.removeValue(forKey: selectedContinent)
        }else{
            sender.isSelected = true
            EditProfile.sharedManger().profilePassById.selectedContinets.removeValue(forKey: continentId)
            EditProfile.sharedManger().profileForDisplay.selectedContinents.removeValue(forKey: selectedContinent)
            var countryTitleList = [String]()
            var countryIdList = [String]()
            for i in 0..<country.count{
                countryTitleList.append(country[i].title ?? "")
                countryIdList.append(country[i].countryId ?? "")
                
            }
            EditProfile.sharedManger().profilePassById.selectedContinets[continentId] = countryIdList
            EditProfile.sharedManger().profileForDisplay.selectedContinents[selectedContinent] = countryTitleList
        }
        tbleView.reloadData()
    }
    
    @IBAction func doneClicked(_ sender:UIButton){
        goback(sender)
        countriesSelected()
    }
    
    @IBAction func cancleClicked(_ sender:UIButton){
       goback(sender)
    }
}


