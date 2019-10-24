//
//  ExcerciseTableViewController.swift
//  HealthGraph
//
//  Created by LeeJongMin on 05/02/2018.
//  Copyright © 2018 flymax. All rights reserved.
//

import UIKit
import Charts
import FSLineChart

import HealthKit
import Firebase
import FirebaseDatabase

class ExcerciseTableViewController: UITableViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var Chart1: BarChartView!
//    @IBOutlet weak var PhysicalChart: FSLineChart!
    @IBOutlet weak var WeightChart: LineChartView!
//    @IBOutlet weak var CaloriesChart: FSLineChart!
    @IBOutlet weak var CaChart: PieChartView!
    
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblStepPercent: UILabel!
    @IBOutlet weak var vwStepBg: UIView!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblWeightPercent: UILabel!
    @IBOutlet weak var vwWeightBg: UIView!
    @IBOutlet weak var lblCal: UILabel!
    @IBOutlet weak var lblCalPercent: UILabel!
    @IBOutlet weak var vwCalBg: UIView!
    @IBOutlet weak var lblMyGoal: UILabel!
    @IBOutlet weak var lblGoalActive: UILabel!
    @IBOutlet weak var lblGoalActiveBg: UILabel!
    @IBOutlet weak var lblGoalIdle: UILabel!
    @IBOutlet weak var lblGoalStress: UILabel!
    
    @IBOutlet weak var lblWeightStatus: UILabel!
    @IBOutlet weak var lblCalStatus: UILabel!
    @IBOutlet weak var lblExerciseStatus: UILabel!
    @IBOutlet weak var lblStepsStatus: UILabel!
    @IBOutlet weak var lblSleepStatus: UILabel!
    @IBOutlet weak var myGoalChart: PieChartView!
    @IBOutlet weak var exerciseChart: PieChartView!
    @IBOutlet weak var caloriesInOutChart: LineChartView!
    @IBOutlet weak var heartChart: LineChartView!
    let clrGreen = UIColor(red:36/255,green:174/255,blue:110/255,alpha:1)
    let clrYellow = UIColor(red: 202/255, green: 145/255, blue: 68/255, alpha: 1)
    

    private func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
        }
    }
    func saveHealthData(_ arr: Array<[String:Any]>, type: String){
        if let user = Auth.auth().currentUser{
            self.ref.child("user").child(user.uid).child(type).setValue(arr)
            self.ref.child("user").child(user.uid).child("email").setValue(user.email)
            self.ref.child("user").child(user.uid).child("name").setValue(user.displayName)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        ref = Database.database().reference()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAndDisplayMostRecentWeight()
        loadSteps()
        loadEnergy()
        
        loadCalorie()
        //
//                loadExercise()
        loadGoal()
        loadHeartRate()
        
        //        updateBarChart()
        //        updatePieChart()
        //        updateLineChart()
    }
    
    func updateBarChart(){
        let numbers = [1,2,5,3,2,1]
        var lineChartEntry  = [BarChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = BarChartDataEntry(x: Double(i), y: Double(numbers[i])) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = BarChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [clrGreen] //Sets the colour to blue
        line1.valueTextColor = clrGreen
        let data = BarChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        Chart1.data = data //finally - it adds the chart data to the chart and causes an update
        Chart1.chartDescription?.text = "" // Here we set the description for the graph
        Chart1.legend.enabled = false
        Chart1.xAxis.drawAxisLineEnabled = false
        Chart1.xAxis.drawGridLinesEnabled = false
        Chart1.xAxis.labelTextColor = clrGreen
        Chart1.xAxis.labelPosition = .bottom
//        Chart1.xAxis.drawLabelsEnabled = false
        Chart1.rightAxis.drawLabelsEnabled = false
        Chart1.rightAxis.drawGridLinesEnabled = false
        Chart1.rightAxis.drawAxisLineEnabled = false
        Chart1.leftAxis.labelTextColor = clrGreen
    }
    func updatePieChart(){
        let numbers = [1,5]
        var lineChartEntry  = [PieChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = PieChartDataEntry(value: Double(numbers[i]), label: i == 0 ? "Calories In ":"Calories Out") // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        
        let line1 = PieChartDataSet(values: lineChartEntry, label: "") //Here we convert lineChartEntry to a LineChartDataSet
        
        line1.colors = [clrGreen, .white] //Sets the colour to blue
        line1.valueTextColor = clrGreen
        line1.drawValuesEnabled = false
        line1.entryLabelColor = .clear
        line1.selectionShift = 0
        //line1.sliceSpace = 3.0
        
        let data = PieChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        CaChart.data = data //finally - it adds the chart data to the chart and causes an update
        //CaChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
//        CaChart.drawHoleEnabled = true
        CaChart.legend.textColor = clrGreen
        CaChart.legend.horizontalAlignment = .right
        CaChart.drawSlicesUnderHoleEnabled = true
        CaChart.holeRadiusPercent = 2
        CaChart.chartDescription?.enabled = false
        CaChart.highlightPerTapEnabled = false
        
//        CaChart.legend.enabled = false
        
        
        CaChart.transparentCircleRadiusPercent = 0
        CaChart.holeColor = .clear
        
        let line2 = PieChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        
        line2.colors = [clrGreen, clrYellow] //Sets the colour to blue
        line2.valueTextColor = .clear
        //line1.sliceSpace = 3.0
        
        
        let data2 = PieChartData() //This is the object that will be added to the chart
        data2.addDataSet(line2) //Adds the line to the dataSet
        
        myGoalChart.data = data2
        myGoalChart.holeRadiusPercent = 0.95
        myGoalChart.chartDescription?.enabled = false
        myGoalChart.legend.enabled = false
        myGoalChart.transparentCircleRadiusPercent = 0
        myGoalChart.holeColor = .clear
        
        exerciseChart.data = data
        exerciseChart.holeRadiusPercent = 0.99
        exerciseChart.chartDescription?.enabled = false
        exerciseChart.legend.enabled = false
        exerciseChart.transparentCircleRadiusPercent = 0
        exerciseChart.holeColor = .clear
        exerciseChart.chartDescription?.text = "402"
    }
    var numbers : [Double] = [1,2,5,3,2,1]
    func updateLineChart(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [clrGreen] //Sets the colour to blue
        line1.circleColors = [.clear]
        line1.fillColor = clrYellow
        line1.fillAlpha = 0.5
        line1.drawFilledEnabled = true
        line1.circleRadius = 3
        line1.valueTextColor = clrGreen
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        caloriesInOutChart.data = data //finally - it adds the chart data to the chart and causes an update
        caloriesInOutChart.chartDescription?.text = "" // Calories In/Out Chart
        caloriesInOutChart.legend.enabled = false
        caloriesInOutChart.xAxis.drawAxisLineEnabled = false
        caloriesInOutChart.xAxis.drawGridLinesEnabled = false
        caloriesInOutChart.xAxis.labelTextColor = clrGreen
        caloriesInOutChart.xAxis.labelPosition = .bottom
        caloriesInOutChart.rightAxis.drawLabelsEnabled = false
        caloriesInOutChart.rightAxis.drawGridLinesEnabled = false
        caloriesInOutChart.rightAxis.drawAxisLineEnabled = false
        caloriesInOutChart.leftAxis.labelTextColor = clrGreen
        
        heartChart.data = data //finally - it adds the chart data to the chart and causes an update
        heartChart.chartDescription?.text = "" // Heart Chart
        heartChart.legend.enabled = false
        heartChart.xAxis.drawAxisLineEnabled = false
        heartChart.xAxis.drawGridLinesEnabled = false
        heartChart.xAxis.labelTextColor = clrGreen
        heartChart.xAxis.labelPosition = .bottom
        heartChart.rightAxis.drawLabelsEnabled = false
        heartChart.rightAxis.drawGridLinesEnabled = false
        heartChart.rightAxis.drawAxisLineEnabled = false
        heartChart.leftAxis.labelTextColor = clrGreen
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    
//    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblExercise: UILabel!
    @IBOutlet weak var lblStands: UILabel!
    @IBOutlet weak var lblCaloriesDetail: UILabel!
    @IBOutlet weak var lblExercisesDetail: UILabel!
    @IBOutlet weak var lblStandsDetail: UILabel!
    func loadGoal(){
        ProfileDataStore.getSummaries(completion: { summaries, error in
            for summary in summaries! {
                DispatchQueue.main.async {
                    self.drawGoal(summary)
                }
                
            }
        })
    }
    func drawGoal(_ summary: HKActivitySummary){
        var item = [String:Any]()
        lblCaloriesDetail.text = "\(summary.activeEnergyBurned)/\(summary.activeEnergyBurnedGoal)"
        
        lblExercisesDetail.text = "\(summary.appleExerciseTime)/\(summary.appleExerciseTimeGoal)"
        lblStandsDetail.text = "\(summary.appleStandHours)/\(summary.appleStandHoursGoal)"
        let exercise1 = summary.appleExerciseTime.doubleValue(for: HKUnit.minute())
        let exercise2 = summary.appleExerciseTimeGoal.doubleValue(for: HKUnit.minute())
        let stands1 = summary.appleStandHours.doubleValue(for: HKUnit.count())
        let stands2 = summary.appleStandHoursGoal.doubleValue(for: HKUnit.count())
        let calorie1 = summary.activeEnergyBurned.doubleValue(for: HKUnit.calorie())
        let calorie2 = summary.activeEnergyBurnedGoal.doubleValue(for: HKUnit.calorie())
        
        item["Exercise"] = ["Goal":exercise2, "Val": exercise1]
        item["Stands"] = ["Goal":stands2, "Val": stands1]
        item["Calorie"] = ["Goal":calorie2, "Val": calorie1]
        saveHealthData([item], type: "Goal")
        drawExercise([exercise1, exercise2])
        
        let numbers = [exercise1+stands1+calorie1, exercise2+stands2+calorie2]
        var lineChartEntry  = [PieChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = PieChartDataEntry(value: Double(numbers[i]), label: i == 0 ? "Calories In ":"Calories Out") // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        
        let line1 = PieChartDataSet(values: lineChartEntry, label: "") //Here we convert lineChartEntry to a LineChartDataSet
        
        line1.colors = [clrGreen, .white] //Sets the colour to blue
        line1.valueTextColor = clrGreen
        line1.drawValuesEnabled = false
        line1.entryLabelColor = .clear
        line1.selectionShift = 0
        //line1.sliceSpace = 3.0
        
        let data = PieChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        
        myGoalChart.data = data
        myGoalChart.holeRadiusPercent = 0.95
        myGoalChart.chartDescription?.enabled = false
        myGoalChart.legend.enabled = false
        myGoalChart.transparentCircleRadiusPercent = 0
        myGoalChart.holeColor = .clear
    }
    @IBOutlet weak var lblActiveExercise: UILabel!
    @IBOutlet weak var lblGoalExercise: UILabel!
    @IBOutlet weak var lblExerciseActiveGoal: UILabel!
    func drawExercise(_ numbers: [Double]){
        lblActiveExercise.text = "\(numbers[0])"
        lblGoalExercise.text = "\(numbers[1])"
        lblExerciseActiveGoal.text = "\(numbers[0]) / \(numbers[1])"
        var lineChartEntry  = [PieChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0..<numbers.count {
            let value = PieChartDataEntry(value: Double(numbers[i]), label: i == 0 ? "Calories In ":"Calories Out") // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = PieChartDataSet(values: lineChartEntry, label: "") //Here we convert lineChartEntry to a LineChartDataSet
        
        line1.colors = [clrGreen, .white] //Sets the colour to blue
        line1.valueTextColor = clrGreen
        line1.drawValuesEnabled = false
        line1.entryLabelColor = .clear
        line1.selectionShift = 0
        //line1.sliceSpace = 3.0
        
        let data = PieChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        exerciseChart.data = data
        exerciseChart.holeRadiusPercent = 0.99
        exerciseChart.chartDescription?.enabled = false
        exerciseChart.legend.enabled = false
        exerciseChart.transparentCircleRadiusPercent = 0
        exerciseChart.holeColor = .clear
        exerciseChart.chartDescription?.text = "402"
    }
    func loadCalorie(){
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        let curDate = Date()
        var weekDate = Calendar.current.date(byAdding: .day, value: -1, to: curDate)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        var defaultItem = [String: Any]()
        
        defaultItem["calorie"] = Double(0.0)
        var arr = Array<[String: Any]>(repeating: defaultItem, count: 32)
        
        weekDate = Calendar.current.date(byAdding: .month, value: -1, to: curDate)!
        
        ProfileDataStore.getSampleStatics(type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, limit: 2, option: .cumulativeSum){ (myResults, error) in
            
            myResults.enumerateStatistics(from: weekDate!, to: Date()) { statistics, stop in
                if let quantity = statistics.sumQuantity(){
                    let date = statistics.startDate
                    let calorie = quantity.doubleValue(for: HKUnit.calorie())
                    print("\(date): activeEnergyBurned = \(calorie)")
                    
                    var item = [String:Any]()
                    item["date"] = df.string(from: date)
                    item["calorie"] = calorie
                    var index = 0
                    let components = Calendar.current.dateComponents([.day], from: date, to: curDate)
                    index = 31 - components.day!
                    arr.remove(at: index)
                    arr.insert(item, at: index)
                    
                }
            }
            DispatchQueue.main.async {
                self.drawCalorie(0, arr)
            }
        }
        var arr1 = Array<[String: Any]>(repeating: defaultItem, count: 32)
        ProfileDataStore.getSampleStatics(type: HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!, limit: 2, option: .cumulativeSum){ (myResults, error) in
            
            myResults.enumerateStatistics(from: weekDate!, to: Date()) { statistics, stop in
                if let quantity = statistics.sumQuantity(){
                    let date = statistics.startDate
                    let calorie = quantity.doubleValue(for: HKUnit.calorie())
                    print("\(date): dietaryEnergyConsumed = \(calorie)")
                    
                    var item = [String:Any]()
                    item["date"] = df.string(from: date)
                    item["calorie"] = calorie
                    var index = 0
                    let components = Calendar.current.dateComponents([.day], from: date, to: curDate)
                    index = 31 - components.day!
                    arr1.remove(at: index)
                    arr1.insert(item, at: index)
                }
            }
            DispatchQueue.main.async {
                self.drawCalorie(1, arr1)
            }
        }
    }
    var arr_cal0 = Array<[String: Any]>()
    var arr_cal1 = Array<[String: Any]>()
    func drawCalorie(_ index: Int, _ arr: Array<[String:Any]>){
        if index == 0{
            arr_cal0 = arr
            saveHealthData(arr, type: "CaloriesIn")
        }
        else{
            arr_cal1 = arr
            saveHealthData(arr, type: "CaloriesOut")
        }
        var lineChartEntry  = [ChartDataEntry]()
        for i in 0..<arr_cal0.count {
            let value = ChartDataEntry(x: Double(i), y: arr_cal0[i]["calorie"] as! Double)
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number")
        line1.colors = [clrGreen] //Sets the colour to blue
        line1.circleColors = [.clear]
        line1.fillColor = clrGreen
        line1.fillAlpha = 0.5
        line1.drawFilledEnabled = true
        line1.circleRadius = 3
        line1.valueTextColor = clrGreen
        
        let data = LineChartData()
        data.addDataSet(line1) //Adds the line to the dataSet
        lineChartEntry = [ChartDataEntry]()
        for i in 0..<arr_cal1.count {
            let value = ChartDataEntry(x: Double(i), y: arr_cal1[i]["calorie"] as! Double)
            lineChartEntry.append(value)
        }
        let line2 = LineChartDataSet(values: lineChartEntry, label: "Number")
        line2.colors = [clrYellow] //Sets the colour to blue
        line2.circleColors = [.clear]
        line2.fillColor = clrYellow
        line2.fillAlpha = 0.5
        line2.drawFilledEnabled = true
        line2.circleRadius = 3
        line2.valueTextColor = clrGreen
        data.addDataSet(line2)
        
        caloriesInOutChart.data = data //finally - it adds the chart data to the chart and causes an update
        caloriesInOutChart.chartDescription?.text = "" // Calories In/Out Chart
        caloriesInOutChart.legend.enabled = false
        caloriesInOutChart.xAxis.drawAxisLineEnabled = false
        caloriesInOutChart.xAxis.drawGridLinesEnabled = false
        caloriesInOutChart.xAxis.labelTextColor = clrGreen
        caloriesInOutChart.xAxis.labelPosition = .bottom
        caloriesInOutChart.xAxis.drawLabelsEnabled = false
        caloriesInOutChart.rightAxis.drawLabelsEnabled = false
        caloriesInOutChart.rightAxis.drawGridLinesEnabled = false
        caloriesInOutChart.rightAxis.drawAxisLineEnabled = false
        caloriesInOutChart.leftAxis.labelTextColor = clrGreen
    }
    private func loadHeartRate() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .heartRate) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        let curDate = Date()
        var weekDate = Calendar.current.date(byAdding: .day, value: -1, to: curDate)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        var defaultItem = [String: Any]()
        
        defaultItem["heartRate"] = Double(0.0)
        var arr = Array<[String: Any]>(repeating: defaultItem, count: 32)
        
        weekDate = Calendar.current.date(byAdding: .month, value: -1, to: curDate)!
        
        ProfileDataStore.getSampleStatics(type: HKQuantityType.quantityType(forIdentifier: .heartRate)!, limit: 2){ (myResults, error) in
            
            myResults.enumerateStatistics(from: weekDate!, to: Date()) { statistics, stop in
                if let quantity = statistics.averageQuantity(){
                    let date = statistics.startDate
                    let weight = quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                    print("\(date): heartRate = \(weight)")
                    var item = [String:Any]()
                    item["date"] = df.string(from: date)
                    item["heartRate"] = weight
                    var index = 0
                    let components = Calendar.current.dateComponents([.day], from: date, to: curDate)
                    //print("\(components.day)")
                    index = 31 - components.day!
                    arr.remove(at: index)
                    arr.insert(item, at: index)
                }
            }
            DispatchQueue.main.async {
                self.updateHeartRate(arr)
            }
        }
    }
    func updateHeartRate(_ arrs: Array<[String:Any]>){
        
        saveHealthData(arrs, type: "HeartRate")
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        //here is the for loop
        for i in 0..<arrs.count {
            let value = ChartDataEntry(x: Double(i), y: arrs[i]["heartRate"] as! Double) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [clrGreen] //Sets the colour to blue
        line1.circleColors = [.clear]
        line1.fillColor = clrYellow
        line1.fillAlpha = 0.5
        line1.drawFilledEnabled = true
        line1.circleRadius = 3
        line1.valueTextColor = clrGreen
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        heartChart.data = data //finally - it adds the chart data to the chart and causes an update
        heartChart.chartDescription?.text = "" // Calories In/Out Chart
        heartChart.legend.enabled = false
        heartChart.xAxis.drawAxisLineEnabled = false
        heartChart.xAxis.drawGridLinesEnabled = false
        heartChart.xAxis.labelTextColor = clrGreen
        heartChart.xAxis.labelPosition = .bottom
        
        heartChart.xAxis.drawLabelsEnabled = false
        heartChart.rightAxis.drawLabelsEnabled = false
        heartChart.rightAxis.drawGridLinesEnabled = false
        heartChart.rightAxis.drawAxisLineEnabled = false
        heartChart.leftAxis.labelTextColor = clrGreen
        
    }
    private func loadEnergy() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        let curDate = Date()
        var weekDate = Calendar.current.date(byAdding: .day, value: -1, to: curDate)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        var defaultItem = [String: Any]()
        
        defaultItem["weight"] = Double(0.0)
        var arr = Array<[String: Any]>(repeating: defaultItem, count: 32)
        
        weekDate = Calendar.current.date(byAdding: .day, value: -1, to: curDate)!
        
        weekDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))
        
        ProfileDataStore.getSampleStatics(type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, limit: 2, option: .cumulativeSum){ (myResults, error) in
            
            myResults.enumerateStatistics(from: weekDate!, to: Date()) { statistics, stop in
                if let quantity = statistics.sumQuantity(){
                    let date = statistics.startDate
                    let calorie = quantity.doubleValue(for: HKUnit.calorie())
                    print("\(date): activeEnergyBurned = \(calorie)")
                    self.setCalorie(0, calorie)
                }
            }
            DispatchQueue.main.async {
                self.drawEnergy()
            }
        }
        ProfileDataStore.getSampleStatics(type: HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!, limit: 2, option: .cumulativeSum){ (myResults, error) in
            
            myResults.enumerateStatistics(from: weekDate!, to: Date()) { statistics, stop in
                if let quantity = statistics.sumQuantity(){
                    let date = statistics.startDate
                    let calorie = quantity.doubleValue(for: HKUnit.calorie())
                    print("\(date): dietaryEnergyConsumed = \(calorie)")
                    self.setCalorie(1, calorie)
                }
            }
            DispatchQueue.main.async {
                self.drawEnergy()
            }
        }
    }
    var calories = [Double](repeating: 0.0, count: 2)
    func setCalorie(_ index: Int, _ calorie: Double){
        calories[index] = calorie
    }
    func drawEnergy(){
//        saveHealthData([["CalorisIn": calories[0], "CaloriesOut": calories[1]]], type: "Calories")
        let numbers = [1,5]
        var lineChartEntry  = [PieChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0..<calories.count {
            
            let value = PieChartDataEntry(value: Double(calories[i]), label: i == 0 ? "Calories In ":"Calories Out") // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        
        let line1 = PieChartDataSet(values: lineChartEntry, label: "") //Here we convert lineChartEntry to a LineChartDataSet
        
        line1.colors = [clrGreen, .white] //Sets the colour to blue
        line1.valueTextColor = clrGreen
        line1.drawValuesEnabled = false
        line1.entryLabelColor = .clear
        line1.selectionShift = 0
        //line1.sliceSpace = 3.0
        
        let data = PieChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        CaChart.data = data //finally - it adds the chart data to the chart and causes an update
        //CaChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
        //        CaChart.drawHoleEnabled = true
        CaChart.legend.textColor = clrGreen
        CaChart.legend.horizontalAlignment = .right
        CaChart.drawSlicesUnderHoleEnabled = true
        CaChart.holeRadiusPercent = 2
        CaChart.chartDescription?.enabled = false
        CaChart.highlightPerTapEnabled = false
        
        //        CaChart.legend.enabled = false
        
        
        CaChart.transparentCircleRadiusPercent = 0
        CaChart.holeColor = .clear
        
    }
    
    private func loadAndDisplayMostRecentWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        let curDate = Date()
        var weekDate = Calendar.current.date(byAdding: .day, value: -1, to: curDate)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        var defaultItem = [String: Any]()
        
        defaultItem["weight"] = Double(0.0)
        var arr = Array<[String: Any]>(repeating: defaultItem, count: 32)
        
        weekDate = Calendar.current.date(byAdding: .month, value: -1, to: curDate)!
        
        ProfileDataStore.getSampleStatics(type: HKQuantityType.quantityType(forIdentifier: .bodyMass)!, limit: 2){ (myResults, error) in
            
            myResults.enumerateStatistics(from: weekDate!, to: Date()) { statistics, stop in
                if let quantity = statistics.averageQuantity(){
                    let date = statistics.startDate
                    let weight = quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                    print("\(date): steps = \(weight)")
                    var item = [String:Any]()
                    item["date"] = df.string(from: date)
                    item["weight"] = weight
                    var index = 0
                    let components = Calendar.current.dateComponents([.day], from: date, to: curDate)
                    //print("\(components.day)")
                    index = 31 - components.day!
                    arr.remove(at: index)
                    arr.insert(item, at: index)
                }
            }
            DispatchQueue.main.async {
                self.updateWeight(arr)
            }
        }
//        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
//            print("Body Mass Sample Type is no longer available in HealthKit")
//            return
//        }
//
//        ProfileDataStore.getRecentWeekSample(for: weightSampleType, limit:30) { (samples, error) in
//            guard let samples = samples else {
//                if let error = error {
//                    //self.displayAlert(for: error)
//                }
//                return
//            }
//            var arr : [Double] = []
//            for sample in samples{
//                arr.append(sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo)))
//            }
//            self.updateWeight(arr)
//        }
    }
    //func updateWeight(_ weights: [Double]){
    func updateWeight(_ arrs: Array<[String:Any]>){
        saveHealthData(arrs, type: "Weight")
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        //here is the for loop
        for i in 0..<arrs.count {
            let value = ChartDataEntry(x: Double(i), y: arrs[i]["weight"] as! Double) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [clrGreen] //Sets the colour to blue
        line1.circleColors = [.clear]
        line1.fillColor = clrYellow
        line1.fillAlpha = 0.5
        line1.drawFilledEnabled = true
        line1.circleRadius = 3
        line1.valueTextColor = clrGreen
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        WeightChart.data = data //finally - it adds the chart data to the chart and causes an update
        WeightChart.chartDescription?.text = "" // Calories In/Out Chart
        WeightChart.legend.enabled = false
        WeightChart.xAxis.drawAxisLineEnabled = false
        WeightChart.xAxis.drawGridLinesEnabled = false
        WeightChart.xAxis.labelTextColor = clrGreen
        WeightChart.xAxis.labelPosition = .bottom
        WeightChart.rightAxis.drawLabelsEnabled = false
        WeightChart.rightAxis.drawGridLinesEnabled = false
        WeightChart.rightAxis.drawAxisLineEnabled = false
        WeightChart.leftAxis.labelTextColor = clrGreen
        
    }
    private func loadSteps() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .stepCount) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        let curDate = Date()
        var weekDate = Calendar.current.date(byAdding: .day, value: -1, to: curDate)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        var arr = Array<[String: Any]>()
        ProfileDataStore.getSampleStatics(type: HKQuantityType.quantityType(forIdentifier: .stepCount)!, limit: 2, option: .cumulativeSum){ (myResults, error) in
            
            //myResults.statistics(for: )
            myResults.enumerateStatistics(from: weekDate!, to: Date()) { statistics, stop in
                if let quantity = statistics.sumQuantity(){
                    let date = statistics.startDate
                    let steps = quantity.doubleValue(for: HKUnit.count())
                    print("\(date): steps = \(steps)")
                    var item = [String:Any]()
                    item["date"] = df.string(from: date)
                    item["steps"] = steps
                    arr.append(item)
                }
            } //end block
            DispatchQueue.main.async {
                self.updateStep(arr)
            }
        }
        var defaultItem = [String: Any]()
        
        defaultItem["steps"] = Double(0.0)
        var arr1 = Array<[String: Any]>(repeating: defaultItem, count: 8)
    
        weekDate = Calendar.current.date(byAdding: .day, value: -7, to: curDate)!
        
        ProfileDataStore.getSampleStatics(type: HKQuantityType.quantityType(forIdentifier: .stepCount)!, limit: 2, option: .cumulativeSum){ (myResults, error) in
            
            myResults.enumerateStatistics(from: weekDate!, to: Date()) { statistics, stop in
                if let quantity = statistics.sumQuantity(){
                    let date = statistics.startDate
                    let steps = quantity.doubleValue(for: HKUnit.count())
                    print("\(date): steps = \(steps)")
                    var item = [String:Any]()
                    item["date"] = df.string(from: date)
                    item["timestamp"] = date.timeIntervalSince1970
                    item["steps"] = steps
                    var index = 0
                    
                    let components = Calendar.current.dateComponents([.day], from: date, to: curDate)
                    //print("\(components.day)")
                    index = 7 - components.day!
                    arr1.remove(at: index)
                    arr1.insert(item, at: index)
                }
            }
            DispatchQueue.main.async {
                self.drawSteps(arr1)
            }
        }
    }
    func drawSteps(_ arr: Array<[String: Any]>){
        saveHealthData(arr, type: "Steps")
        var lineChartEntry  = [BarChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0..<arr.count {
            let value = BarChartDataEntry(x: Double(i), y: arr[i]["steps"] as! Double) // here we set the X and Y status in a data chart entry
            
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = BarChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [clrGreen] //Sets the colour to blue
        line1.valueTextColor = clrGreen
        let data = BarChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        Chart1.data = data //finally - it adds the chart data to the chart and causes an update
        Chart1.chartDescription?.text = "" // Here we set the description for the graph
        Chart1.legend.enabled = false
        Chart1.xAxis.drawAxisLineEnabled = false
        Chart1.xAxis.drawGridLinesEnabled = false
        Chart1.xAxis.labelTextColor = clrGreen
        Chart1.xAxis.labelPosition = .bottom
                Chart1.xAxis.drawLabelsEnabled = false
        Chart1.rightAxis.drawLabelsEnabled = false
        Chart1.rightAxis.drawGridLinesEnabled = false
        Chart1.rightAxis.drawAxisLineEnabled = false
        Chart1.leftAxis.labelTextColor = clrGreen
    }
    func updateStep(_ arr: Array<[String: Any]>){ // 0,1,2
        saveHealthData(arr, type: "Steps")
        lblStep.text = "-"
        lblStepPercent.text = "-"
        if arr.count > 0 {
            
            var yesterday = 0.0
            var today = arr[0]["steps"] as! Double
            if arr.count > 1 {
                yesterday = arr[0]["steps"] as! Double
                today = arr[1]["steps"] as! Double
            }
            lblStep.text = "\(Int(today))"
            let percent = yesterday == 0 ? 1000 : today / yesterday * 100
            lblStepPercent.text = "\(percent)%"
            if today > yesterday {
                lblStepPercent.text = lblStepPercent.text! + "+"
            }
            else{
                lblStepPercent.text = lblStepPercent.text! + "-"
            }
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
