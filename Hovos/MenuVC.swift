//
//  MenuVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/18/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit

enum Action{
    case register
}

protocol Menudelegates {
    func menuItemDidSelect(for action:Action)
}

class MenuVC: UIView,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var heightConstraints:NSLayoutConstraint!
    @IBOutlet weak var containerView:UIView!
    var options = ["Log in","Volunteer list","Host list"]
    var delegate:Menudelegates!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        let vc = Bundle.main.loadNibNamed("MenuVC", owner: self, options: nil)?[0] as? UIView
        self.addSubview(vc!)
        heightConstraints.constant = 3 * 40
        let nib = UINib(nibName: "MenuCell", bundle: nil)
        tbl.register(nib, forCellReuseIdentifier: "menuitem")
        tbl.dataSource = self
        tbl.delegate = self
        tbl.reloadData()
    }
    
   
    
    @IBAction func dismiss(_ sender:UIButton){
        self.removeFromSuperview()
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

            self.delegate.menuItemDidSelect(for: Action.register)
        }
    }

}

class menuCell:UITableViewCell{
    @IBOutlet weak var itemName:UILabel!
}