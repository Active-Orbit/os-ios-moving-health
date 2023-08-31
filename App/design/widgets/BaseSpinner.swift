//
//  BaseSpinner.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

public class BaseSpinner: BaseView {
    
    @IBOutlet var spinnerView: UIView!
    @IBOutlet weak var spinnerLabel: BaseLabel!
    @IBOutlet weak var spinnerIcon: BaseImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    fileprivate func prepare() {
        loadXib(name: "BaseSpinner")
        cornerRadius = DimensionProvider.SPINNER_RADIUS
        borderWidth = DimensionProvider.BUTTON_STROKE
    }
    
    public func setText(_ text: String) {
        spinnerLabel.text = text
    }
    
    public func setBackgroundColor(_ color: UIColor?) {
        spinnerView.backgroundColor = color
    }
    
    public func setTextColor(_ color: UIColor?) {
        spinnerLabel.textColor = color
    }
}
