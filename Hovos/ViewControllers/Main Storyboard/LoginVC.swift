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
        vmObject?.signUp(emailId: emailId.text!, password: password.text!, completion: updateUiAfterSignup(status:data:))
    }
    
    func updateUiAfterSignup(status:Bool,data:Data?){
        DispatchQueue.main.async {
            ViewHelper.shared().hideLoader()
            if status == true{
                let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "dashboradnav")
                let appdel = UIApplication.shared.delegate as? AppDelegate
                appdel?.window?.rootViewController = vc
            }else{
                let alert = UIAlertController(title: "Error!", message: data?.html2String, preferredStyle: .alert)
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
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if error == nil{
                self.loginManagerDidComplete(result!)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil{
            ViewHelper.shared().showLoader(self)
            vmObject?.signUp(emailId: user?.profile?.email ?? "", password: "$APPLEPREAUTH", completion: updateUiAfterSignup(status:data:))
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    private func loginManagerDidComplete(_ result: LoginManagerLoginResult) {
        ViewHelper.shared().showLoader(self)
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: result.token?.tokenString , version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
        
        req.start { (connection, result, error) in
            if(error == nil) {
                self.vmObject?.signUp(emailId: (result as? [String:String])?["email"] ?? "", password: "$APPLEPREAUTH", completion: self.updateUiAfterSignup(status:data:))
            } else {
                ViewHelper.shared().hideLoader()
            }
        }
    }
    
}

