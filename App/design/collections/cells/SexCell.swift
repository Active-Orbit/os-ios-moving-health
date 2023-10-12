//
//  SexCell.swift
//  App
//
//  Created by Omar Brugna on 12/12/2020.
//

import UIKit

class SexCell : BaseCollectionViewCell {
    
    @IBOutlet var sexText: BaseLabel!
    
    public static let IDENTIFIER = "SexCell"
    
    public override func getXibName() -> String {
        return "SexCell"
    }
    
    func setup(_ model: SexModel) {
        sexText.text = model.sex
    }
}
