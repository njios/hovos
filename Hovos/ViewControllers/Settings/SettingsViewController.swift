//
//  SettingsViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/18/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
class SettingsViewController: UIViewController{
    
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var profileIMG:UIImageView!
    @IBOutlet weak var menuView:MenuVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.frame = self.view.frame
        
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
    func menuItemDidSelect(for action: MenuAction) {
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
                  
                   vc.VMObject = (self.parent as! TabBarController).VMObject
                   vc.isAllHost = true
                   self.navigationController?.pushViewController(vc, animated: true)
                   break
        case .volunteers:
                   let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                   let vc = storyBoard.instantiateViewController(withIdentifier: "VolunteerVC") as! VolunteerVC
                      self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
}

extension SettingsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
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
        if selectedImage != nil {
            ViewHelper.shared().showLoader(self)
            uploadImage(tmpImage: selectedImage!) { status,mssg  in
                DispatchQueue.main.async {
                    ViewHelper.shared().hideLoader()
                    if status == true{
                        
                        let url = URL(string: mssg)
                        self.profileIMG.kf.indicatorType = .activity
                        self.profileIMG.kf.setImage(with: url)
                        
                    }else{
                        Hovos.showAlert(vc: self, mssg: mssg)
                    }
                }
            }
            
            dismiss(animated: false, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
    
    func uploadImage(tmpImage:UIImage,completion: @escaping ((Bool,String)->())){
        
        let parameters = [
            "filename": "custom"
        ]
        
        var url = ""
        url = "https://www.hovos.com/api/user/image"
        
        
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "auth":SharedUser.manager.auth.auth ?? "",
            "API_KEY":constants.Api_key.rawValue,
            "id":SharedUser.manager.auth.user?.listingId ?? "",
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            if let data = tmpImage.jpegData(compressionQuality: 0.5){
                multipartFormData.append(data, withName: "fd-file", fileName: "hovos.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if (response.response!).statusCode == 200 {
                        print("Succesfully uploaded")
                        let newImage = try! JSONDecoder().decode(images.self, from: response.data!)
                        SharedUser.manager.auth.user?.image = newImage
                        completion(true,newImage.medium ?? "")
                        return
                    }
                    completion(false,response.result.error?.localizedDescription ?? "Error in upload")
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(false,error.localizedDescription)
            }
        }
    }
}
