//
//  NetworkManager.swift
//  
//
//  Created by 沈翔 on 2019/12/20.
//

import UIKit
import Alamofire
import SwiftyJSON

enum MethodType {
    case get
    case post
}

class NetworkManager {
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        AF.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                
                if (json["errno"] == 0) {
                    finishedCallback(json["data"])
                } else {
                    debugPrint(json)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
