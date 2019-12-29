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
    private lazy var navgationVC = UINavigationController(rootViewController: mainVC)
    private lazy var mainVC = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainVC.delegate = self
        navgationVC.isHeroEnabled = true
        navgationVC.interactivePopGestureRecognizer?.isEnabled = false
        navgationVC.setNavigationBarHidden(true, animated: false)
        self.addChild(navgationVC)
        setupShopCart()
        self.view.insertSubview(navgationVC.view, belowSubview: shopCartView)
        navgationVC.view.snp.makeConstraints { (make) in
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
            make.centerX.equalToSuperview()
        }
    }
}

extension ViewController: MainViewControllerDelegate {
    func mainViewTabChanged(index: Int) {
        if (index == 0) {
            shopCartView.isHidden = false
            navgationVC.view.snp.remakeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(shopCartView.snp.top)
            }
        } else {
            shopCartView.isHidden = true
            navgationVC.view.snp.remakeConstraints { (make) in
                make.top.left.right.bottom.equalToSuperview()
            }
        }
    }
}
