//
//  TourController.swift
//  BaseApp
//
//  Created by Omar Brugna on 30/06/2023.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import UIKit

class TourController: BaseController {
    
    @IBOutlet var mainView: BaseView!
    @IBOutlet var backBtn: BaseLabel!
    @IBOutlet var nextBtn: BaseLabel!
    @IBOutlet var viewPager: BaseScrollView!
    @IBOutlet var viewPagerIndicator: PagerIndicator!
    @IBOutlet var tourComponent1: TourComponent!
    @IBOutlet var tourComponent2: TourComponent!
    @IBOutlet var tourComponent3: TourComponent!
    @IBOutlet var closeButton: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        prepare()
        Preferences.lifecycle.tourShown = true
    }
    
    fileprivate func prepare() {
        
        viewPagerIndicator.numberOfItems = 3
        
        mainView.cornerRadius = 16
        
        viewPager.delegate = self
        
        tourComponent1.setup(ImageProvider.get("ic_activity"), StringProvider.get("tour_info_one_description"))
        tourComponent2.setup(ImageProvider.get("ic_health"), StringProvider.get("tour_info_two_description"))
        tourComponent3.setup(ImageProvider.get("ic_logo_secondary"), StringProvider.get("tour_info_three_description"))
        
        backBtn.visibility = .invisible
        backBtn.setOnClickListener {
            if self.viewPager.currentPage > 0 {
                self.viewPager.currentPage = self.viewPager.currentPage - 1
            }
        }
        
        nextBtn.setOnClickListener {
            if self.viewPager.currentPage < 2 {
                self.viewPager.currentPage = self.viewPager.currentPage + 1
            }
        }
        
        closeButton.setOnClickListener {
            Router.instance.controllerTransition(ControllerTransition.BOTTOM_TO_TOP).startBaseController(self, Controllers.CONSENT_PRIVACY)
        }
    }
    
    fileprivate func onPageSelected(_ index: Int) {
        viewPagerIndicator.selectItemAtIndex(index)
        if index == 0 {
            backBtn.visibility = .invisible
        } else {
            backBtn.visibility = .visible
        }
        if index == 2 {
            nextBtn.visibility = .invisible
        } else {
            nextBtn.visibility = .visible
        }
    }
}

extension TourController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var offset = scrollView.contentOffset.x
        if offset == 0 {
            onPageSelected(0)
        } else {
            let itemSize = scrollView.bounds.size.width
            offset += itemSize / 1.5
            let visibleItemIndex = Int(offset / itemSize)
            onPageSelected(visibleItemIndex)
        }
    }
}

