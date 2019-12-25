//
//  TypeTabItem.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/25.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SnapKit

class TypeTabItem: UITableViewCell {
    
    
    var type: Int? {
        didSet {
            updateLabel()
        }
    }
    var name: String? {
        didSet {
            updateLabel()
        }
    }
    private lazy var label: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLabel() {
        let richText = NSMutableAttributedString()
        var iconName: String?
        switch type {
        case 0:
            iconName = "decrease_3"
        case 1:
            iconName = "discount_3"
        case 2:
            iconName = "special_3"
        case 3:
            iconName = "invoice_3"
        case 4:
            iconName = "guarantee_3"
        default:
            break
        }
        if let iconName = iconName {
            let image = UIImage(named: iconName)
            let textAttachment = NSTextAttachment()
            textAttachment.image = image
            textAttachment.bounds = CGRect(x: 0, y: (label.font.capHeight - 12) / 2, width: 12, height: 12)
            richText.append(NSAttributedString(attachment: textAttachment))
        }
        richText.append(NSAttributedString(string: (iconName == nil ? "" : " ") + (name ?? "")))
        label.attributedText = richText
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(r: 243, g: 245, b: 247)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(r: 102, g: 102, b: 102)
        label.textAlignment = .center
        label.highlightedTextColor = UIColor(r: 51, g: 51, b: 51)
        label.numberOfLines = 2
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.bottom.equalTo(0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = selected ? UIColor(r: 255, g: 255, b: 255) : UIColor(r: 243, g: 245, b: 247)
            self.label.isHighlighted = selected
        }
    }
}
