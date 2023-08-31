//
//  MapController.swift
//  App
//
//  Created by Omar Brugna on 02/08/2023.
//  Copyright © 2023 Active Orbit. All rights reserved.
//

import UIKit
import DGCharts
import GoogleMaps
import Tracker

class MapController: BaseController {
    
    @IBOutlet var toolbar: Toolbar!
    @IBOutlet var activityCell: ActivityCell!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var arrowLeft: BaseView!
    @IBOutlet var arrowRight: BaseView!
    @IBOutlet var chart: LineChartView!
    @IBOutlet var noChart: BaseLabel!
    
    fileprivate var models: [TrackerDBSegment]!
    
    fileprivate var currentModel: TrackerDBSegment!
    fileprivate var currentPosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        
        toolbar.setup(self)
        toolbar.showBackButton()
        
        models = controllerBoundle.get(Extra.MODELS.key) as? [TrackerDBSegment]
        currentPosition = controllerBoundle.getInt(Extra.POSITION.key, 0)
        currentModel = models[currentPosition]
        
        prepare()
        update()
    }
    
    fileprivate func prepare() {
        
        arrowLeft.rounded()
        arrowRight.rounded()
        
        arrowLeft.setOnClickListener {
            self.currentPosition -= 1
            self.currentModel = self.models[self.currentPosition]
            self.update()
        }
        
        arrowRight.setOnClickListener {
            self.currentPosition += 1
            self.currentModel = self.models[self.currentPosition]
            self.update()
        }
    }
    
    fileprivate func update() {
        if models.count <= 1 {
            arrowLeft.visibility = .invisible
            arrowRight.visibility = .invisible
        } else {
            if currentPosition == 0 {
                arrowLeft.visibility = .invisible
                arrowRight.visibility = .visible
            } else if currentPosition == models.count - 1 {
                arrowLeft.visibility = .visible
                arrowRight.visibility = .invisible
            } else {
                arrowLeft.visibility = .visible
                arrowRight.visibility = .visible
            }
        }
        
        activityCell.setup(self, currentModel, models, 0)
        
        showMap()
        showChart()
    }
    
    fileprivate func showMap() {
        mapView.clear()
        
        if !currentModel.locations.isEmpty {
            let sortedLocations = currentModel.locations.sorted(by: { $0.date?.timeInMillis ?? 0 < $1.date?.timeInMillis ?? 0 })
            let path = GMSMutablePath()
            var index = 0
            for location in sortedLocations {
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                if index == 0 || index == sortedLocations.count - 1 {
                    let marker = GMSMarker()
                    marker.position = coordinate
                    marker.map = mapView
                    marker.isDraggable = false
                }
                if sortedLocations.count > 1 {
                    path.add(coordinate)
                }
                index += 1
            }
            let line = GMSPolyline(path: path)
            line.strokeColor = UIColor.blue
            line.strokeWidth = 3.0
            line.geodesic = false
            line.map = mapView
            
            let camera = GMSCameraPosition.camera(
                withLatitude: sortedLocations.first!.latitude,
                longitude: sortedLocations.first!.longitude,
                zoom: 14
            )
            mapView.camera = camera
            mapView.animate(to: camera)
        } else {
            mapView.animate(toZoom: 8)
        }
    }
    
    fileprivate func showChart() {
        
        if currentModel.type == TrackerActivityType.WALKING.id || currentModel.type == TrackerActivityType.RUNNING.id || currentModel.type == TrackerActivityType.CYCLING.id {
            if currentModel.steps >= 150 { // display only for movements of at least 150 steps
                if currentModel.activityDuration >= 180 { // display only for movements of at least 3 minutes
                    chart.visibility = .visible
                    noChart.visibility = .invisible
                    generateChart()
                } else {
                    chart.visibility = .invisible
                    noChart.visibility = .visible
                    noChart.text = StringProvider.get("not_enough_distance_to_show_chart")
                }
            } else {
                chart.visibility = .invisible
                noChart.visibility = .visible
                noChart.text = StringProvider.get("not_enough_steps_to_show_chart")
            }
        } else {
            chart.visibility = .invisible
            noChart.visibility = .visible
            noChart.text = StringProvider.get("chart_not_available_for_type")
        }
    }
    
    fileprivate func generateChart() {
        var entries = [ChartDataEntry]()
        var formattedValues = [String]()
        var maxY: Double = 0
        
        
        var index = 0
        let steps = currentModel.getStepsSegmented()
        for step in steps {
            let steps = step.stepsCount
            let entry = ChartDataEntry()
            entry.x = Double(index)
            entry.y = Double(steps)
            entries.append(entry)
            formattedValues.append(TimeUtils.format(step.startDate, Constants.DATE_FORMAT_HOUR_MINUTE, convertToDefault: true))
            maxY = max(maxY, Double(steps))
            index += 1
        }
        
        let chartDataSet = LineChartDataSet(entries: entries, label: Constants.EMPTY)
        chartDataSet.colors = [ColorProvider.get("colorPrimary")!]
        chartDataSet.highlightColor = UIColor.systemRed
        chartDataSet.valueTextColor = UIColor.black
        chartDataSet.circleRadius = 4
        chartDataSet.circleColors = [ColorProvider.get("colorPrimary")!]
        chartDataSet.drawCircleHoleEnabled = false
        chartDataSet.form = .none
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        
        chart.xAxis.axisMinimum = 0
        chart.xAxis.granularity = 1
        chart.xAxis.drawAxisLineEnabled = true
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelPosition = .bottom
        
        chart.leftAxis.axisMinimum = 0
        chart.leftAxis.axisMaximum = maxY + 10
        chart.leftAxis.granularity = 20
        chart.leftAxis.drawZeroLineEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.labelPosition = .outsideChart
        
        chart.rightAxis.enabled = false
        chart.dragEnabled = false
        chart.scaleXEnabled = false
        chart.scaleYEnabled = false
        
        chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: formattedValues)
        
        chart.data = chartData
    }
}
