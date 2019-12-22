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
    

     @IBOutlet weak var emailId:UITextField!
     @IBOutlet weak var password:UITextField!
     
    
    var type:String? // used to identify Volunteer or host
    var vmObject:LoginVM?
    override func viewDidLoad() {
        vmObject = LoginVM()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    @IBAction func signUpClicked(_ sender:UIButton){
        ViewHelper.shared().showLoader(self)
        vmObject?.signUp(emailId: emailId.text!, password: password.text!, completion: updateUiAfterSignup(status:))
       }
    
     func updateUiAfterSignup(status:Bool){
        DispatchQueue.main.async {
            ViewHelper.shared().hideLoader()
            if status == true{
                       UserDefaults.standard.set(true, forKey: constants.accessToken.rawValue)
                       self.goToRootVC()
            }else{
                let alert = UIAlertController(title: "Error!", message: "Something wrong, please try", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "close", style: .cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
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

