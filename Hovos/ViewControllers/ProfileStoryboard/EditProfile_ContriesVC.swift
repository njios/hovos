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
   
    var facetdata:EditProfileContinentCell!
    var countriesSelected:(()->())!
    var continentId = ""
    var selectedContinent = ""
    var copyOfCountries = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedContinentName.text = "Countries in \(selectedContinent)"
        copyOfCountries = (SharedUser.manager.auth.listing?.countries ?? ["":""]) as! [String : String]
        tbleView.reloadData()
    }

    func isCountryExist()->[String]{
        var countryList = [String]()
        for item in copyOfCountries {
            if facetdata.listOfCountries.contains(where: { (country) -> Bool in
                if (country.title ?? "") == item.value{
                    return true
                }else{
                    return false
                }
            }){
                countryList.append(item.value )
            }
        }
        return countryList
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facetdata.listOfCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContinentCell") as! ContinentCell
       
        cell.ttlLable.text = facetdata.listOfCountries[indexPath.row].title
        if isCountryExist().contains(facetdata.listOfCountries[indexPath.row].title ?? ""){
            cell.selectImage.image = UIImage(named: "selectedBlueTick")
            cell.ttlLable.textColor = UIColor(named: "greenColor")
            cell.cellSelected = true
        }else{
             cell.selectImage.image = UIImage(named: "greyCheck")
            cell.ttlLable.textColor = .lightGray
            cell.cellSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ContinentCell
        if cell.cellSelected == true{
            copyOfCountries.removeValue(forKey: facetdata.listOfCountries[indexPath.row].countryCode ?? "")
        }else{
            copyOfCountries[facetdata.listOfCountries[indexPath.row].countryCode ?? ""] = facetdata.listOfCountries[indexPath.row].title ?? ""
        }
        tableView.reloadData()
        
    }
    
    
    
    @IBAction func selectedClicked(_ sender:UIButton){
        copyOfCountries = copyOfCountries.filter({ (arg) -> Bool in
            let (k,_) = arg
            if facetdata.listOfCountries.contains(where: {$0.countryCode == k}){
                return false
            }else{
                return true
            }
        })

        if sender.isSelected {
            sender.isSelected = false
            
        }else{
            sender.isSelected = true
            for item in facetdata.listOfCountries{
                copyOfCountries[item.countryCode ?? ""] = item.title ?? ""
            }
        }
        tbleView.reloadData()
    }
    
    @IBAction func doneClicked(_ sender:UIButton){
        SharedUser.manager.auth.listing?.countries = copyOfCountries
        goback(sender)
        countriesSelected()
    }
    
    @IBAction func cancleClicked(_ sender:UIButton){
       goback(sender)
    }
}


