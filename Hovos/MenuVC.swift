//
//  MenuVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/18/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class MenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   

    @IBOutlet weak var tbl:UITableView!
     @IBOutlet weak var heightConstraints:NSLayoutConstraint!
     @IBOutlet weak var containerView:UIView!
    var options = ["Register","Volunteer list","Host list"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.dataSource = self
        tbl.delegate = self
        tbl.reloadData()
        heightConstraints.constant = 3 * 40
        let nib = UINib(nibName: "MenuCell", bundle: nil)
        tbl.register(nib, forCellReuseIdentifier: "MenuCell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender:UIButton){
    self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        heightConstraints.constant = tbl.contentSize.height
        containerView.isHidden = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options.count
      }
      
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuitem") as! menuCell
        cell.itemName.text = options[indexPath.row]
        return cell
      }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.dismiss(animated: false) {
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let vc = storyBoard.instantiateViewController(identifier: "SignUpVc") as! SignUpVc
                              self.navigationController?.pushViewController(vc, animated: true)
                }
            }
      
                
        }
    }

}

class menuCell:UITableViewCell{
    @IBOutlet weak var itemName:UILabel!
}
