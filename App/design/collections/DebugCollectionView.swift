//
//  DebugCollectionView.swift
//  App
//
//  Created by Omar Brugna on 23/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

public class DebugCollectionView: BaseCollectionView {
    
    public static let cellHeight = CGFloat(80)
    
    var fromDate = Singleton.startDate
    var toDate = Singleton.endDate
    
    public override func dataSource() -> [TrackerProtocol] {
        var models = TrackerTableActivities.getBetween(fromDate, toDate)
        models.sort(by: {
            return $1.startDate == nil || $0.startDate?.before($1.startDate!) == true
        })
        return models
    }
    
    public override func registerCell() {
        register(DebugCell.classForCoder(), forCellWithReuseIdentifier: DebugCell.IDENTIFIER)
    }
    
    public func getCell(_ controller: BaseController, _ indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: DebugCell.IDENTIFIER, for: indexPath) as! DebugCell
        cell.setup(controller, model as! TrackerDBActivity)
        return cell
    }
    
    public func getCellSize() -> CGSize {
        return CGSize(width: frame.size.width, height: DebugCollectionView.cellHeight)
    }
}
