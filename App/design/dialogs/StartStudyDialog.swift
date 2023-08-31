//
//  StartStudyDialog.swift
//  App
//
//  Created by Omar Brugna on 17/07/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class StartStudyDialog : AbstractDialog {
    
    fileprivate var confirmListener: (() -> Void)?
    fileprivate var cancelListener: (() -> Void)?
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: BaseLabel!
    @IBOutlet weak var cancelBtn: BaseButton!
    @IBOutlet weak var confirmBtn: BaseButton!
    
    public override func getXibName() -> String {
        return ("StartStudyDialog")
    }
    
    override public func onViewPrepared() {
        super.onViewPrepared()
        dialogView.disableTouches()
        dialogView.cornerRadius = DimensionProvider.DIALOG_RADIUS
        
        cancelBtn.setOnClickListener {
            self.cancelListener?()
            self.hide()
        }
        
        confirmBtn.setOnClickListener {
            self.confirmListener?()
            self.hide()
        }
    }
    
    public func setConfirmListener(_ listener: @escaping (() -> Void)) {
        confirmListener = listener
    }
    
    public func setCancelListener(_ listener: @escaping (() -> Void)) {
        cancelListener = listener
    }
}
