//
//  FaqCollectionView.swift
//  App
//
//  Created by George Stavrou on 02/12/2020.
//

import UIKit

public class FaqCollectionView: BaseCollectionView {
    
    public static let cellHeight = CGFloat(70)
    
    public override func registerCell() {
        register(FaqCell.classForCoder(), forCellWithReuseIdentifier: FaqCell.IDENTIFIER)
    }
    
    public func getCell(_ controller: BaseController, _ indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: FaqCell.IDENTIFIER, for: indexPath) as! FaqCell
        cell.setup(controller, model as! FaqModel)
        return cell
    }
    
    public func getCellSize() -> CGSize {
        return CGSize(width: frame.size.width, height: FaqCollectionView.cellHeight)
    }
}
