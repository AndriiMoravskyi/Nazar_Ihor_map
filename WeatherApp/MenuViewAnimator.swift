//
//  MenuViewAnimator.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/21/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class MenuViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Parameters
    var duration = 1.0
    var isPresenting = true
    var snapshot : UIView!
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toView = transitionContext.view(forKey: .to) ?? transitionContext.view(forKey: .from)
        
        let container = transitionContext.containerView
        
        toView?.layer.anchorPoint = CGPoint(x: 0, y: 0)
        toView?.layer.position = CGPoint(x: 0, y: 0)
        let rotate = CGAffineTransform(rotationAngle: 90)
        
        if isPresenting {
            toView?.transform = rotate
        } else {
            toView?.transform = CGAffineTransform.identity
        }
        
        container.addSubview(toView!)
    
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: [], animations: { 
            if !self.isPresenting {
                toView?.transform = rotate
            } else {
                toView?.transform = CGAffineTransform.identity
            }
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
        let cornerAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerAnimation.fromValue = isPresenting ? 20 : 0
        cornerAnimation.toValue = isPresenting ? 0: 20
        cornerAnimation.duration = duration
        toView?.layer.add(cornerAnimation, forKey: nil)
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension MenuViewAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }

}
