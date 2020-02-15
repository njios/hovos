//
//  ContinentView.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/26/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit


class ContinentView: UIView,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var ttlLabel:UILabel!
    var delegate:Menudelegates!
    var step = 0
    var VMObject = FaceVM()
    var selectedCountries = [countries]()
    var continent = ""
    var host = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        let vc = Bundle.main.loadNibNamed("ContinentView", owner: self, options: nil)?[0] as? UIView
        vc?.frame = self.frame
        self.addSubview(vc!)
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "ContinentView")
        let nib = UINib.init(nibName: "ContinentCell", bundle: nil)
        tbl.register(nib, forCellReuseIdentifier: "ContinentCell")
        VMObject.getFacet {
            if self.VMObject.facetData != nil{
                DispatchQueue.main.async {
                    self.tbl.dataSource = self
                    self.tbl.delegate = self
                    self.tbl.reloadData()
                }
                
            }
        }
    }
    
   
    
    @IBAction func dismiss(_ sender:UIButton){
        step = 0
         heightConstraint.constant = 0
        tbl.reloadData()
        self.isHidden = true
    }
    
    @IBAction func selectAction(_ sender:UIButton){
           step = 0
            heightConstraint.constant = 0
           tbl.reloadData()
           self.isHidden = true
           self.delegate.menuItemDidSelect(for: Action.other)
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if step != 1{
            ttlLabel.text = "Continents"
        return self.VMObject.facetData?.continents.count ?? 0
        }else{
            ttlLabel.text = "Counties in \(continent)"
            return selectedCountries.count
        }
      }
      
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
    if step == 0{
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContinentView")
    let title = self.VMObject.facetData?.continents[indexPath.row].title ?? ""
    cell?.textLabel?.text =  title
    cell?.selectionStyle = .none
        cell?.textLabel?.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
    return cell!
    }else{
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContinentCell") as! ContinentCell
    let title = selectedCountries[indexPath.row].title ?? ""
    let count = selectedCountries[indexPath.row].counts ?? ""
         cell.ttlLable.text =  title + " (" + count + ")"
        cell.selectionStyle = .none
        cell.selectImage.isHidden = true
         cell.ttlLable.font = UIFont(name: "Lato-Regular", size: 18)
        return cell
    }
      }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if step == 0 {
            step = 1
            selectedCountries = VMObject.facetData?.countries.filter({ (country) -> Bool in
                if country.continentId == VMObject.facetData?.continents[indexPath.row].continentId{
                    continent = VMObject.facetData?.continents[indexPath.row].title ?? ""
                    return true
                }else{
                    return false
                }
            }) ?? []
            heightConstraint.constant = 30
            tableView.reloadData()
        }else{
            let cell = tableView.cellForRow(at: indexPath) as! ContinentCell
            cell.selectImage.isHidden = !cell.selectImage.isHidden
            if cell.selectImage.isHidden == false{
            cell.ttlLable.font = UIFont(name: "Lato-Bold", size: 18)
            }else{
                cell.ttlLable.font = UIFont(name: "Lato-Regular", size: 18)
            }
        }
        
        
    }

}

