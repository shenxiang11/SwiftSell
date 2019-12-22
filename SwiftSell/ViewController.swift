//
//  ViewController.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/20.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

let kScreenWidth = UIScreen.main.bounds.width

class ViewController: UIViewController {
    private lazy var headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 136 + 44))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
}

extension ViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.gray
        setupHeader()
    }
    
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(136 + 44)
        }
    }
    
    private func fetchData() {
        NetworkManager.requestData(.get, URLString: "http://ustbhuangyi.com/sell/api/seller") { (data) in
            let seller = JSON(data)
            let supports: [Support] = {
                var arr: [Support] = []
                for (_, json): (String, JSON) in seller["supports"] {
                    arr.append(Support(type: supportIconType(rawValue: json["type"].intValue)!, supportDescription: json["description"].stringValue))
                }
                return arr
            }()
            let pics: [String] = {
                var arr: [String] = []
                for s in seller["pics"] {
                    arr.append(s.0)
                }
                return arr
            }()
            let infos: [String] = {
                var arr: [String] = []
                for s in seller["infos"] {
                    arr.append(s.0)
                }
                return arr
            }()

            self.headerView.seller = Seller(name: seller["name"].stringValue, sellerDescription:
                seller["description"].stringValue, deliveryTime: seller["deliveryTime"].intValue, score: seller["score"].doubleValue, serviceScore: seller["serviceScore"].doubleValue, foodScore: seller["foodScore"].doubleValue, rankRate: seller["rankRate"].doubleValue, minPrice: seller["minPrice"].doubleValue, deliveryPrice: seller["deliveryPrice"].doubleValue, ratingCount: seller["ratingCount"].intValue, sellCount: seller["sellCount"].intValue, bulletin: seller["bulletin"].stringValue, supports: supports, avatar: seller["avatar"].stringValue, pics: pics, infos: infos)
        }
    }
}
