//
//  PopoverViewController.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/22.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PopoverViewController {
    private func setupUI() {
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = UIColor.green
    }
}
