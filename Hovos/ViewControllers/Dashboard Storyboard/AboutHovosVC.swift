//
//  AboutHovosVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 3/21/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import UIKit

class AboutHovosVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblView:UITableView!
    private let titles = ["Hovos App",
    "What Hovos is about",
    "Purpose of the service",
    "Backgroud of the makers",
    "Contact details"]
    
    private let subtitles = ["Version 1.0.3 last update August 31 2020",
    "Hovos is a marketplace for connecting colunteers and hosts. Volunteers offer their help to hosts who offer accommodations and board in return.",
    "Through Hovos we encourage connecting hosts and volunteers, creating new relationships between them and offering volunteers to learn new skills. We believe by meeting other people and experiencing new culture we grow spiritually.",
    "Hovos ia a product of the company Pimpernel Online Entertainment, founded in 1990 by Mark Wiersma. Pimpernel's activities have always been involved with developing online content. The most recent highlight was HomeForExchange.com, a prominent global home exchange platform, sold in 2015 to LoveHomeSwap.com.",
    "Contact us through the contact form or directly through support@hovos.com. We welcome feedback and suggestions and partnerships, so get in touch with us.\nYou can also reach us through our Facebook, Twitter or instagram accounts."]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutHovosCell") as! AboutHovosCell
        cell.ttlText.text = titles[indexPath.row]
        cell.subTtlText.text = subtitles[indexPath.row]
        return cell
    }
 

}

class AboutHovosCell:UITableViewCell{
    @IBOutlet weak var ttlText:UILabel!
    @IBOutlet weak var subTtlText:UILabel!
}
