//
//  GoodItem.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/25.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodItem: UITableViewCell {

    var food: JSON = [] {
        didSet {
            print(food)
            goodImageView.kf.setImage(with: URL(string: food["icon"].stringValue))
            goodNameLabel.text = food["name"].stringValue
            goodDescLabel.text = food["description"].stringValue
            goodSellCountLabel.text = "月售\(food["sellCount"].intValue)份"
            goodRatingLabel.text = "好评率\(food["rating"])%"
            goodPriceLabel.text = "¥ \(food["price"].stringValue)"
            
            let oldPriceText = food["oldPrice"].stringValue.count > 0 ? "¥ \(food["oldPrice"].stringValue)" : ""
            let oldPriceAttributedText = NSMutableAttributedString(string: oldPriceText)
            oldPriceAttributedText.addAttribute(.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, oldPriceText.count))
            goodOldPriceLabel.attributedText = oldPriceAttributedText
        }
    }
    
    private lazy var goodImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    private lazy var goodNameLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 14)
        v.textColor = UIColor(r: 51, g: 51, b: 51)
        return v
    }()
    private lazy var goodDescLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 12)
        v.lineBreakMode = .byTruncatingTail
        v.textColor = UIColor(r: 153, g: 153, b: 153)
        return v
    }()
    private lazy var goodSellCountLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 12)
        v.textColor = UIColor(r: 153, g: 153, b: 153)
        return v
    }()
    private lazy var goodRatingLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 12)
        v.textColor = UIColor(r: 153, g: 153, b: 153)
        return v
    }()
    private lazy var goodPriceLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 14)
        v.textColor = UIColor(r: 240, g: 20, b: 20)
        return v
    }()
    private lazy var goodOldPriceLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 12)
        v.textColor = UIColor(r: 153, g: 153, b: 153)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupUI() {
        self.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        self.addSubview(goodImageView)
        goodImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.top.left.equalTo(18)
        }
        
        self.addSubview(goodNameLabel)
        goodNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodImageView.snp.right).offset(10)
            make.top.equalTo(goodImageView)
            make.height.equalTo(14)
        }
        
        self.addSubview(goodDescLabel)
        goodDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodNameLabel)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(12)
            make.top.equalTo(goodNameLabel.snp.bottom).offset(8)
        }
        
        self.addSubview(goodSellCountLabel)
        goodSellCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodNameLabel)
            make.height.equalTo(12)
            make.top.equalTo(goodDescLabel.snp.bottom).offset(8)
        }
        
        self.addSubview(goodRatingLabel)
        goodRatingLabel.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.left.equalTo(goodSellCountLabel.snp.right).offset(12)
            make.top.equalTo(goodSellCountLabel)
        }
        
        self.addSubview(goodPriceLabel)
        goodPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(goodRatingLabel.snp.bottom).offset(8)
            make.height.equalTo(14)
            make.left.equalTo(goodSellCountLabel)
        }
        
        self.addSubview(goodOldPriceLabel)
        (goodOldPriceLabel).snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.left.equalTo(goodPriceLabel.snp.right).offset(8)
            make.bottom.equalTo(goodPriceLabel.snp.bottom)
        }
    }
}
