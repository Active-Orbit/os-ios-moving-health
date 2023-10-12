//
//  ButtonComponent.swift
//  App
//
//  Created by Omar Brugna on 05/07/2023.
//

import UIKit

public class ButtonComponent: BaseComponent {
    
    @IBOutlet weak var mainView: BaseView!
    @IBOutlet weak var label: BaseLabel!
    @IBOutlet weak var container: BaseView!
    @IBOutlet weak var icon: BaseImageView!
    @IBOutlet weak var progress: BaseImageView!
    
    public override func onViewPrepared() {
        super.onViewPrepared()
        
        mainView.borderWidth = 1
        mainView.borderColor = ColorProvider.get("colorPrimary")
        mainView.cornerRadius = 8
        
        container.cornerRadius = 8
    }
    
    public override func getXibName() -> String {
        return "ButtonComponent"
    }
    
    public func setText(_ text: String?) {
        label.text = text
    }
    
    public func setIcon(_ image: UIImage?) {
        icon.image = image
    }
    
    public func showProgress() {
        icon.visibility = .invisible
        progress.visibility = .visible
        progress.rotateWithDuration(DurationProvider.ANIMATION, indeterminate: true)
    }
    
    public func hideProgress() {
        icon.visibility = .visible
        progress.visibility = .invisible
    }
}
