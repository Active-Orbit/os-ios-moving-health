//
//  QuestionCell.swift
//  App
//
//  Created by Omar Brugna on 24/07/2023.
//

import UIKit

public class QuestionCell: BaseCollectionViewCell {
    
    @IBOutlet weak var mainView: BaseView!
    @IBOutlet weak var label: BaseLabel!
    @IBOutlet weak var container: BaseView!
    @IBOutlet weak var checkBox: BaseCheckBox!
    
    public static let IDENTIFIER = "QuestionCell"
    
    public override func getXibName() -> String {
        return "QuestionCell"
    }
    
    public func setup(_ model: DBConsentQuestion, _ allAccepted: Bool) {
        label.text = model.questionText
        
        checkBox.isChecked = model.checked
    }
}
