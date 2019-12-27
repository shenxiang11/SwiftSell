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

protocol MainViewControllerDelegate: class {
    func mainViewTabChanged(index: Int)
}

class MainViewController: UIViewController {
    private lazy var headerView = HeaderView(parentController: self)
    private lazy var tab = Tab(items: ["商品", "评论", "商家"])
    weak var delegate: MainViewControllerDelegate?
    
    var vc2: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.green
        return vc
    }()
    var vc3: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        return vc
    }()
    
    lazy var tabContent = TabContent(childVCs: [GoodsViewController(), vc2, vc3], parentVC: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
}

extension MainViewController {
    private func setupUI() {
        setupHeader()
        setupTab()
        setupTabContent()
    }
    
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(136 + UIApplication.shared.windows[0].safeAreaInsets.top)
        }
    }
    
    private func setupTab() {
        view.addSubview(tab)
        tab.delegate = self
        tab.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(36)
            make.width.equalToSuperview()
        }
    }
    
    private func setupTabContent() {
        view.addSubview(tabContent)
        tabContent.tabContentDelegate = self
        tabContent.snp.makeConstraints { (make) in
            make.top.equalTo(tab.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
    
    private func fetchData() {
        fetchSeller()
    }
    
    private func fetchSeller() {
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

extension MainViewController: TabDelegate {
    func tab(_ tab: Tab, selectedIndex: Int) {
        tabContent.scrollTo(index: selectedIndex)
    }
}

extension MainViewController: TabContentDelegate {
    func tabContent(_ tabContent: TabContent, last index: Int) {
        delegate?.mainViewTabChanged(index: index)
    }
    
    func tabContent(_ tabContent: TabContent, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        tab.setActive(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
}
