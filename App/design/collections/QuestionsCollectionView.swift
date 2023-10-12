//
//  QuestionsCollectionView.swift
//  App
//
//  Created by Omar Brugna on 24/07/2023.
//

import UIKit
import Tracker

public class QuestionsCollectionView: BaseCollectionView {
    
    public var allAccepted = false
    
    public override func registerCell() {
        register(QuestionCell.classForCoder(), forCellWithReuseIdentifier: QuestionCell.IDENTIFIER)
    }
    
    public override func dataSource() -> [TrackerProtocol] {
        let models = TableConsentQuestions.getAll()
        if allAccepted {
            models.forEach({ $0.checked = true })
        }
        return models
    }
    
    public func getCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: QuestionCell.IDENTIFIER, for: indexPath) as! QuestionCell
        cell.setup(model as! DBConsentQuestion, allAccepted)
        return cell
    }
    
    public func getCellSize(_ model: DBConsentQuestion) -> CGSize {
        var height: CGFloat = 0
        height += 10 // top space
        height += 10 // bottom space
        if !TextUtils.isEmpty(model.questionText) {
            var textWidth = UIScreen.main.bounds.size.width
            textWidth -= 20 // leading root
            textWidth -= 20 // trailing root
            textWidth -= 48 // checkbox container
            textWidth -= 16 // leading label
            textWidth -= 16 // trailing label
            height += model.questionText!.estimatedHeight(textWidth, UIFont(name: FontProvider.REGULAR.name, size: TextSizeProvider.H5.size)!) // text
        }
        return CGSize(width: frame.size.width, height: max(height, 48))
    }
    
    public func allQuestionsAccepted() -> Bool {
        var accepted = true
        models.forEach({
            if ($0 as? DBConsentQuestion)?.checked != true {
                accepted = false
                return
            }
        })
        return accepted
    }
}
