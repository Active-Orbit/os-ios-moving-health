//
//  BaseController.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

import UIKit

open class BaseController : PermissionsController {
    
    public var controllerBoundle = Boundle()
    
    public var requestCode = Constants.INVALID
    public var resultListener: ControllerResult?
    
    fileprivate var progressView: UIView!
    fileprivate var progressViewAutoClose = false
    fileprivate var isProgressViewVisible = false
    
    // transitions
    public var controllerTransition = ControllerTransition.DEFAULT
    fileprivate var fadeTransition: FadeTransition!
    fileprivate var leftRightTransition: LeftRightTransition!
    fileprivate var bottomTopTransition: BottomTopTransition!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        LifecycleHandler.instance.onControllerCreated(self, savedInstanceState: controllerBoundle)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
     
        // set previous controller as navigation delegate to manage transitions correctly
        let count = navigationController?.viewControllers.count ?? 0
        let controller = navigationController!.viewControllers[max(count - 2, 0)]
        navigationController?.delegate = controller as? UINavigationControllerDelegate
        
        LifecycleHandler.instance.onControllerResumed(self)
        LifecycleHandler.instance.onControllerStarted(self)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        LifecycleHandler.instance.onControllerPaused(self)
        LifecycleHandler.instance.onControllerStopped(self)
    }
    
    open override func onDestroy() {
        LifecycleHandler.instance.onControllerDestroyed(self)
        super.onDestroy()
    }
}

extension BaseController: ControllerResult {
    
    @objc open func onResult(requestCode: Int, resultCode: Int, data: Any?) {
        // override to customize
    }
    
    public func setResult(_ result: Int, _ data: Any? = nil) {
        resultListener?.onResult(requestCode: requestCode, resultCode: result, data: data)
    }
}

extension BaseController {
    
    // MARK: progress dialog methods
    
    public func showProgressView(autoHide: Bool = false) {
        if !isProgressViewVisible {
            isProgressViewVisible = true
            if progressView == nil {
                progressView = UIView(frame: view.bounds)
                progressView.backgroundColor = ColorProvider.get("colorProgress")
                
                let spinner = UIImageView(frame: CGRect(x: 0, y: 0, width: DimensionProvider.PROGRESS_SIZE, height: DimensionProvider.PROGRESS_SIZE))
                spinner.image = ImageProvider.get("ic_progress")
                spinner.center = progressView.center
                spinner.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
                spinner.rotateWithDuration(DurationProvider.ANIMATION, indeterminate: true)
                progressView.addSubview(spinner)
            }
            view.addSubview(progressView)
        }
        
        if autoHide {
            progressViewAutoClose = true
            Utils.delay(2000, runnable: {
                if self.progressViewAutoClose {
                    self.hideProgressView()
                }
            })
        } else {
            progressViewAutoClose = false
        }
    }
    
    public func hideProgressView() {
        progressViewAutoClose = false
        if isProgressViewVisible && progressView != nil {
            progressView.removeFromSuperview()
            progressView = nil
            isProgressViewVisible = false
        }
    }
}

extension BaseController {
    
    //MARK: transitions setup methods
    
    @objc func getTransitionFrame() -> CGRect {
        // override to customize
        return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
    }
    
    public func getFadeTransition(_ isPresenting: Bool) -> FadeTransition {
        if fadeTransition == nil {
            fadeTransition = FadeTransition()
        }
        fadeTransition?.isPresenting = isPresenting
        return fadeTransition
    }
    
    public func getLeftRightTransition(_ isPresenting: Bool) -> LeftRightTransition {
        if leftRightTransition == nil {
            leftRightTransition = LeftRightTransition()
        }
        leftRightTransition?.isPresenting = isPresenting
        return leftRightTransition
    }
    
    public func getBottomTopTransition(_ isPresenting: Bool) -> BottomTopTransition {
        if bottomTopTransition == nil {
            bottomTopTransition = BottomTopTransition()
        }
        bottomTopTransition?.isPresenting = isPresenting
        return bottomTopTransition
    }
}

extension BaseController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
            case .push:
                switch controllerTransition.value {
                    case ControllerTransition.FADE.value: return getFadeTransition(true)
                    case ControllerTransition.LEFT_TO_RIGHT.value: return getLeftRightTransition(true)
                    case ControllerTransition.BOTTOM_TO_TOP.value: return getBottomTopTransition(true)
                    default:
                        Logger.e("Undefined controller transition type")
                        return nil
                }
            case .pop:
                switch controllerTransition.value {
                    case ControllerTransition.FADE.value: return getFadeTransition(false)
                    case ControllerTransition.LEFT_TO_RIGHT.value: return getLeftRightTransition(false)
                    case ControllerTransition.BOTTOM_TO_TOP.value: return getBottomTopTransition(false)
                    default:
                        Logger.e("Undefined controller transition type")
                        return nil
                }
            default:
                break
        }
        return nil
    }
}
