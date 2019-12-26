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
    static let TABLE_CELL_ID2 = "TABLE_CELL_ID2"
    
    private var goodsTypes: JSON = [] {
        didSet {
            typeTab.reloadData()
            goodsTable.reloadData()
            typeTab.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }
    }

    lazy var typeTab: UITableView = {[weak self] in
        let table = UITableView()
        table.backgroundColor = UIColor(r: 243, g: 245, b: 247)
        table.delegate = self
        table.dataSource = self
        table.separatorColor = UIColor(r: 255, g: 255, b: 255, a: 0)
        table.register(TypeTabItem.self, forCellReuseIdentifier: GoodsViewController.TABLE_CELL_ID)
        return table
    }()
    
    lazy var goodsTable: UITableView = {[weak self] in
        let table = UITableView()
        table.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        table.delegate = self
        table.dataSource = self
        table.register(GoodItem.self, forCellReuseIdentifier: GoodsViewController.TABLE_CELL_ID2)
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
        setupGoodsTable()
    }
    
    private func setupTypeTab() {
        self.view.addSubview(typeTab)
        typeTab.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
    }
    
    private func setupGoodsTable() {
        self.view.addSubview(goodsTable)
        goodsTable.snp.makeConstraints { (make) in
            make.left.equalTo(typeTab.snp.right)
            make.right.top.bottom.equalToSuperview()
        }
    }
}

extension GoodsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (tableView.isEqual(typeTab)) {
            goodsTable.scrollToRow(at: IndexPath(item: 0, section: indexPath.item), at: .top, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollView = scrollView as? UITableView, goodsTable.isEqual(scrollView) else {
            return
        }
        guard let cell = scrollView.visibleCells.first else {
            return
        }
        typeTab.selectRow(at: IndexPath(row: cell.tag, section: 0), animated: true, scrollPosition: .top)
    }
}

extension GoodsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (tableView.isEqual(goodsTable)) {
            let view = UIView()
            let label = UILabel()
            let leftBorder = UIView(frame: .zero)
            leftBorder.backgroundColor = UIColor(r: 217, g: 221, b: 225)
            label.text = goodsTypes[section]["name"].stringValue
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor(r: 102, g: 102, b: 102)
            view.backgroundColor = UIColor(r: 243, g: 245, b: 247)
            view.addSubview(leftBorder)
            view.addSubview(label)
            leftBorder.snp.makeConstraints { (make) in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(2)
            }
            label.snp.makeConstraints { (make) in
                make.height.equalToSuperview()
                make.left.equalTo(leftBorder.snp.right).offset(14)
            }
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (tableView.isEqual(goodsTable)) {
            return 26
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView.isEqual(typeTab)) {
            return 1
        } else {
            return goodsTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.isEqual(typeTab)) {
            return goodsTypes.count
        } else {
            return goodsTypes[section]["foods"].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView.isEqual(typeTab)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: GoodsViewController.TABLE_CELL_ID, for: indexPath) as! TypeTabItem
            let goodsType = goodsTypes[indexPath.item]
            cell.name = goodsType["name"].stringValue
            cell.type = goodsType["type"].intValue
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: GoodsViewController.TABLE_CELL_ID2, for: indexPath) as! GoodItem
            cell.tag = indexPath.section
            cell.food = goodsTypes[indexPath.section]["foods"][indexPath.item]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView.isEqual(typeTab)) {
            return 56.0
        } else {
            return 113.0
        }
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
