//
//  Themehelper.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 5/1/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit

class ThemeView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        if SharedUser.manager.auth.user?.role == "V"{
            self.backgroundColor = UIColor(named: "greenColor")
        }else{
             self.backgroundColor = UIColor(named: "orangeColor")
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if SharedUser.manager.auth.user?.role == "V"{
            self.backgroundColor = UIColor(named: "greenColor")
        }else{
             self.backgroundColor = UIColor(named: "orangeColor")
        }
    }
    
}

class ThemeLabel:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        if SharedUser.manager.auth.user?.role == "V"{
            self.backgroundColor = UIColor(named: "greenColor")
        }else{
             self.backgroundColor = UIColor(named: "orangeColor")
        }
    }
    
    required init?(coder: NSCoder) {
          super.init(coder: coder)
        if SharedUser.manager.auth.user?.role == "V"{
            self.backgroundColor = UIColor(named: "greenColor")
        }else{
             self.backgroundColor = UIColor(named: "orangeColor")
        }
      }
}
