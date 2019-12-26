//
//  TabContent.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/23.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

protocol TabContentDelegate: class {
    func tabContent(_ tabContent: TabContent, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
    func tabContent(_ tabContent: TabContent, last index: Int)
}

class TabContent: UICollectionView {
    static let CONTENT_ID = "ContentID"
    
    private var childVCs: [UIViewController] = []
    private var parentVC: UIViewController
    weak var tabContentDelegate: TabContentDelegate?
    
    private var progress: CGFloat = 0
    private var sourceIndex = 0
    private var targetIndex = 0
    private var startOffsetX: CGFloat = 0
    private var beginOffsetX: CGFloat = 0 // 移动中不改变，移动结束才改变
    
    init(childVCs: [UIViewController], parentVC: UIViewController) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        self.delegate = self
        self.dataSource = self
        self.bounces = false
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: TabContent.CONTENT_ID)
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
    }
}

extension TabContent: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
        startOffsetX = scrollView.contentOffset.x
        beginOffsetX = scrollView.contentOffset.x
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width
    
        if currentOffsetX > startOffsetX {
            progress = currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth)
            sourceIndex = Int(currentOffsetX / scrollViewWidth)
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            if currentOffsetX - startOffsetX == scrollViewWidth {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {
            progress = 1 - (currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth))
            
            targetIndex = Int(currentOffsetX / scrollViewWidth)
            
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        tabContentDelegate?.tabContent(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print(#function)
        let currentOffsetX = scrollView.contentOffset.x
        print(currentOffsetX, beginOffsetX)
        if (beginOffsetX != currentOffsetX) {
            tabContentDelegate?.tabContent(self, last: targetIndex)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
        let currentOffsetX = scrollView.contentOffset.x
        print(currentOffsetX, beginOffsetX)
        if (beginOffsetX != currentOffsetX) {
            tabContentDelegate?.tabContent(self, last: targetIndex)
        }
        beginOffsetX = currentOffsetX
    }
}

extension TabContent {
    func scrollTo(index: Int) {
        let offset = CGPoint(x: CGFloat(index) * bounds.width, y: 0)
        self.setContentOffset(offset, animated: true)
    }
}

extension TabContent: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabContent.CONTENT_ID, for: indexPath)
                
        let childVC = childVCs[(indexPath as NSIndexPath).item]
        childVC.view.frame = cell.contentView.bounds

        cell.contentView.addSubview(childVC.view)
        cell.contentView.backgroundColor = UIColor.yellow
        childVC.view.snp.makeConstraints { (make) in
            make.height.width.equalToSuperview()
        }
        
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
