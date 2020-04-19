//
//  PaymentViewController.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 4/19/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func makePayment(_ sender:UIButton){
        PaymentHelper().getPaymentMethod()
    }


}
