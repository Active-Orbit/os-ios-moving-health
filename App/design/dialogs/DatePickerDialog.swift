//
//  DatePickerDialog.swift
//  App
//
//  Created by Omar Brugna on 11/07/23.
//

import UIKit

public class DatePickerDialog : AbstractDialog {
    
    fileprivate var confirmListener: ((Date) -> Void)?
    fileprivate var cancelListener: (() -> Void)?
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: BaseLabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelBtn: BaseButton!
    @IBOutlet weak var confirmBtn: BaseButton!
    
    public override func getXibName() -> String {
        return ("DatePickerDialog")
    }
    
    override public func onViewPrepared() {
        super.onViewPrepared()
        dialogView.disableTouches()
        dialogView.cornerRadius = DimensionProvider.DIALOG_RADIUS
        
        titleLabel.text = StringProvider.get("select_birthday")
        
        datePicker.datePickerMode = .date
        
        cancelBtn.setOnClickListener {
            self.cancelListener?()
            self.hide()
        }
        
        confirmBtn.setOnClickListener {
            self.confirmListener?(self.datePicker.date.toCurrent())
            self.hide()
        }
    }
    
    public func setDate(date: Date) {
        datePicker.date = date.toUTC() // picker works with utc timezone
    }
    
    public func setMinimumDate(date: Date?) {
        datePicker.minimumDate = date?.toUTC() // picker works with utc timezone
    }
    
    public func setMaximumDate(date: Date?) {
        datePicker.maximumDate = date?.toUTC() // picker works with utc timezone
    }
    
    public func setConfirmListener(_ listener: @escaping ((Date) -> Void)) {
        confirmListener = listener
    }
    
    public func setCancelListener(_ listener: @escaping (() -> Void)) {
        cancelListener = listener
    }
}
