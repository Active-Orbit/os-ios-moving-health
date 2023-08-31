//
//  FaqCell.swift
//  App
//
//  Created by George Stavrou on 02/12/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

class FaqCell : BaseCollectionViewCell {
    

    @IBOutlet var faqView: BaseView!
    @IBOutlet var icon: BaseImageView!
    @IBOutlet var iconView: BaseView!
    @IBOutlet var faqText: BaseLabel!
    
    
    private var mPosition = 0
    
    public static let IDENTIFIER = "FaqCell"

    public override func getXibName() -> String {
        return "FaqCell"
    }
    
    func setup(_ controller: BaseController, _ model: FaqModel) {
        
        faqView.cornerRadius = 10
        faqView.borderWidth = 1
        faqView.borderColor = ColorProvider.get("colorPrimary")
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 10
        iconView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        mPosition = model.position
        faqText.text = model.category
        
        clickListener = {
            let boundle = Boundle()
            boundle.putInt(Extra.MODEL_ID.key, model.position)
            Router.instance
                .controllerTransition(ControllerTransition.LEFT_TO_RIGHT)
                .startBaseController(controller, Controllers.FAQ, boundle)
        }
    }
}
