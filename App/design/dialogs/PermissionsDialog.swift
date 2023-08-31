//
//  PermissionsDialog.swift
//  App
//
//  Created by George Stavrou on 08/08/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

public class PermissionsDialog : AbstractDialog {
    
    fileprivate var permissionListener: (() -> Void)?
    fileprivate var cancelListener: (() -> Void)?
    
    @IBOutlet var dialogView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var title: BaseLabel!
    @IBOutlet var dialogDescription: BaseLabel!
    @IBOutlet var cancelBtn: BaseButton!
    @IBOutlet var permissionBtn: BaseButton!
    
    
    public override func getXibName() -> String {
        return ("PermissionsDialog")
    }
    
    override public func onViewPrepared() {
        super.onViewPrepared()
        dialogView.disableTouches()
        dialogView.cornerRadius = DimensionProvider.DIALOG_RADIUS
        
    }
    
    public func setup(_ controller: BaseController, _ requestCode: Int) {
        
        cancelBtn.setOnClickListener {
            self.cancelListener?()
            self.hide()
        }
        
        permissionBtn.setOnClickListener {
            self.permissionListener?()
            self.hide()
        }
        
        switch requestCode {
        case Permissions.Group.ACCESS_LOCATION_WHEN_IN_USE.requestCode:
            title.text = StringProvider.get("location_services")
            dialogDescription.text = StringProvider.get("permissions_location_dialog_title")
        case Permissions.Group.ACCESS_LOCATION_ALWAYS.requestCode:
            title.text = StringProvider.get("location_services")
            dialogDescription.text = StringProvider.get("permissions_location_dialog_title")
        case Permissions.Group.ACCESS_MOTION.requestCode:
            title.text = StringProvider.get("permission_dialog_title")
            dialogDescription.text = StringProvider.get("permissions_activity_recognition_dialog_title")
            
        default:
            title.text = StringProvider.get("permission_dialog_title")
            dialogDescription.text = StringProvider.get("permission_dialog_title")

        }
    }
    
    public func setPermissionListener(_ listener: @escaping (() -> Void)) {
        permissionListener = listener
    }
    
    public func setCancelListener(_ listener: @escaping (() -> Void)) {
        cancelListener = listener
    }
}
