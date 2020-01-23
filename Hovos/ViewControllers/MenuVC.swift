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
    case logout
    case other
    case login
    case hostlist
    case volunteers
}

protocol Menudelegates {
    func menuItemDidSelect(for action:Action)
}

class MenuVC: UIView,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var heightConstraints:NSLayoutConstraint!
    @IBOutlet weak var containerView:UIView!
    var options = ["Log in","Register free","Host list","Volunteer list","Help center"]
   
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
        heightConstraints.constant = CGFloat(options.count * 40)
        let nib = UINib(nibName: "MenuCell", bundle: nil)
        tbl.register(nib, forCellReuseIdentifier: "menuitem")
        if UserDefaults.standard.value(forKey: constants.accessToken.rawValue) != nil{
            options[0] = "Log out"
            options.remove(at: 1)
        }
        
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
       
    if UserDefaults.standard.value(forKey: constants.accessToken.rawValue) != nil{
         if indexPath.row == 0{
          self.delegate.menuItemDidSelect(for: Action.logout)
    }else{
            self.delegate.menuItemDidSelect(for: Action.other)
        }
    }else if indexPath.row == 0{
        
        self.delegate.menuItemDidSelect(for: Action.login)
        }
    else if indexPath.row == 1{
        self.delegate.menuItemDidSelect(for: Action.register)
    }else if indexPath.row == 2{
          self.delegate.menuItemDidSelect(for: Action.hostlist)
        }else if indexPath.row == 3{
          self.delegate.menuItemDidSelect(for: Action.volunteers)
        }else {
          self.delegate.menuItemDidSelect(for: Action.other)
        }
    }
}

class menuCell:UITableViewCell{
    @IBOutlet weak var itemName:UILabel!
}
