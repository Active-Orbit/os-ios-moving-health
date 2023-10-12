//
//  Toast.swift
//  App
//
//  Created by Omar Brugna on 04/11/2020.
//

import UIKit
import Toast_Swift

public class Toast {
    
    public static func showShortToast(_ view: UIView, _ message: String) {
        showToast(view, message, 1.0)
    }
    
    public static func showLongToast(_ view: UIView, _ message: String) {
        showToast(view, message, 3.0)
    }
    
    fileprivate static func showToast(_ view: UIView, _ message: String, _ duration: TimeInterval) {
        var style = ToastStyle()
        style.messageColor = ColorProvider.get("textColorPrimaryDark") ?? .black
        style.backgroundColor = ColorProvider.get("toastBackground") ?? .white
        style.cornerRadius = 20
        style.horizontalPadding = 15
        style.verticalPadding = 15
        let center = CGPoint(x: view.center.x, y: view.bounds.size.height - 150)
        view.makeToast(message, duration: duration, point: center, title: nil, image: nil, style: style, completion: nil)
    }
}
