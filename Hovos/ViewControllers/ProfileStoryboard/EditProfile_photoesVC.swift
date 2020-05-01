//
//  EditProfile_photoesVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/27/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class EditProfile_photoesVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
@IBOutlet weak var collView:UICollectionView!
var images = [UIImage]()
    @IBOutlet weak var placeholder:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count > 0{
            placeholder.isHidden = true
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photocell", for: indexPath) as! Photocell
        cell.image.image = images[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width/3 - 10), height: (self.view.frame.width/3 - 10))
    }

    @IBAction func openCamera(_ sender:UIButton){
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
        
        images.append(info[.editedImage] as! UIImage)
        collView.reloadData()
        picker.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    
}

class Photocell:UICollectionViewCell{
    @IBOutlet weak var image:UIImageView!
}
