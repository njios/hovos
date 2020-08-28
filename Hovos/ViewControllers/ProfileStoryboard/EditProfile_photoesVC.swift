//
//  EditProfile_photoesVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/27/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
class EditProfile_photoesVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var placeholder:UIImageView!
    @IBOutlet weak var titletext:UILabel!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var deleteButton:UIButton!
    var imageArray = [String]()
    var type = ""
    var selectedIndexes = [String](){
        didSet{
            if selectedIndexes.count > 0{
                deleteButton.isHidden = false
            }else{
                deleteButton.isHidden = true
            }
        }
    }
    var ids = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == "place"{
            titletext.text = "Photos of your place"
        }
        if type == "accommodations"{
            titletext.text = "Accommodation photos"
            placeholder.image = UIImage(named: "accomodationImages")
        }
        ViewHelper.shared().showLoader(self)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        filteredData()
    }
    
    private func filteredData(){
        ids.removeAll()
        imageArray.removeAll()
        if type == "accommodations"{
            for i in 0 ..< (SharedUser.manager.auth.listing?.accommodationImages?.count ?? 0){
                ids.append(SharedUser.manager.auth.listing?.accommodationImages?[i].id ?? "")
                imageArray.append(SharedUser.manager.auth.listing?.accommodationImages?[i].medium ?? "")
                
            }
        }else{
            for i in 0 ..< (SharedUser.manager.auth.listing?.images?.count ?? 0){
                ids.append(SharedUser.manager.auth.listing?.images?[i].id ?? "")
                imageArray.append(SharedUser.manager.auth.listing?.images?[i].medium ?? "")
                
            }
        }
        ViewHelper.shared().hideLoader()
        collView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count > 0{
            placeholder.isHidden = true
        }
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photocell", for: indexPath) as! Photocell
        cell.image.kf.indicatorType = .activity
        let rescource = URL(string: imageArray[indexPath.row])
        cell.image.kf.setImage(with: rescource!)
        if selectedIndexes.contains(ids[indexPath.row]){
            cell.layoverimage.isHidden = false
        }else{
            cell.layoverimage.isHidden = true
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width/3 - 2), height: (self.view.frame.width/3 - 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndexes.contains(ids[indexPath.row]){
            selectedIndexes = selectedIndexes.filter({ (item) -> Bool in
                if item == ids[indexPath.row]{
                    return false
                }else{
                    return true
                }
            })
        }else{
            selectedIndexes.append(ids[indexPath.row])
        }
        collectionView.reloadData()
    }
    
    @IBAction func deleteImages(_ sender:UIButton){
        if SharedUser.manager.auth.role == "V"{
            
            
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "id":SharedUser.manager.auth.user?.listingId ?? "",
                          "API_KEY":constants.Api_key.rawValue]
            
            var packet = NetworkPacket()
            
            packet.apiPath = ApiEndPoints.deleteTravellerImage(id: selectedIndexes.joined(separator: ",")).rawValue
            packet.method = HTTPMethod.delete.rawValue
            packet.header = header
            
            ViewHelper.shared().showLoader(self)
            ApiCall(packet: packet) { (data, status, code) in
                if code == 200{
                    
                    let filteredImages = SharedUser.manager.auth.listing?.images?.filter({ (img) -> Bool in
                        if self.selectedIndexes.contains(img.id ?? ""){
                            return false
                        }else{
                            return true
                        }
                    })
                    SharedUser.manager.auth.listing?.images = filteredImages
                    
                    
                    self.selectedIndexes.removeAll()
                    DispatchQueue.main.async {
                        self.filteredData()
                    }
                }
                ViewHelper.shared().hideLoader()
            }
            
        }else{
            
            
            let header = ["auth":SharedUser.manager.auth.auth ?? "",
                          "id":SharedUser.manager.auth.user?.listingId ?? "",
                          "API_KEY":constants.Api_key.rawValue]
            
            var packet = NetworkPacket()
            
            
            packet.apiPath = ApiEndPoints.deleteHostImage(id: selectedIndexes.joined(separator: ",")).rawValue
            
            packet.method = HTTPMethod.delete.rawValue
            packet.header = header
            
            ViewHelper.shared().showLoader(self)
            ApiCall(packet: packet) { (data, status, code) in
                if code == 200{
                    
                    
                    if self.type == "place"{
                        
                        let filteredImages = SharedUser.manager.auth.listing?.images?.filter({ (img) -> Bool in
                            if self.selectedIndexes.contains(img.id ?? ""){
                                return false
                            }else{
                                return true
                            }
                        })
                        SharedUser.manager.auth.listing?.images = filteredImages
                    }else{
                        let filteredImages = SharedUser.manager.auth.listing?.accommodationImages?.filter({ (img) -> Bool in
                            if self.selectedIndexes.contains(img.id ?? ""){
                                return false
                            }else{
                                return true
                            }
                        })
                        SharedUser.manager.auth.listing?.accommodationImages = filteredImages
                    }
                    
                    self.selectedIndexes.removeAll()
                    DispatchQueue.main.async {
                        self.filteredData()
                    }
                }
                ViewHelper.shared().hideLoader()
            }
            
        }
    }
    
    @IBAction func openCamera(_ sender:UIButton){
        
        
        
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.allowsEditing = true
        
        
        let alert = UIAlertController(title: "Alert", message: "Add photos about yourself", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Take a photo now", style: .default) { (action) in
            
            
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                pickerView.sourceType = .camera
                alert.dismiss(animated: false) {
                    DispatchQueue.main.async {
                        self.present(pickerView, animated: false, completion: nil)
                    }
                    
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
        
        ViewHelper.shared().showLoader(self)
        uploadImage(tmpImage:  info[.editedImage] as! UIImage) {
            ViewHelper.shared().hideLoader()
            DispatchQueue.main.async {
                self.collView.reloadData()
            }
        }
        picker.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    func uploadImage(tmpImage:UIImage,completion: @escaping (()->())){
        
        var parameters = [
            "filename": "custom"
        ]
        
        if self.type == "accommodations"{
            parameters["isAccommodation"] = "Y"
        }else{
            parameters["isAccommodation"] = "N"
        }
        
        var url = ""
        
        if SharedUser.manager.auth.role?.lowercased() == "h"{
            url = "https://www.hovos.com/api/host/image/\(SharedUser.manager.auth.user?.listingId ?? "")"
        }else{
            url = "https://www.hovos.com/api/traveller/image/\(SharedUser.manager.auth.user?.listingId ?? "")"
        }
        
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "auth":SharedUser.manager.auth.auth ?? "",
            "API_KEY":constants.Api_key.rawValue
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
                        if self.type == "accommodations"{
                            if SharedUser.manager.auth.listing?.accommodationImages == nil{
                                SharedUser.manager.auth.listing?.accommodationImages = [newImage]
                            }else{
                                SharedUser.manager.auth.listing?.accommodationImages?.append(newImage)
                            }
                        }else{
                            if SharedUser.manager.auth.listing?.images == nil{
                                SharedUser.manager.auth.listing?.images = [newImage]
                            }else{
                                SharedUser.manager.auth.listing?.images?.append(newImage)
                            }
                        }
                        DispatchQueue.main.async {
                            self.filteredData()
                        }
                        
                        completion()
                        return
                    }
                    completion()
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
}
class Photocell:UICollectionViewCell{
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var layoverimage:UIView!
}
