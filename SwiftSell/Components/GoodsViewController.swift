//
//  GoodsViewController.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/24.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsViewController: UIViewController {
    
    static let TABLE_CELL_ID = "TABLE_CELL_ID"
    
    private var goodsTypes: JSON = [] {
        didSet {
            print(goodsTypes)
            typeTab.reloadData()
            typeTab.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }
    }

    lazy var typeTab: UITableView = {[weak self] in
        let table = UITableView()
        table.backgroundColor = UIColor(r: 243, g: 245, b: 247)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView(frame: .zero)
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.separatorColor = UIColor(r: 255, g: 255, b: 255, a: 0)
        table.register(TypeTabItem.self, forCellReuseIdentifier: GoodsViewController.TABLE_CELL_ID)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
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
        return goodsTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoodsViewController.TABLE_CELL_ID, for: indexPath) as! TypeTabItem
        let goodsType = goodsTypes[indexPath.item]
        cell.name = goodsType["name"].stringValue
        cell.type = goodsType["type"].intValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
}

extension GoodsViewController {
    private func fetchData() {
        fetchGoods()
    }
    
    private func fetchGoods() {
        NetworkManager.requestData(.get, URLString: "http://ustbhuangyi.com/sell/api/goods") { (data) in
            let goods = JSON(data)
            self.goodsTypes = goods
        }
    }
}
