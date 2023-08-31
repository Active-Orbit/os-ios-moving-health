//
//  UploadDataConfirmDialog.swift
//  App
//
//  Created by Omar Brugna on 23/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class UploadDataConfirmDialog: AbstractDialog {
    
    fileprivate var onCancelListener: (() -> Void)?
    fileprivate var onConfirmListener: (() -> Void)?
    
    @IBOutlet weak var dialogContainer: BaseView!
    @IBOutlet weak var cancelButton: BaseButton!
    @IBOutlet weak var confirmButton: BaseButton!
    @IBOutlet weak var title: BaseLabel!
    
    public override func getXibName() -> String {
        return ("UploadDataConfirmDialog")
    }
    
    override public func onViewPrepared() {
        super.onViewPrepared()
        
        prepare()
    }
    
    private func prepare() {
        dialogContainer.corners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        dialogContainer.cornerRadius = DimensionProvider.DIALOG_RADIUS
    }
    
    public func setup(_ controller: BaseController, _ calendar: Date) {
        
        cancelButton.setOnClickListener {
            self.onCancelListener?()
            self.hide()
        }
        
        confirmButton.setOnClickListener {
            self.onConfirmListener?()
            self.hide()
        }
        
        title.text = "Confirm data upload for \(TimeUtils.format(calendar, Constants.DATE_FORMAT_DAY_MONTH_YEAR, convertToDefault: true))"
    }
    
    public func setConfirmButtonListener(_ listener: @escaping (() -> Void)) {
        onConfirmListener = listener
    }
    
    public func setCancelButtonListener(_ listener: @escaping (() -> Void)) {
        onCancelListener = listener
    }
}
