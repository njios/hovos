//
//  EditProfile_ContriesVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/25/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_ContinentsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
  @IBOutlet weak var tblView:UITableView!

    var continentVC = ContinentView()

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewHelper.shared().showLoader(self)
        continentVC.getFacet {
            DispatchQueue.main.async {
                ViewHelper.shared().hideLoader()
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileContinentCell") as! EditProfileContinentCell
        cell.listOfCountries = continentVC.VMObject.facetData?.returnCountries(index:indexPath.row)
        cell.continetName.text = continentVC.VMObject.facetData?.continents[indexPath.row].title ?? ""
         let listOfcountries = cell.isCountryExist()
        if listOfcountries.count > 0 {
            cell.selectimage.image = UIImage(named: "selectedBlueTick")
               cell.continetName.textColor = UIColor(named: "greenColor")
            cell.countries.text = listOfcountries.joined(separator: ", ")
           }else{
            cell.selectimage.image = UIImage(named: "greyCheck")
               cell.continetName.textColor = .lightGray
             cell.countries.text = ""
           }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return continentVC.VMObject.facetData?.continents.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EditProfileContinentCell
        ViewHelper.shared().showLoader(self)
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile_ContriesVC") as! EditProfile_ContriesVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.continentId = continentVC.VMObject.facetData?.continents[indexPath.row].continentId ?? ""
        vc.selectedContinent = continentVC.VMObject.facetData?.continents[indexPath.row].title ?? ""
        vc.facetdata = cell
        vc.countriesSelected = selectedCountries
        
        self.present(vc, animated: true){
            ViewHelper.shared().hideLoader()
        }
    }
    
    func selectedCountries(){
        tblView.reloadData()
    }
    
}

class EditProfileContinentCell:UITableViewCell{
    @IBOutlet weak var selectimage:UIImageView!
    @IBOutlet weak var continetName:UILabel!
    @IBOutlet weak var countries:UILabel!
    var listOfCountries:[countries]!
    
    func isCountryExist()->[String]{
        var countryList = [String]()
        for item in SharedUser.manager.auth.listing?.countries ?? [:]{
            if listOfCountries.contains(where: { (country) -> Bool in
                if (country.title ?? "") == item.value{
                    return true
                }else{
                    return false
                }
            }){
                countryList.append(item.value ?? "")
            }
        }
        return countryList
    }
}


