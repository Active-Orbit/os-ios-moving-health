//
//  BaseCollectionListener.swift
//  BaseApp
//
//  Created by Omar Brugna on 11/06/2020.
//

import UIKit

public protocol BaseCollectionListener: NSObjectProtocol {
    
    func onLongPress(collectionView: BaseCollectionView, indexPath: IndexPath)
}
