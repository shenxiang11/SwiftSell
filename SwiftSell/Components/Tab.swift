//
//  Tab.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/23.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SnapKit

protocol TabDelegate: class {
    func tab(_ tab: Tab, selectedIndex: Int)
}

class Tab: UIView {
    private var items: [String] = []
    private var itemButtons: [UIButton] = []
    private var selectedItemButton: UIButton!
    private var indicatorView: UIView!
    weak var delegate: TabDelegate?
    
    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        self.createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        var lastView: UIView?
        for index in 0..<items.count {
            let button = UIButton(type: .custom)
            button.setTitle(items[index], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(UIColor(r: 102, g: 102, b: 102), for: .normal)
            button.setTitleColor(UIColor(r: 240, g: 20, b: 20), for: .selected)
            button.tag = index
            self.addSubview(button)
            if index == 0 {
                button.isSelected = true
                selectedItemButton = button
            }
            button.snp.makeConstraints { (make) in
                if index == 0 {
                    make.left.equalToSuperview()
                } else {
                    make.left.equalTo(lastView!.snp.right)
                    make.width.equalTo(lastView!)
                }
                make.top.bottom.equalToSuperview()
                if index == items.count - 1 {
                    make.right.equalToSuperview()
                }
            }
            lastView = button
            button.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
            itemButtons.append(button)
        }
        indicatorView = UIView()
        indicatorView.backgroundColor = UIColor(r: 240, g: 20, b: 20)
        self.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalTo(selectedItemButton)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(items.count)
            make.height.equalTo(2)
        }
    }
    
    @objc func didClickButton(sender: UIButton) {
        guard sender != selectedItemButton else {
            return
        }
        delegate?.tab(self, selectedIndex: sender.tag)
        selectedItemButton.isSelected = false
        sender.isSelected = true
        selectedItemButton = sender
        self.indicatorView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.selectedItemButton)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(items.count)
            make.height.equalTo(2)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
