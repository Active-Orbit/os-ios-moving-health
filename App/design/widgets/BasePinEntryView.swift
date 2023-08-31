//
//  BasePinEntryView.swift
//  App
//
//  Created by Omar Brugna on 06/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit
import CBPinEntryView

public extension CBPinEntryView {
    
    func setPin(_ text: String) {
        if let innerTextField = (self.subviews.compactMap { $0 as? UITextField }).first {
            self.clearEntry()
            text.forEach {
                _ = textField(innerTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: String($0))
                innerTextField.insertText(String($0))
            }
        }
    }
    
    func disableEntries() {
        self.subviews.forEach({ subview in
            (subview as? UITextField)?.isUserInteractionEnabled = false
        })
    }
    
    func clear() {
        setPin(Constants.EMPTY)
    }
}
