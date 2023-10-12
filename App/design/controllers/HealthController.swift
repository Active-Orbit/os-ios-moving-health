//
//  HealthController.swift
//  App
//
//  Created by George Stavrou on 26/07/2023.
//

import UIKit

class HealthController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    
    @IBOutlet var healthCollectionView: HealthCollectionView!
    @IBOutlet var bottomNavigation: BottomNavigationComponent!
    
    @IBOutlet var btnFillQuestionnaire: BaseView!
    @IBOutlet var noHealth: BaseLabel!
    
    static let HEALTH_REQUEST_CODE = 312
    static let HEALTH_RESPONSES_MAX = 20
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showMenuComponent()
        toolbar.showTitle()
        
        prepare()
        setOnClickListeners()
        
        HealthManager.checkForNotUploaded(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showResponses()
    }
    
    
    func prepare() {
        
        btnFillQuestionnaire.rounded()
        
        healthCollectionView.delegate = self
        healthCollectionView.dataSource = self
        healthCollectionView.flowLayout?.minimumLineSpacing = 0
        healthCollectionView.flowLayout?.minimumInteritemSpacing = 0
        healthCollectionView.contentInsetBottom = HealthCollectionView.cellHeight
        healthCollectionView.refresh()
        
        bottomNavigation.setSelected(BottomNavItemType.HEALTH, self)
    }
    
    private func showResponses() {
        healthCollectionView.refresh({ itemCount in
            if itemCount == 0 {
                self.noHealth.visibility = .visible
            } else {
                self.noHealth.visibility = .invisible
            }
            
        })
    }
    
    private func setOnClickListeners() {
        
        btnFillQuestionnaire.setOnClickListener {
            
            if self.healthCollectionView.getItemCount() < HealthController.HEALTH_RESPONSES_MAX {
                Router.instance.controllerTransition(ControllerTransition.LEFT_TO_RIGHT).startBaseControllerForResult(self, Controllers.HEALTH_MOBILITY, Boundle(), HealthController.HEALTH_REQUEST_CODE)
            } else {
                Toast.showLongToast(self.view, StringProvider.get("full_health_list_message"))
            }
        }
    }
    
}

extension HealthController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return healthCollectionView.getItemCount()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return healthCollectionView.getCell(self, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath) as! HealthCell
        cell.onClick()
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension HealthController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return healthCollectionView.getCellSize()
    }
}
