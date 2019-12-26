//
//  ShopCartView.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/23.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class ShopCartView: UIView {
    
    private lazy var cartView: UIView = {[weak self] in
        let v = UIView()
        v.backgroundColor = UIColor(r: 7, g: 17, b: 27)
        v.layer.cornerRadius = 25
        v.clipsToBounds = true
        return v
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(r: 7, g: 17, b: 27)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShopCartView {
    private func setupUI() {
        setupCartView()
    }
    
    private func setupCartView() {
        self.addSubview(cartView)
        cartView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.left.equalTo(12)
            make.top.equalTo(-10)
        }
    }
}
