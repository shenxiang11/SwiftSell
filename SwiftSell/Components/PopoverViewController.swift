//
//  PopoverViewController.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/22.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SnapKit

class PopoverViewController: UIViewController {
    
    private var seller: Seller
    
    private var shopNameLabel: UILabel?
    private var starsContainer: UIView?
    private var supportsTitleContainer: UIView?
    private var bulletionContainer: UIView?
    private var bulletionContent: UILabel?
    private var supportContainer: UIView?
    
    init(seller: Seller) {
        self.seller = seller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func closeSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension PopoverViewController {
    private func setupUI() {
        setupBackground()
        setupShopName()
        setupStars()
        setupSupportsTitle()
        setupSupports()
        setupBulletinTitle()
        setupBulletionContent()
        setupClose()
    }
    
    private func setupBackground() {
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = UIColor(r: 7, g: 17, b: 27, a: 0.8)
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
    }
    
    private func setupShopName() {
        shopNameLabel = UILabel()
        shopNameLabel!.text = seller.name
        shopNameLabel!.textColor = UIColor(r: 255, g: 255, b: 255)
        shopNameLabel!.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(shopNameLabel!)
        shopNameLabel!.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(64)
        }
    }
    
    private func setupStars() {
        let score = Int(seller.score)
        let restScore = 5.0 - seller.score
        starsContainer = UIView()
        self.view.addSubview(starsContainer!)
        starsContainer!.snp.makeConstraints { (make) in
            make.width.equalTo(5 * 20 + 18 * 4)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(shopNameLabel!.snp.bottom).offset(18)
        }
        var lastView: UIImageView?
        for _ in 0..<score {
            let positiveStar = UIImageView(image: UIImage(named: "star48_on"))
            positiveStar.contentMode = .scaleAspectFill
            starsContainer!.addSubview(positiveStar)
            positiveStar.snp.makeConstraints { (make) in
                make.width.height.equalTo(20)
                if lastView != nil {
                    make.left.equalTo(lastView!.snp.right).offset(22)
                }
            }
            lastView = positiveStar
        }
        for index in 0..<Int(ceil(restScore)) {
            var star: UIImageView
            if (index == 0) {
                let isHalf = seller.score - Double(score) > 0.5
                star = UIImageView(image: UIImage(named: isHalf ? "star48_half" : "star48_off"))
            } else {
                star = UIImageView(image: UIImage(named: "star48_off"))
            }
            starsContainer!.addSubview(star)
            star.snp.makeConstraints { (make) in
                make.width.height.equalTo(20)
                if lastView != nil {
                    make.left.equalTo(lastView!.snp.right).offset(22)
                }
            }
            lastView = star
        }
    }
    
    private func setupSupportsTitle() {
        supportsTitleContainer = UIView()
        let label = UILabel()
        label.textAlignment = .center
        label.text = "优惠信息"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        let lineLeft = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 1))
        let lineRight = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 1))
        lineLeft.backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 0.2)
        lineRight.backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 0.2)
        self.view.addSubview(supportsTitleContainer!)
        supportsTitleContainer!.addSubview(label)
        supportsTitleContainer!.addSubview(lineLeft)
        supportsTitleContainer!.addSubview(lineRight)
        
        supportsTitleContainer!.snp.makeConstraints { (make) in
            make.top.equalTo(starsContainer!.snp.bottom).offset(28)
            make.height.equalTo(14)
            make.width.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        lineLeft.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.lessThanOrEqualToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.right.equalTo(label.snp.left).offset(-12)
        }
        
        lineRight.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.right.greaterThanOrEqualToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.left.equalTo(label.snp.right).offset(12)
        }
    }
    
    private func setupSupports() {
        supportContainer = UIView()
        self.view.addSubview(supportContainer!)
        supportContainer!.snp.makeConstraints { (make) in
            make.top.equalTo(supportsTitleContainer!.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(28 * seller.supports.count)
        }
        
        var lastView = supportsTitleContainer!
        for support in seller.supports {
            var iconName: String
            switch support.type {
            case .decrease:
                iconName = "decrease_2"
            case .discount:
                iconName = "discount_2"
            case .special:
                iconName = "special_2"
            case .invoice:
                iconName = "invoice_2"
            case .guarantee:
                iconName = "guarantee_2"
            }
            
            let itemView = UIView()
            let iconImageView = UIImageView(image: UIImage(named: iconName))
            
            supportContainer!.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(12)
                make.height.equalTo(16)
                make.left.equalToSuperview().offset(32)
                make.right.equalToSuperview().offset(-32)
            }
            lastView = itemView
            
            itemView.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { (make) in
                make.width.height.equalTo(16)
            }
            
            let label = UILabel()
            label.text = support.supportDescription
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 12)
            itemView.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(6)
                make.centerY.equalTo(iconImageView.snp.centerY)
            }
        }
    }
    
    private func setupBulletinTitle() {
        bulletionContainer = UIView()
        let label = UILabel()
        label.textAlignment = .center
        label.text = "商家公告"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        let lineLeft = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 1))
        let lineRight = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 1))
        lineLeft.backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 0.2)
        lineRight.backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 0.2)
        self.view.addSubview(bulletionContainer!)
        bulletionContainer!.addSubview(label)
        bulletionContainer!.addSubview(lineLeft)
        bulletionContainer!.addSubview(lineRight)

        bulletionContainer!.snp.makeConstraints { (make) in
            make.top.equalTo(supportContainer!.snp.bottom).offset(28)
            make.height.equalTo(14)
            make.width.equalToSuperview()
        }

        label.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalTo(60)
            make.centerX.equalToSuperview()
        }

        lineLeft.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.lessThanOrEqualToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.right.equalTo(label.snp.left).offset(-12)
        }

        lineRight.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.right.greaterThanOrEqualToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.left.equalTo(label.snp.right).offset(12)
        }
    }
    
    private func setupBulletionContent() {
        bulletionContent = UILabel()
        bulletionContent!.font = UIFont.systemFont(ofSize: 12)
        bulletionContent!.textColor = UIColor.white
        bulletionContent!.numberOfLines = 0
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 12
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph]
        bulletionContent!.attributedText = NSAttributedString(string: seller.bulletin, attributes: attributes)
        self.view.addSubview(bulletionContent!)
        bulletionContent!.snp.makeConstraints { (make) in
            make.top.equalTo(bulletionContainer!.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
    }
    
    private func setupClose() {
        let label = UILabel()
        label.text = "✕"
        label.textColor = UIColor(r: 255, g: 255, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        self.view.addSubview(label)
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeSelf))
        label.addGestureRecognizer(gesture)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-64)
        }
    }
}
