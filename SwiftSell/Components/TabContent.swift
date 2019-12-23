//
//  TabContent.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/23.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class TabContent: UIView {
    static let CONTENT_ID = "ContentID"
    
    private var childVCs: [UIViewController] = []
    private var parentVC: UIViewController
    
    lazy var collectionView: UICollectionView = {[weak self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: TabContent.CONTENT_ID)
    
        return collectionView
    }()
    
    init(childVCs: [UIViewController], parentVC: UIViewController) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: .zero)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        for childVC in childVCs {
            parentVC.addChild(childVC)
        }
        
        self.backgroundColor = UIColor.gray
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.height.width.equalToSuperview()
        }
    }
}

extension TabContent: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
    }
}

extension TabContent: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabContent.CONTENT_ID, for: indexPath)
                
        let childVC = childVCs[(indexPath as NSIndexPath).item]
        childVC.view.frame = cell.contentView.bounds

        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
}

extension TabContent: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
