//
//  BaseImageView.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import Kingfisher

public class BaseImageView: UIImageView {
    
    fileprivate var isClickable = false
    fileprivate var clickListener: (() -> Void)?
    
    var feedbackOnClick = true
    
    @IBInspectable public var clickable: Bool {
        set {
            isClickable = newValue
            isUserInteractionEnabled = isClickable
        }
        get {
            return isClickable
        }
    }
    
    @IBInspectable public var localizedImage: String {
        set {
            image = ImageProvider.get(newValue)
        }
        get {
            return Constants.EMPTY
        }
    }
    
    public override func setOnClickListener(target: Any?, listener: Selector?, cancelsTouchesInView: Bool = true) {
        super.setOnClickListener(target: target, listener: listener)
        clickable = listener != nil
    }
    
    public func setOnClickListener(_ listener: @escaping (() -> Void)) {
        clickListener = listener
        setOnClickListener(target: self, listener: #selector(onClick))
    }
    
    @objc fileprivate func onClick() {
        clickListener?()
    }
    
    public override func disableTouches() {
        super.disableTouches()
        clickable = false
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isClickable {
            setPressed(true)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isClickable {
            setPressed(false)
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches!, with: event)
        if isClickable {
            setPressed(false)
        }
    }
    
    fileprivate func setPressed(_ pressed: Bool) {
        if feedbackOnClick {
            if pressed {
                alpha = Constants.ALPHA_PRESSED
            } else {
                alpha = Constants.ALPHA_ENABLED
            }
        }
    }
    
    public func setImageRound(_ image: UIImage?) {
        self.image = image
        rounded()
    }
    
    public func setImageUrl(_ url: String, _ fallbackImage: UIImage? = nil) {
        kf.setImage(with: URL(string: url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { result in
            switch result {
                case .success(let value):
                    self.image = value.image
                case .failure(let error):
                    Logger.e("Error loading image from url \(url) - \(error.localizedDescription)")
                    self.image = fallbackImage
            }
        })
    }
}
