//
//  SegmentsController.swift
//  App
//
//  Created by Omar Brugna on 23/08/23.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit
import Tracker

class SegmentsController: BaseController {
    
    @IBOutlet weak var toolbar: Toolbar!
    
    @IBOutlet weak var viewPager: BaseScrollView!
    
    @IBOutlet weak var segmentsContainer: UIView!
    @IBOutlet weak var segmentsCollectionView: SegmentsCollectionView!
    @IBOutlet weak var noSegmentsContainer: BaseView!
    
    @IBOutlet weak var debugContainer: UIView!
    @IBOutlet weak var debugCollectionView: DebugCollectionView!
    @IBOutlet weak var noDebugContainer: BaseView!
    
    @IBOutlet weak var toggleButton: BaseView!
    @IBOutlet weak var uploadButton: BaseView!
    @IBOutlet weak var selectDateButton: BaseView!
    @IBOutlet weak var selectDateButtonImage: BaseImageView!
    
    fileprivate var fromDate = TimeUtils.startOfDay()
    fileprivate var toDate = TimeUtils.endOfDay()
    
    fileprivate var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.setup(self)
        toolbar.showBackButton()
        toolbar.showTitle()
        toolbar.hideLogo()
        toolbar.hideMenuComponent()
        toolbar.setBackgroundColor(ColorProvider.get("colorBackground"))
        
        prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    fileprivate func prepare() {
        
        segmentsCollectionView.delegate = self
        segmentsCollectionView.dataSource = self
        segmentsCollectionView.flowLayout?.minimumLineSpacing = 0
        segmentsCollectionView.flowLayout?.minimumInteritemSpacing = 0
        
        debugCollectionView.delegate = self
        debugCollectionView.dataSource = self
        debugCollectionView.flowLayout?.minimumLineSpacing = 0
        debugCollectionView.flowLayout?.minimumInteritemSpacing = 0
        
        toggleButton.rounded()
        toggleButton.setOnClickListener {
            switch self.viewPager.currentPage {
                case 0: self.viewPager.currentPage = 1
                case 1: self.viewPager.currentPage = 0
                default: break
            }
        }
        
        uploadButton.rounded()
        uploadButton.setOnClickListener {
            self.confirmDataUpload()
        }
        
        selectDateButton.rounded()
        selectDateButton.setOnClickListener {
            self.showPicker()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.datePicker?.center = self.view.center
    }
    
    fileprivate func showPicker() {
        let calendar = Calendar.current
        
        self.datePicker = UIDatePicker()
        self.datePicker!.frame = CGRect(x: 0.0, y: self.view.bounds.size.height - 300, width: self.view.bounds.size.width, height: 300)
        self.datePicker!.center = self.view.center
        self.datePicker!.calendar = calendar
        self.datePicker!.datePickerMode = .date
        self.datePicker!.minimumDate = TimeUtils.startOfDay(Preferences.lifecycle.firstComputation)
        self.datePicker!.maximumDate = TimeUtils.getUTC()
        self.datePicker!.date = self.fromDate
        if #available(iOS 13.4, *) {
            datePicker?.preferredDatePickerStyle = .wheels
        }
        self.view.addSubview(self.datePicker!)
        
        self.noSegmentsContainer.visibility = .invisible
        self.segmentsCollectionView.visibility = .invisible
        
        self.noDebugContainer.visibility = .invisible
        self.debugCollectionView.visibility = .invisible
        
        self.toggleButton.visibility = .invisible
        self.uploadButton.visibility = .invisible
        
        self.selectDateButtonImage.image = ImageProvider.get("success_icon")
        self.selectDateButton.setOnClickListener {
            let pickerDate = self.datePicker!.date
            self.fromDate = TimeUtils.startOfDay(pickerDate)
            self.toDate = TimeUtils.endOfDay(pickerDate)
            self.refresh()
            
            self.hidePicker()
        }
    }
    
    fileprivate func hidePicker() {
        segmentsCollectionView.visibility = .visible
        debugCollectionView.visibility = .visible
        
        self.toggleButton.visibility = .visible
        self.uploadButton.visibility = .visible
        
        datePicker?.visibility = .invisible
        datePicker = nil
        
        selectDateButtonImage.image = ImageProvider.get("ic_summary")
        selectDateButton.setOnClickListener {
            self.showPicker()
        }
    }
    
    fileprivate func refresh() {
        
        showProgressView()
        
        let toolbarTitle = TimeUtils.format(fromDate, Constants.DATE_FORMAT_DAY_MONTH_YEAR, convertToDefault: true)
        toolbar.setTitle(toolbarTitle)
        
        // analyse from initial date
        TrackerManager.instance.refresh(fromDate, toDate, {
            self.segmentsCollectionView.fromDate = self.fromDate
            self.segmentsCollectionView.toDate = self.toDate
            self.debugCollectionView.fromDate = self.fromDate
            self.debugCollectionView.toDate = self.toDate
            
            self.segmentsCollectionView.refresh({ itemCount in
                if itemCount == 0 { self.noSegmentsContainer.visibility = .visible }
                else { self.noSegmentsContainer.visibility = .invisible }
                
                self.segmentsCollectionView.scrollToTop()
                self.hideProgressView()
            })
            
            self.debugCollectionView.refresh({ itemCount in
                if itemCount == 0 { self.noDebugContainer.visibility = .visible }
                else { self.noDebugContainer.visibility = .invisible }
                
                self.debugCollectionView.scrollToTop()
                self.hideProgressView()
            })
        })
    }
}

extension SegmentsController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case segmentsCollectionView:
                return segmentsCollectionView.getItemCount()
            case debugCollectionView:
                return debugCollectionView.getItemCount()
            default:
                Logger.e("Undefined collection view on \(className)")
                return 0
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case segmentsCollectionView:
                return segmentsCollectionView.getCell(self, indexPath)
            case debugCollectionView:
                return debugCollectionView.getCell(self, indexPath)
            default:
                Logger.e("Undefined collection view on \(className)")
                return UICollectionViewCell()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch collectionView {
            case segmentsCollectionView:
                let model = segmentsCollectionView.models[indexPath.row]
                if model is TrackerDBSegment {
                    let cell = collectionView.cellForItem(at: indexPath) as! SegmentCell
                    cell.onClick()
                } else {
                    Logger.e("Clicked model is not an instance of TrackerDBSegment on \(className)")
                }
            case debugCollectionView:
                let model = debugCollectionView.models[indexPath.row]
                if model is TrackerDBActivity {
                    let cell = collectionView.cellForItem(at: indexPath) as! DebugCell
                    cell.onClick()
                } else {
                    Logger.e("Clicked model is not an instance of TrackerDBActivity on \(className)")
                }
            default:
                Logger.e("Undefined collection view on \(className)")
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension SegmentsController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case segmentsCollectionView:
                return segmentsCollectionView.getCellSize()
            case debugCollectionView:
                return debugCollectionView.getCellSize()
            default:
                Logger.e("Undefined collection view on \(className)")
                return .zero
        }
    }
}

extension SegmentsController {
    
    fileprivate func confirmDataUpload() {
        let dialog = UploadDataConfirmDialog()
        dialog.setCancelable(false)
        dialog.setup(self, fromDate)
        dialog.setConfirmButtonListener {
            self.uploadData()
        }
        dialog.show()
    }
    
    fileprivate func uploadData() {
        showProgressView()
        
        var segments = TrackerTableSegments.getBetween(fromDate, toDate)
        for segment in segments {
            segment.addSteps()
            segment.addBrisk()
        }
        segments.sort(by: {
            return $1.startDate == nil || $0.startDate?.before($1.startDate!) == true
        })
        
        var activities = TrackerTableActivities.getBetween(fromDate, toDate)
        activities.sort(by: {
            return $1.startDate == nil || $0.startDate?.before($1.startDate!) == true
        })
        
        let uploadRequest = UploadRequest()
        uploadRequest.customerId = Preferences.user.idUser ?? Constants.EMPTY
        uploadRequest.customerName = Preferences.user.userFullName()
        uploadRequest.customerGroup = Preferences.user.idUser ?? Constants.EMPTY
        
        for segment in segments {
            let segmentRequest = UploadSegmentRequest(segment)
            uploadRequest.segments.append(segmentRequest)
        }
        
        for activity in activities {
            let activityRequest = UploadActivityRequest(activity)
            uploadRequest.activities.append(activityRequest)
        }
        
        let stagingApi = "https://staging.triptattoos.com/router?api=upload"
        
        let webService = WebService<UploadRequest>(stagingApi)
        webService.method = .post
        webService.params = uploadRequest
        
        Connection(webService, { tag, connectionResult, response in
            switch connectionResult {
                case .SUCCESS:
                    if !TextUtils.isEmpty(response) {
                        let map: UploadDataMap? = Gson.toObject(response!)
                        if map?.isValid() == true {
                            Toast.showLongToast(self.view, "Data uploaded correctly")
                        } else {
                            Toast.showLongToast(self.view, "Error uploading data")
                        }
                    } else {
                        Toast.showLongToast(self.view, "Error uploading data")
                    }
                case .ERROR:
                    Toast.showLongToast(self.view, "Error uploading data")
                case .COMPLETED:
                    self.hideProgressView()
                default:
                    break
            }
        }).connect()
    }
}

