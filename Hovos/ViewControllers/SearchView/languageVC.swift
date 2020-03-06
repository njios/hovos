//
//  languageVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/6/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class languageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
      @IBOutlet weak var tbl:UITableView!
       var vmObject:VolunteerSearchVM!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.register(UINib(nibName: "ContinentCell", bundle: nil), forCellReuseIdentifier: "ContinentCell")
        ViewHelper.shared().showLoader(self)
        vmObject.getLanguages {
            DispatchQueue.main.async {
                ViewHelper.shared().hideLoader()
                if self.vmObject.languages != nil{
                    self.tbl.delegate = self
                    self.tbl.dataSource = self
                    self.tbl.reloadData()
               
                }
            }
        }
        // Do any additional setup after loading the view.
    }
        
@IBAction func cancellaction(_ sender:UIButton){
             
               vmObject.modal.languagesArray.removeAll()
               self.dismiss(animated: false, completion: nil)
              }
              
    @IBAction func selectAction(_ sender:UIButton){
        self.dismiss(animated: false, completion: nil)
                 }
              

 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return vmObject.languages.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     
      let cell = tableView.dequeueReusableCell(withIdentifier: "ContinentCell") as! ContinentCell
      let title = vmObject.languages[indexPath.row].title ?? ""
          cell.selectImage.image = UIImage(named: "selectedBlueTick")
        if vmObject.modal.languagesArray.contains(title){
            cell.selectImage.isHidden = false
            cell.ttlLable.font = UIFont(name: "Lato-Bold", size: 18)
        }else{
            cell.selectImage.isHidden = true
              cell.ttlLable.font = UIFont(name: "Lato-Regular", size: 18)
        }
        
       
        cell.ttlLable.text = title
          cell.selectionStyle = .none
        
          return cell
      
        }
        
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                 let cell = tableView.cellForRow(at: indexPath) as! ContinentCell

        cell.selectImage.image = UIImage(named: "selectedBlueTick")
        
        cell.selectImage.isHidden = !cell.selectImage.isHidden
        if cell.selectImage.isHidden == false{

               
                vmObject.modal.languagesArray.append(vmObject.languages[indexPath.row].title ?? "")
          
        cell.ttlLable.font = UIFont(name: "Lato-Bold", size: 18)
        }else{
          for i in 0 ..< (vmObject.modal.languagesArray.count){
                             if vmObject.modal.languagesArray[i] == (vmObject.languages[indexPath.row].title ?? ""){
                                vmObject.modal.languagesArray.remove(at: i)
                                    
                                break
                                }
                            }
                            
            cell.ttlLable.font = UIFont(name: "Lato-Regular", size: 18)
        }

        }


}
