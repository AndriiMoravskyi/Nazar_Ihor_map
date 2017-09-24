//
//  DetailViewAnimator.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/16/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class DetailViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Parameters
    let duration = 1.0
    var originFrame = CGRect.zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let detailView = transitionContext.view(forKey: .to)
        let initialFrame = originFrame
        let finalFrame = detailView!.frame
        let xScaleFactor = initialFrame.width/finalFrame.width
        let yScaleFactor = initialFrame.height/finalFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,y: yScaleFactor)
        
        detailView!.transform = scaleTransform
        detailView!.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        detailView!.clipsToBounds = true
        
        containerView.addSubview(detailView!)
        containerView.bringSubview(toFront: detailView!)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            detailView!.transform = CGAffineTransform.identity
            detailView!.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
