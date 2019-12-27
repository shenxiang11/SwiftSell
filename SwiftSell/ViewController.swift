//
//  ViewController.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/27.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private lazy var shopCartView = ShopCartView()
    private lazy var mainVC = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainVC.delegate = self
        self.addChild(mainVC)
        setupShopCart()
        self.view.insertSubview(mainVC.view, belowSubview: shopCartView)
        mainVC.view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(shopCartView.snp.top)
        }
    }
    
    private func setupShopCart() {
        view.addSubview(shopCartView)
        shopCartView.snp.makeConstraints { (make) in
            make.height.equalTo(56 + UIApplication.shared.windows[0].safeAreaInsets.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}

extension ViewController: MainViewControllerDelegate {
    func mainViewTabChanged(index: Int) {
        if (index == 0) {
            shopCartView.isHidden = false
            mainVC.view.snp.remakeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(shopCartView.snp.top)
            }
        } else {
            shopCartView.isHidden = true
            mainVC.view.snp.remakeConstraints { (make) in
                make.top.left.right.bottom.equalToSuperview()
            }
        }
        // 临时解决方案-思考如何更新布局呢🤔
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { _ in
            self.mainVC.tabContent.reloadData()
        }
    }
}
