//
//  ActivitiesController.swift
//  App
//
//  Created by Omar Brugna on 01/08/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit

class ActivitiesController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    
    @IBOutlet var activitiesCollectionView: ActivitiesCollectionView!
    @IBOutlet var bottomNavigation: BottomNavigationComponent!
    
    @IBOutlet var noActivities: BaseLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showMenuComponent()
        toolbar.showTitle()
        
        prepare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showActivities()
    }
    
    
    func prepare() {
        
        activitiesCollectionView.delegate = self
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.flowLayout?.minimumLineSpacing = 0
        activitiesCollectionView.flowLayout?.minimumInteritemSpacing = 0
        activitiesCollectionView.refresh()
        
        bottomNavigation.setSelected(BottomNavItemType.TRIPS, self)
    }
    
    private func showActivities() {
        activitiesCollectionView.refresh({ itemCount in
            if itemCount == 0 {
                self.noActivities.visibility = .visible
            } else {
                self.noActivities.visibility = .invisible
            }
            
        })
    }
}

extension ActivitiesController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activitiesCollectionView.getItemCount()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return activitiesCollectionView.getCell(self, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath) as! ActivityCell
        cell.onClick()
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ActivitiesController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return activitiesCollectionView.getCellSize()
    }
}
