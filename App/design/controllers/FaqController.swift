//
//  FaqController.swift
//  App
//
//  Created by George Stavrou on 02/12/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

class FaqController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet weak var container: BaseView!
    
    @IBOutlet weak var questionView: BaseView!
    @IBOutlet weak var question: BaseLabel!
    @IBOutlet weak var faqCollectionView: FaqCollectionView!
    @IBOutlet var answerView: BaseView!
    @IBOutlet weak var answerLabel: BaseLabel!
    
    public var faqModel: FaqModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        answerView.cornerRadius = 10
        
        let modelId = controllerBoundle.getInt(Extra.MODEL_ID.key)
        if modelId != Constants.INVALID {
            faqModel = FaqProvider.instance.getById(modelId)
            if faqModel!.hasSubCategories() {
                setFaqTitle(faqModel!.category)
            }
        } else {
            faqModel = FaqProvider.instance.faqs.first
        }
        
        prepare()
    }
    
    fileprivate func prepare() {
        if faqModel!.hasSubCategories() {
            faqCollectionView.delegate = self
            faqCollectionView.dataSource = self
            faqCollectionView.flowLayout?.minimumLineSpacing = 0
            faqCollectionView.flowLayout?.minimumInteritemSpacing = 0

            faqCollectionView.replaceAll(faqModel!.subCategories)
            hideResponse()
        } else if faqCollectionView != nil {
            showResponse()
        }
    }
    
    fileprivate func hideResponse() {
        if faqCollectionView != nil {
            faqCollectionView.isHidden = false
        }
        answerView.isHidden = true
        answerLabel.isHidden = true
    }
    
    
    fileprivate func showResponse() {
        if faqCollectionView != nil {
            faqCollectionView.isHidden = true
        }
        answerView.isHidden = false
        answerLabel.isHidden = false
        answerLabel.text = faqModel!.response!.answer
        setFaqTitle(faqModel!.response!.question)
    }
    
    private func setFaqTitle(_ title: String) {
        questionView.isHidden = false
        question.isHidden = false
        question.text = title
    }
}

extension FaqController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return faqCollectionView.getItemCount()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return faqCollectionView.getCell(self, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath) as! FaqCell
        cell.onClick()
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension FaqController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return faqCollectionView.getCellSize()
    }
}
