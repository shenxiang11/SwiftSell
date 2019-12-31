//
//  GoodsDetailCommentCell.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/31.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsDetailCommentCell: UITableViewCell {

    var rating: JSON = [] {
        didSet {
            print(rating)
            let date = Date(timeIntervalSince1970: TimeInterval(rating["rateTime"].doubleValue / 1000))
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            timeLabel.text = dateFormat.string(from: date)
        }
    }
    
    private lazy var timeLabel: UILabel = {
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
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(18)
            make.height.equalTo(12)
        }
    }
}
