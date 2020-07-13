//
//  SkillsVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/2/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class SkillsVC: UIViewController {

    @IBOutlet weak var collView:UICollectionView!
    var vmObject:VolunteerSearchVM!
    @IBOutlet weak var ttlLabel:UILabel!
        @IBOutlet weak var selectButton:UIButton!
        @IBOutlet weak var cancelButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.register(UINib(nibName: "JobsCell", bundle: nil), forCellWithReuseIdentifier: "JobsCell")
        ViewHelper.shared().showLoader(self)
        vmObject.getJobs {
            DispatchQueue.main.async {
                ViewHelper.shared().hideLoader()
                if self.vmObject.jobs != nil{
                    self.collView.delegate = self
                    self.collView.dataSource = self
                    self.collView.reloadData()
               
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    @objc func jobsSelected(_ sender:UIButton){
        
        if (vmObject.modal.skillsArray.contains(vmObject.jobs[sender.tag].title ?? "")){
            sender.isSelected = false
            sender.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
           
            for i in 0 ..< (vmObject.modal.skillsArray.count){
                if vmObject.modal.skillsArray[i] == (vmObject.jobs[sender.tag].title ?? ""){
                vmObject.modal.skillsArray.remove(at: i)
                    vmObject.modal.skills.remove(at: i)
                break
                }
            }
            
        }else{
            sender.isSelected = true
            sender.backgroundColor = UIColor(named: "orangeColor")
            vmObject.modal.skills.append(vmObject.jobs[sender.tag].value ?? "")
            vmObject.modal.skillsArray.append(vmObject.jobs[sender.tag].title ?? "")
        }
     
       
    }
    @IBAction func cancellaction(_ sender:UIButton){
        vmObject.modal.skills.removeAll()
        vmObject.modal.skillsArray.removeAll()
        self.dismiss(animated: false, completion: nil)
       }
       
       @IBAction func selectAction(_ sender:UIButton){
 self.dismiss(animated: false, completion: nil)
          }
       

}
extension SkillsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return vmObject.jobs.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "JobsCell", for: indexPath) as! JobsCell
           cell.jobsItem.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        if vmObject.modal.skillsArray.contains(vmObject.jobs![indexPath.row].title ?? ""){
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
}
