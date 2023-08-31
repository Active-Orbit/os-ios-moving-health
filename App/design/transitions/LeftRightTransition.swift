//
//  LeftRightTransition.swift
//  App
//
//  Created by Omar Brugna on 04/11/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

public class LeftRightTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var isPresenting = true
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.CONTROLLER_TRANSITION_DURATION
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        // get controllers views
        let toView = toViewController.view
        let fromView = fromViewController.view
        
        if fromView != nil && toView != nil {
            if isPresenting {
                toView!.transform = CGAffineTransform(translationX: toView!.bounds.width, y: 0)
            } else {
                toView!.alpha = 0
            }
            
            containerView.addSubview(toView!)
            
            // animate
            let duration = transitionDuration(using: transitionContext)
            UIView.animateKeyframes(
                withDuration: duration,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                        if self.isPresenting {
                            // move the presenting view in
                            toView!.transform = CGAffineTransform(translationX: 0, y: 0)
                            fromView!.alpha = 1
                        } else {
                            // move the dismissing view out
                            fromView!.transform = CGAffineTransform(translationX: fromView!.bounds.width, y: 0)
                            toView!.alpha = 1
                        }
                    })
                },
                completion: { _ in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
        } else {
            Logger.e("Transitions views are nil")
        }
    }
}


