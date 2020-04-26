//
//  PaymentHelper.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/19/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import Adyen

class PaymentHelper:DropInComponentDelegate{
    var dropInComponent:DropInComponent!
    func didSubmit(_ data: PaymentComponentData, from component: DropInComponent) {
        let header = ["auth":SharedUser.manager.auth.auth ?? "",
                      "id":SharedUser.manager.auth.user?.listingId ?? "",
                                              "API_KEY":constants.Api_key.rawValue]
                         var paymentProcess = NetworkPacket()
                               paymentProcess.apiPath = ApiEndPoints.paymentProcess.rawValue
                               paymentProcess.header = header
                        
        paymentProcess.data = ["type":"membership",
                               "currency":"USD",
                               "paymentMethod":data.paymentMethod,
                               "couponCode":""]
        
                               paymentProcess.method = "POST"
               ViewHelper.shared().showLoader(topViewController()!)
                         ApiCall(packet: paymentProcess) { (data, status, code) in
                              ViewHelper.shared().hideLoader()
                             if code == 200{
                              Hovos.showAlert(vc: topViewController()!, mssg: "Payment process successfully")
                                
                             }else{
                                 Hovos.showAlert(vc: topViewController()!, mssg: "Error in processing")
                             }
                         }
    }
    
    func didProvide(_ data: ActionComponentData, from component: DropInComponent) {
        
    }
    
    func didFail(with error: Error, from component: DropInComponent) {
        showAlert(vc: topViewController()!, mssg: error.localizedDescription)
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
        dropInComponent.payment = Payment(amount: Payment.Amount(value: 10,
                                                                 currencyCode: "USD"))
        // Optional. In this example, the Pay button will display 10 EUR.
        topViewController()!.present(dropInComponent.viewController, animated: true)

    }
    
}
