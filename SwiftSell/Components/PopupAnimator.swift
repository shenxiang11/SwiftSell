//
//  PopupAnimator.swift
//  SwiftSell
//
//  Created by 沈翔 on 2019/12/23.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class PopupAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private var isPresenting: Bool
    
    init(_ isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: isPresenting ? .to : .from) else { return }
        
        transitionContext.containerView.addSubview(toView)
        
        toView.alpha = isPresenting ? 0 : 1
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = self.isPresenting ? 1 : 0
        }) { _ in
            toView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
