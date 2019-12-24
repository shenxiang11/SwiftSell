//
//  GoodsViewController.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/24.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class GoodsViewController: UIViewController {
    
    static let TABLE_CELL_ID = "TABLE_CELL_ID"

    private lazy var typeTab: UITableView = {[weak self] in
        let table = UITableView()
        table.backgroundColor = UIColor(r: 243, g: 245, b: 247)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: GoodsViewController.TABLE_CELL_ID)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension GoodsViewController {
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        setupTypeTab()
    }
    
    private func setupTypeTab() {
        self.view.addSubview(typeTab)
        typeTab.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
    }
}

extension GoodsViewController: UITableViewDelegate {
    
}

extension GoodsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoodsViewController.TABLE_CELL_ID, for: indexPath)
        return cell
    }
}
