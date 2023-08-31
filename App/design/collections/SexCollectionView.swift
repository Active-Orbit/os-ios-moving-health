//
//  SexCollectionView.swift
//  App
//
//  Created by Omar Brugna on 12/07/2023.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

public class SexCollectionView: BaseCollectionView {
    
    public static let cellHeight = CGFloat(58)
    
    public override func registerCell() {
        register(SexCell.classForCoder(), forCellWithReuseIdentifier: SexCell.IDENTIFIER)
    }
    
    public override func dataSource() -> [TrackerProtocol] {
        let male = SexModel("Male")
        let female = SexModel("Female")
        return [male, female]
    }
    
    public func getCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: SexCell.IDENTIFIER, for: indexPath) as! SexCell
        cell.setup(model as! SexModel)
        return cell
    }
    
    public func getCellSize() -> CGSize {
        return CGSize(width: frame.size.width, height: SexCollectionView.cellHeight)
    }
}
