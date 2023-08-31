//
//  HealthCollectionView.swift
//  App
//
//  Created by George Stavrou on 26/07/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

public class HealthCollectionView: BaseCollectionView {
    
    public static let cellHeight = CGFloat(116)

    public override func registerCell() {
        register(HealthCell.classForCoder(), forCellWithReuseIdentifier: HealthCell.IDENTIFIER)
    }
    
    public override func dataSource() -> [TrackerProtocol] {
        return TableHealth.getAll()
    }
    
    public func getCell(_ controller: BaseController, _ indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: HealthCell.IDENTIFIER, for: indexPath) as! HealthCell
        cell.setup(controller, model as! DBHealth)
        return cell
    }
    
    public func getCellSize() -> CGSize {
        return CGSize(width: frame.size.width, height: HealthCollectionView.cellHeight)
    }
}
