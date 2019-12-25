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
  
    @IBOutlet weak var containerView:UIView!
    var options = ["Africa (103)","Caribbean (31)","Central America (70)","Europe (858)","Asia (221)","Middle East (39)","North America (217)","Oceania (397)","South America (318)"]
   
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
        let vc = Bundle.main.loadNibNamed("ContinentView", owner: self, options: nil)?[0] as? UIView
        self.addSubview(vc!)
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "ContinentView")
        tbl.dataSource = self
        tbl.delegate = self
        tbl.reloadData()
    }
    
   
    
    @IBAction func dismiss(_ sender:UIButton){
        self.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options.count
      }
      
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContinentView")
    cell?.textLabel?.text = options[indexPath.row]
    return cell!
      }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            self.delegate.menuItemDidSelect(for: Action.other)
        
    }

}

