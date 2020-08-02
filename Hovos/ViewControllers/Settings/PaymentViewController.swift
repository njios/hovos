//
//  PaymentViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/19/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit
import Adyen
class PaymentViewController: UIViewController,DropInComponentDelegate {
    
    var dropInComponent:DropInComponent!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func makePayment(_ sender:UIButton){
        getPaymentMethod()
    }
    
    func didSubmit(_ data: PaymentComponentData, from component: DropInComponent) {
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.user?.listingId ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var paymentProcess = NetworkPacket()
        paymentProcess.apiPath = ApiEndPoints.paymentProcess.rawValue
        paymentProcess.header = header
        let card:CardDetails! = (data.paymentMethod as? CardDetails)
        if card != nil {
            let bodyData = try! JSONEncoder().encode(card)
            let paymentMethod = try! JSONSerialization.jsonObject(with: bodyData, options: [])
            paymentProcess.data = [
                "currency":"USD",
                "paymentMethod":paymentMethod,
                "couponCode":"",
                "type":"membership"
            ]
        }else{
            let card = (data.paymentMethod as! EmptyPaymentDetails)
            let bodyData = try! JSONEncoder().encode(card)
            let paymentMethod = try! JSONSerialization.jsonObject(with: bodyData, options: [])
            paymentProcess.data = [
                "currency":"USD",
                "paymentMethod":paymentMethod,
                "couponCode":"",
                "type":"membership"
            ]
        }
        
        paymentProcess.method = "POST"
        ViewHelper.shared().showLoader(topViewController()!)
        ApiCallWithJsonEncoding(packet: paymentProcess) { (data, status, code) in
            ViewHelper.shared().hideLoader()
           
            if code == 200{
                                    DispatchQueue.main.async {
                        
                        
                        if let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                            if (json["resultCode"] as! String) == "Authorised"{
                                self.dismiss(animated: true){

                            let vc = PaymentConfirmVC(nibName: "PaymentConfirmVC", bundle: nil)
                            vc.modalPresentationStyle = .overCurrentContext
                            self.present(vc, animated: true, completion: nil)
                                }
                            }else if (json["resultCode"] as! String) == "RedirectShopper"{
                                let actiondata = try! JSONSerialization.data(withJSONObject: json["action"]!, options: [])
                                 let action = try! JSONDecoder().decode(Action.self, from: actiondata)
                                self.dropInComponent.handle(action)
                               
                            }
                            else{
                                self.dismiss(animated: true){
                                   Hovos.showAlert(vc: topViewController()!, mssg: "Error : " + (json["resultCode"] as! String))
                                }
                            }
                        } else if let string = String(data: data!, encoding: .utf8){
                            self.dismiss(animated: true){
                            Hovos.showAlert(vc: topViewController()!, mssg: "Error : " + string)
                            }
                        }
                    }
                
            }else{
                if let string =  String(data: data!, encoding: .utf8){
                    Hovos.showAlert(vc: topViewController()!, mssg: string)
                }else{
                Hovos.showAlert(vc: topViewController()!, mssg: "Error in processing")
                }
            }
        }
    }
    
    func didProvide(_ data: ActionComponentData, from component: DropInComponent) {
        print("config")
    }
    
    func didFail(with error: Error, from component: DropInComponent) {
        self.dismiss(animated: true, completion: nil)
    }
    var paymentMethods:PaymentMethods!
    func getPaymentMethod(){
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.user?.listingId ?? "",
                      "API_KEY":constants.Api_key.rawValue]
        var paymentMethod = NetworkPacket()
        paymentMethod.apiPath = ApiEndPoints.paymentMethod.rawValue
        paymentMethod.header = header
        
        
        paymentMethod.method = "GET"
        ViewHelper.shared().showLoader(topViewController()!)
        ApiCall(packet: paymentMethod) { (data, status, code) in
            ViewHelper.shared().hideLoader()
            if code == 200{
                self.paymentMethods = try? JSONDecoder().decode(PaymentMethods.self, from: data!)
                self.configPaymentMethod()
            }else{
                Hovos.showAlert(vc: topViewController()!, mssg: "Error in getting Payment methods")
            }
        }
    }
    
    
    func configPaymentMethod(){
        let configuration = DropInComponent.PaymentMethodsConfiguration()
        configuration.card.publicKey = constants.testPaymentKey.rawValue
        // Your public key, retrieved from the Customer Area.
        // Check specific payment method pages to confirm if you need to configure additional required parameters.
        // For example, to enable the Card form, you need to provide your Client Encryption Public Key.
        dropInComponent = DropInComponent(paymentMethods: paymentMethods,
                                          paymentMethodsConfiguration: configuration)
        dropInComponent.delegate = self
        dropInComponent.environment = .test
        dropInComponent.payment = Payment(amount: Payment.Amount(value: 1000,
                                                                 currencyCode: "USD"))
        // Optional. In this example, the Pay button will display 10 EUR.
        topViewController()!.present(dropInComponent.viewController, animated: true)
        
    }
    
}
