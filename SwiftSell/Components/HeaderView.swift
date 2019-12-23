//
//  HeaderView.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/20.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class HeaderView: UIView {
    
    var seller: Seller? {
        didSet {
            print(seller ?? "")
            if (seller != nil) {
                setupBgView(avatar: seller!.avatar)
                setupMainImageView(avatar: seller!.avatar)
                setupBrandView(name: seller!.name)
                setupDescription(description: "\(seller!.sellerDescription)/\(seller!.deliveryTime)分钟送达")
                setupSupports(supports: seller!.supports)
                setupNotice(bulletin: seller!.bulletin)
            }
        }
    }
    
    private var parentController: UIViewController
    
    private var bgView: UIImageView!
    
    private var mainImageView: UIImageView!
    
    private var brandView: UIView!
    
    private var descriptionLabel: UILabel!
        
    init(frame: CGRect, parentController: UIViewController) {
        self.parentController = parentController
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showPopup() {
        let popup = PopoverViewController(seller: seller!)
        popup.modalPresentationStyle = .overFullScreen
        popup.transitioningDelegate = self
        parentController.navigationController?.present(popup, animated: true, completion: nil)
    }
}

extension HeaderView: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimator(true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimator(false)
    }
}

extension HeaderView {
    private func setupBgView(avatar: String) {
        bgView = UIImageView(frame: self.bounds)
        bgView.contentMode = .redraw
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        self.bgView.kf.setImage(with: URL(string: avatar))
        self.addSubview(bgView)
        bgView.addSubview(blurView)
    }
    
    private func setupMainImageView(avatar: String) {
        let round = RoundCornerImageProcessor(cornerRadius: 2)
        mainImageView = UIImageView()
        mainImageView.contentMode = .scaleAspectFill
        self.addSubview(mainImageView)
        mainImageView.kf.setImage(with: URL(string: avatar), options: [.processor(round)])
        mainImageView.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.top.equalTo(24 + 44)
            make.width.height.equalTo(64)
        }
    }
    
    private func setupBrandView(name: String) {
        brandView = UIView()
        let imageView = UIImageView(image: UIImage(named: "brand"))
        imageView.contentMode = .scaleAspectFill
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = name
        brandView.addSubview(imageView)
        brandView.addSubview(label)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(18)
        }
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(6)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        self.addSubview(brandView)
        brandView.snp.makeConstraints { (make) in
            make.left.equalTo(self.mainImageView.snp.right).offset(16)
            make.top.equalTo(self.mainImageView.snp.top)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(18)
        }
    }
    
    private func setupDescription(description: String) {
        descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.left.equalTo(brandView.snp.left)
            make.top.equalTo(brandView.snp.bottom).offset(8)
        }
    }
    
    private func setupSupports(supports: [Support]) {
        if let firstSupport = supports.first {
            let supportView = UIView()
            var iconName: String
            switch firstSupport.type {
            case .decrease:
                iconName = "decrease_1"
            case .discount:
                iconName = "discount_1"
            case .special:
                iconName = "special_1"
            case .invoice:
                iconName = "invoice_1"
            case .guarantee:
                iconName = "guarantee_1"
            }
            
            let iconImageView = UIImageView(image: UIImage(named: iconName))
            supportView.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { (make) in
                make.width.height.equalTo(12)
            }
            
            let label = UILabel()
            label.text = firstSupport.supportDescription
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 12)
            supportView.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(4)
                make.centerY.equalTo(iconImageView.snp.centerY)
            }
            self.addSubview(supportView)
            supportView.snp.makeConstraints { (make) in
                make.height.equalTo(12)
                make.left.equalTo(descriptionLabel.snp.left)
                make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            }
            
            let countLabel = UILabel()
            countLabel.text = "\(supports.count)个 >"
            countLabel.font = UIFont.systemFont(ofSize: 12)
            countLabel.textColor = UIColor.white
            countLabel.textAlignment = .center
            countLabel.backgroundColor = UIColor(r: 7, g: 17, b: 27, a: 0.2)
            countLabel.layer.cornerRadius = 12
            countLabel.clipsToBounds = true
            self.addSubview(countLabel)
            countLabel.snp.makeConstraints { (make) in
                make.width.equalTo(50)
                make.height.equalTo(24)
                make.right.equalToSuperview().offset(-24)
                make.centerY.equalTo(supportView.snp.centerY)
            }
            
            let ges = UITapGestureRecognizer(target: self, action: #selector(showPopup))
            countLabel.isUserInteractionEnabled = true
            countLabel.addGestureRecognizer(ges)
        }
    }

    private func setupNotice(bulletin: String) {
        let noticeView = UIView()
        noticeView.backgroundColor = UIColor(r: 7, g: 17, b: 27, a: 0.2)
        self.addSubview(noticeView)
        noticeView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(28)
            make.bottom.equalToSuperview()
        }
        
        let noticeImage = UIImageView(image: UIImage(named: "bulletin"))
        noticeImage.contentMode = .center
        noticeView.addSubview(noticeImage)
        noticeImage.snp.makeConstraints { (make) in
            make.width.equalTo(22)
            make.height.equalTo(12)
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
     
        let textLabel = UILabel()
        textLabel.text = bulletin
        textLabel.font = UIFont.systemFont(ofSize: 10)
        textLabel.numberOfLines = 1
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.textColor = UIColor.white
        noticeView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(noticeImage.snp.right).offset(4)
        }
        
        let rightLabel = UILabel()
        rightLabel.text = ">"
        rightLabel.font = UIFont.systemFont(ofSize: 10)
        rightLabel.textColor = UIColor.white
        noticeView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(textLabel.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
        }
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(showPopup))
        noticeView.addGestureRecognizer(ges)
    }
}
