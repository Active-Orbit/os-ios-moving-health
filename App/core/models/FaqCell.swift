//
//  FaqCell.swift
//  App
//
//  Created by George Stavrou on 02/12/2020.
//  Copyright © 2020 Aeqora. All rights reserved.
//

import UIKit

class FaqCell : BaseCollectionViewCell {
    
    @IBOutlet var faqView: BaseView!
    @IBOutlet weak var faqText: BaseLabel!
    @IBOutlet weak var faqIcon: BaseImageView!
    
    
    private var mPosition = 0
    
    public static let IDENTIFIER = "FaqCell"

    public override func getXibName() -> String {
        return "FaqCell"
    }
    
    func setup(_ controller: BaseController, _ model: FaqModel) {
        mPosition = model.position ?? 0
        faqText.text = model.text
        
        clickListener = {
            let path = FaqProvider.instance
            path.itemSelected(self.mPosition)
            path.nextLevel()
            Router.instance
                .controllerTransition(ControllerTransition.LEFT_TO_RIGHT)
                .startBaseController(controller, Controllers.FAQ)
        }
    }
}
