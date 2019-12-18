//
//  MenuVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/18/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit

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
      

}

class menuCell:UITableViewCell{
    @IBOutlet weak var itemName:UILabel!
}
