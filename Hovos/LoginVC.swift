//
//  ViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 12/1/19.
//  Copyright © 2019 neeraj kumar joshi. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
class LoginVC: UIViewController,GIDSignInDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
       
    }

    @IBAction func googleSignInClicked(_ sender:UIButton){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction private func loginWithReadPermissions() {
           let loginManager = LoginManager()
        loginManager.logIn(permissions: [], from: self) { (result, error) in
            if error == nil{
                self.loginManagerDidComplete(result!)
            }
        }
        
       }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil{
            UserDefaults.standard.set(true, forKey: constants.accessToken.rawValue)
            self.goToRootVC()
        }
     }
     
     func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    
     }
    
    private func loginManagerDidComplete(_ result: LoginManagerLoginResult) {
          print(result)
        UserDefaults.standard.set(true, forKey: constants.accessToken.rawValue)
          self.goToRootVC()
       }

}

