//
//  GoodsDetailViewController.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/27.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import Hero

class GoodsDetailViewController: UIViewController {

    private let food: JSON
        
    var mainImageView: UIImageView?
    private lazy var mainProductView = UIView()
    
    static let COMMENT_CELL_ID = "COMMENT_CELL_ID"
    
    private lazy var commentsTableView: UITableView = {[weak self] in
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(r: 243, g: 245, b: 247)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: GoodsDetailViewController.COMMENT_CELL_ID)
        tableView.tableFooterView = UIView() // 可以去掉多余的分割线
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var panGR: UIPanGestureRecognizer!

    init(food: JSON) {
        self.food = food
        print(food)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        self.view.addGestureRecognizer(panGR)
        
        setupUI()
        mainImageView!.heroID = food["image"].stringValue
    }
    
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGR.translation(in: nil)
        let progress = translation.x / (view.bounds.width * 0.3)

        switch gestureRecognizer.state {
        case .began:
            navigationController?.popViewController(animated: true)
        case .changed:
          Hero.shared.update(progress)
        default:
          if progress > 0.5 {
            Hero.shared.finish()
          } else {
            Hero.shared.cancel()
          }
        }
    }
    
    @objc func navigationBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension GoodsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GoodsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food["ratings"].isEmpty ? 1 : food["ratings"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoodsDetailViewController.COMMENT_CELL_ID, for: indexPath)
        cell.textLabel?.text = "\(indexPath.item)"
        return cell
    }
}

extension GoodsDetailViewController {
    private func setupUI() {
        setupCommentsTabelView()
        setupMainProductView()
        if (!food["info"].stringValue.isEmpty) {
            setGoodsInfo()
        }
    }
    
    private func setupMainProductView() {
        commentsTableView.addSubview(mainProductView)
        mainProductView.backgroundColor = UIColor.white
        mainProductView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-18)
            make.height.equalTo(mainProductView.snp.width).offset(110)
            make.width.equalToSuperview()
        }
        commentsTableView.contentInset = UIEdgeInsets(top: (UIScreen.main.bounds.width + 110 - 18 - 8), left: 0, bottom: 0, right: 0)
        setupMainImage()
        setupDescs()
    }
    
    private func setupMainImage() {
        mainImageView = UIImageView()
        mainImageView!.contentMode = .scaleAspectFill
        mainImageView!.kf.setImage(with: URL(string: food["image"].stringValue))
        mainProductView.addSubview(mainImageView!)
        
        mainImageView!.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(mainImageView!.snp.width)
        }
        
        let iconBack = UILabel()
        iconBack.font = UIFont(name: "sell-icon", size: 20)
        iconBack.textColor = UIColor.white
        iconBack.text = "\u{e900}"
        iconBack.textAlignment = .center
        mainProductView.addSubview(iconBack)
        iconBack.snp.makeConstraints { (make) in
            make.top.equalTo(10 + UIApplication.shared.windows[0].safeAreaInsets.top)
            make.width.height.equalTo(40)
        }
        let ges = UITapGestureRecognizer(target: self, action: #selector(navigationBack))
        iconBack.isUserInteractionEnabled = true
        iconBack.addGestureRecognizer(ges)
    }
    
    private func setupDescs() {
        let productNameLabel = UILabel()
        productNameLabel.text = food["name"].stringValue
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        mainProductView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainImageView!.snp.bottom).offset(18)
            make.height.equalTo(14)
            make.left.right.equalTo(18)
        }
        
        let salesRatiingLabel = UILabel()
        salesRatiingLabel.text = "月售\(food["sellCount"].intValue)份  好评率\(food["rating"].intValue)%"
        salesRatiingLabel.font = UIFont.systemFont(ofSize: 12)
        salesRatiingLabel.textColor = UIColor(r: 153, g: 153, b: 153)
        mainProductView.addSubview(salesRatiingLabel)
        salesRatiingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productNameLabel.snp.bottom).offset(14)
            make.left.equalTo(productNameLabel)
        }
        
        let currentPriceLabel = UILabel()
        currentPriceLabel.font = UIFont.systemFont(ofSize: 14)
        currentPriceLabel.textColor = UIColor(r: 240, g: 20, b: 20)
        currentPriceLabel.text = "¥\(food["price"].stringValue)"
        mainProductView.addSubview(currentPriceLabel)
        currentPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(salesRatiingLabel.snp.bottom).offset(14)
            make.left.equalTo(salesRatiingLabel)
        }
        
        if (!food["oldPrice"].stringValue.isEmpty) {
            let oldPriceLabel = UILabel()
            let ptext = "¥\(food["oldPrice"].stringValue)"
            let oldPriceAttributedText = NSMutableAttributedString(string: ptext)
            oldPriceAttributedText.addAttribute(.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, ptext.count))
            oldPriceLabel.font = UIFont.systemFont(ofSize: 12)
            oldPriceLabel.textColor = UIColor(r: 153, g: 153, b: 153)
            oldPriceLabel.attributedText = oldPriceAttributedText
            mainProductView.addSubview(oldPriceLabel)
            oldPriceLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(currentPriceLabel.snp.bottom)
                make.left.equalTo(currentPriceLabel.snp.right).offset(8)
            }
        }
    }
    
    private func setGoodsInfo() {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.text = "商品信息"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        let textLabel = UILabel()
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 10
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph]
        textLabel.attributedText = NSAttributedString(string: food["info"].stringValue, attributes: attributes)
        textLabel.numberOfLines = .max
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.textColor = UIColor(r: 102, g: 102, b: 102)
        commentsTableView.addSubview(view)
                
        view.snp.makeConstraints { (make) in
            make.top.equalTo(mainProductView.snp.bottom).offset(18)
            make.height.equalTo(128)
            make.width.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(18)
        }
        
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-18)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(26)
        }
        DispatchQueue.main.async {
            self.commentsTableView.contentInset = UIEdgeInsets(top: self.commentsTableView.contentInset.top + 128 + 18, left: 0, bottom: 0, right: 0)
            view.snp.updateConstraints { (make) in
                make.height.equalTo(65 + textLabel.bounds.height)
            }
            self.mainProductView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-18-128-18)
            }
        }
    }
    
    private func setupCommentsTabelView() {
        self.view.addSubview(commentsTableView)
        commentsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
