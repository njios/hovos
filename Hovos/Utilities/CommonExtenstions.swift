//
//  CommonExtenstions.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/17/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func goToRootVC(){
        if let nvc = self.navigationController{
            nvc.popToRootViewController(animated: true)
        }
    }
}
