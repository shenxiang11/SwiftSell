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
    
    private var panGR: UIPanGestureRecognizer!

    init(food: JSON) {
        self.food = food
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
        let progress = translation.y / (view.bounds.height * 0.3)

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

extension GoodsDetailViewController {
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        setupMainImage()
    }
    
    private func setupMainImage() {
        mainImageView = UIImageView()
        mainImageView!.contentMode = .scaleAspectFill
        mainImageView!.kf.setImage(with: URL(string: food["image"].stringValue))
        self.view.addSubview(mainImageView!)
        
        mainImageView!.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(mainImageView!.snp.width)
        }
        
        let iconBack = UILabel()
        iconBack.font = UIFont(name: "sell-icon", size: 20)
        iconBack.textColor = UIColor.white
        iconBack.text = "\u{e900}"
        iconBack.textAlignment = .center
        self.view.addSubview(iconBack)
        iconBack.snp.makeConstraints { (make) in
            make.top.equalTo(10 + UIApplication.shared.windows[0].safeAreaInsets.top)
            make.width.height.equalTo(40)
        }
        let ges = UITapGestureRecognizer(target: self, action: #selector(navigationBack))
        iconBack.isUserInteractionEnabled = true
        iconBack.addGestureRecognizer(ges)
    }
}
