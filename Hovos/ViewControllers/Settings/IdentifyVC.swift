//
//  IdentifyVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/18/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Alamofire

class IdentifyVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var phoneno:UITextField!
    @IBOutlet weak var countryCode:UIButton!
    @IBOutlet weak var activity:UIActivityIndicatorView!
    @IBOutlet weak var uploadButton:UIButton!
    @IBOutlet weak var suceeslabel:UILabel!
    @IBOutlet weak var optVerifyView:UIView!
    @IBOutlet var otp: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (SharedUser.manager.auth.user?.phoneNumber ?? "") != ""{
            phoneno.text = (SharedUser.manager.auth.user?.phoneNumber ?? "").components(separatedBy: "-")[1]
            
        }// Do any additional setup after loading the view.
    }
    
    
    @IBAction func identifyClicked(_ sender:UIButton){
        if  phoneno.text != "" {
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "id":SharedUser.manager.auth.user?.listingId ?? "",
                          "API_KEY":constants.Api_key.rawValue]
            var identifyYourself = NetworkPacket()
            identifyYourself.apiPath = ApiEndPoints.smsOtp.rawValue
            identifyYourself.header = header
            identifyYourself.data = ["countrycode":countryCode.titleLabel?.text ?? "",
                                     "phone":phoneno.text ?? ""]
            identifyYourself.method = "POST"
            ViewHelper.shared().showLoader(self)
            ApiCall(packet: identifyYourself) { (data, status, code) in
                ViewHelper.shared().hideLoader()
                if code == 200{
                    DispatchQueue.main.async{
                         self.optVerifyView.isHidden = false
                        self.otp[0].becomeFirstResponder()
                    }
                }else{
                    Hovos.showAlert(vc: self, mssg: "Phone number not valid.")
                }
            }
        }
    }
    
    private func goTochangePassword(){
          let header = ["auth":SharedUser.manager.auth.auth ?? "",
                                   "id":SharedUser.manager.auth.user?.listingId ?? "",
                                   "API_KEY":constants.Api_key.rawValue]
                     var identifyYourself = NetworkPacket()
                     identifyYourself.apiPath = ApiEndPoints.otpVerify(otp: "\(otp[0].text!)\(otp[1].text!)\(otp[2].text!)\(otp[3].text!)").rawValue
        
                     identifyYourself.header = header
                     
                     identifyYourself.method = "POST"
                     ViewHelper.shared().showLoader(self)
                     ApiCall(packet: identifyYourself) { (data, status, code) in
                         ViewHelper.shared().hideLoader()
                         if code == 200{
                             DispatchQueue.main.async{
                                Hovos.showAlert(vc: self, mssg: "OTP successfully submited.")
                                for item in self.otp{
                                    item.text = ""
                                }
                                self.optVerifyView.isHidden = true
                             }
                         }else{
                             Hovos.showAlert(vc: self, mssg: "OTP is not valid.")
                         }
                }
       }
    
    @IBAction func uploadDoc(_ sender:UIButton){
        handleProfilePicker()
    }
    func handleProfilePicker() {
         let pickerView = UIImagePickerController()
              pickerView.delegate = self
              pickerView.allowsEditing = true
              
              
              let alert = UIAlertController(title: "Alert", message: "Add photos about yourself", preferredStyle: .alert)
              let action1 = UIAlertAction(title: "Take a photo now", style: .default) { (action) in
                  pickerView.sourceType = .camera
                  alert.dismiss(animated: false) {
                      DispatchQueue.main.async {
                          self.present(pickerView, animated: false, completion: nil)
                      }
                      
                  }
              }
              let action2 =  UIAlertAction(title: "Select From your gallery", style: .default) { (action) in
                  pickerView.sourceType = .photoLibrary
                  alert.dismiss(animated: false) {
                     DispatchQueue.main.async {
                          self.present(pickerView, animated: false, completion: nil)
                      }
                  }
                     }
              let action3 = UIAlertAction(title: "CANCEL", style: .cancel) { (action) in
                  alert.dismiss(animated: false) {
                  }
                  
              }
              alert.addAction(action1)
              alert.addAction(action2)
              alert.addAction(action3)
              self.present(alert, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage]   as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        if let selectedImages = selectedImage {
           uploadImage(tmpImage: selectedImages, completion: nil)
            self.activity.isHidden = false
             dismiss(animated: false, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
    
    func uploadImage(tmpImage:UIImage?,completion:(()->())?){
        // the image in UIImage type
        guard let image = tmpImage else { return  }

        let filename = "document.png"

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

       

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: "https://www.hovos.com/api/user/documents")!)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["auth":SharedUser.manager.auth.auth ?? "",
        "id":SharedUser.manager.auth.user?.listingId ?? "",
        "API_KEY":constants.Api_key.rawValue]
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
                DispatchQueue.main.async {
                     self.activity.isHidden = true
                    Hovos.showAlert(vc: self, mssg: error!.localizedDescription)
                }
                
            }
            
            guard let responseData = responseData else {
                print("no response data")
                Hovos.showAlert(vc: self, mssg: "no response data")
                return
            }
        
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
                DispatchQueue.main.async {
                self.activity.isHidden = true
                    self.suceeslabel.isHidden = false
                    self.uploadButton.isHidden = true
                }
            }
        }).resume()
    }
}

func showAlert(vc:UIViewController,mssg:String){
    let alert = UIAlertController(title: "", message: mssg, preferredStyle: .alert)
    let okButton = UIAlertAction(title: "close", style: .cancel, handler: nil)
    alert.addAction(okButton)
    vc.present(alert, animated: true) {
        
    }
}

extension IdentifyVC:UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       var blank = false
        for item in otp{
            if item.text?.count == 0{
                item.becomeFirstResponder()
                blank = true
                break
            }
        }
        if blank == false{
            textField.resignFirstResponder()
           goTochangePassword()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 0{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
               self.textFieldDidBeginEditing(textField)
            })
            return true
        }else{
            self.textFieldDidBeginEditing(textField)
            return true
        }
    }
    
    
}
