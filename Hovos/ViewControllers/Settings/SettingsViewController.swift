//
//  SettingsViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/18/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Kingfisher

class SettingsViewController: UIViewController {

    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var profileIMG:UIImageView!
      @IBOutlet weak var menuView:MenuVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.frame = self.view.frame
               menuView.delegate = self
        name.text = (SharedUser.manager.auth.user?.firstName ?? "" ) + " " + (SharedUser.manager.auth.user?.lastName ?? "")
        if let imageUrl = SharedUser.manager.auth.user?.image?.medium{
            profileIMG.kf.indicatorType = .activity
            profileIMG.kf.setImage(with: URL(string: imageUrl)!)
        }
    
    }
    @IBAction func loadMenu(_ sender:UIButton){
              
              self.view.addSubview(menuView)
              
              
          }
    @IBAction func logout(_ sender:UIButton){
        UserDefaults.standard.removeObject(forKey: constants.accessToken.rawValue)
                       let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let vc = storyboard.instantiateViewController(withIdentifier: "mainnav")
                       let appdel = UIApplication.shared.delegate as? AppDelegate
                       appdel?.window?.rootViewController = vc
    }

}
extension SettingsViewController:Menudelegates{
    func menuItemDidSelect(for action: Action) {
        self.navigationController?.popToRootViewController(animated: false)
        switch action {
        case .logout:
            UserDefaults.standard.removeObject(forKey: constants.accessToken.rawValue)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mainnav")
            let appdel = UIApplication.shared.delegate as? AppDelegate
            appdel?.window?.rootViewController = vc
            break
        case .hostlist:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "HostsVC") as! HostsVC
            vc.modalPresentationStyle = .overCurrentContext
            //vc.VMObject = landingVMObject
            self.present(vc, animated: true, completion: nil)
            break
        default:
            break
        }
        
    }
}
