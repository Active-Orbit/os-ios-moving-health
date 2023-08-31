//
//  ActivitiesCollectionView.swift
//  App
//
//  Created by Omar Brugna on 01/08/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

public class ActivitiesCollectionView: BaseCollectionView {
    
    public static let cellHeight = CGFloat(130)
    
    public var fromDate = Singleton.startDate
    public var toDate = Singleton.endDate

    public override func registerCell() {
        register(ActivityCell.classForCoder(), forCellWithReuseIdentifier: ActivityCell.IDENTIFIER)
    }
    
    public override func dataSource() -> [TrackerProtocol] {
        var models = TrackerTableSegments.getBetween(fromDate, toDate)
        for model in models {
            model.addSteps()
            model.addBrisk()
            model.addLocations()
        }
        models.sort(by: {
            return $1.startDate == nil || $0.startDate?.before($1.startDate!) == true
        })
        return models
    }
    
    public func getCell(_ controller: BaseController, _ indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: ActivityCell.IDENTIFIER, for: indexPath) as! ActivityCell
        cell.setup(controller, model as! TrackerDBSegment, models as! [TrackerDBSegment], indexPath.row)
        return cell
    }
    
    public func getCellSize() -> CGSize {
        return CGSize(width: frame.size.width, height: HealthCollectionView.cellHeight)
    }
}
