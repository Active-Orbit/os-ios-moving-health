//
//  SelectSexDialog.swift
//  App
//
//  Created by Omar Brugna on 11/07/23.
//

import UIKit

public class SelectSexDialog : AbstractDialog {
    
    fileprivate var confirmListener: ((String) -> Void)?
    fileprivate var cancelListener: (() -> Void)?
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: BaseLabel!
    @IBOutlet weak var sexCollectionView: SexCollectionView!
    
    public override func getXibName() -> String {
        return ("SelectSexDialog")
    }
    
    override public func onViewPrepared() {
        super.onViewPrepared()
        dialogView.disableTouches()
        dialogView.cornerRadius = DimensionProvider.DIALOG_RADIUS
        
        titleLabel.text = StringProvider.get("select_sex")
        
        sexCollectionView.delegate = self
        sexCollectionView.dataSource = self
        sexCollectionView.flowLayout?.minimumLineSpacing = 0
        sexCollectionView.flowLayout?.minimumInteritemSpacing = 0
        sexCollectionView.refresh()
    }
    
    public func setConfirmListener(_ listener: @escaping ((String) -> Void)) {
        confirmListener = listener
    }
    
    public func setCancelListener(_ listener: @escaping (() -> Void)) {
        cancelListener = listener
    }
}

extension SelectSexDialog: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sexCollectionView.getItemCount()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sexCollectionView.getCell(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let model = sexCollectionView.models[indexPath.row] as! SexModel
        confirmListener?(model.sex)
        hide()
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension SelectSexDialog: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sexCollectionView.getCellSize()
    }
}
