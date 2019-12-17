
//
//  ViewHelper.swift
//  Papi
//
//  Created by Neeraj Joshi on 02/02/18.
//  Copyright © 2018 Neeraj Joshi. All rights reserved.
//

import UIKit
class ViewHelper:UIViewController{
    override func viewDidLoad() {
    }
    var profilePic = UIImage()
    private var context:UIViewController?
    private static  var object = ViewHelper()
    var viewBG = UIView()
    func showLoader(_ context:UIViewController){
        ViewHelper.object.context = context
         viewBG = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        viewBG.backgroundColor = UIColor.black
        viewBG.alpha = 0.32
        let loader = UIActivityIndicatorView(frame: CGRect(x: Int((viewBG.frame.size.width / 2 ) - 50), y: Int((viewBG.frame.size.height / 2 ) - 50), width: 100, height: 100))
        loader.color = .blue
        loader.startAnimating()
        viewBG.addSubview(loader)
        ViewHelper.object.context?.view.addSubview(viewBG)
    }
    func hideLoader(){
        DispatchQueue.main.async {
            self.viewBG.removeFromSuperview()
        }
     
    }
    static func shared()->ViewHelper{
        return object
    }
    
    
    
    
}



