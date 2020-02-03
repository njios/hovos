//
//  FaceVM.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/3/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import Alamofire
class FaceVM {
    var facetData:facets?
    func getFacet(completion: @escaping ()->()){
        var packet = NetworkPacket()
        packet.apiPath = ApiEndPoints.facetData.rawValue
        packet.method = HTTPMethod.get.rawValue
        ApiCall(packet: packet) { (data, status, code) in
            if code == 200{
                let decoder = JSONDecoder()
                self.facetData = try? decoder.decode(facets.self, from: data!)
               completion()
            }else{
               completion()
            }
        }
    }
}
