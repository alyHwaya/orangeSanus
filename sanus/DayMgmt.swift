//
//  DayMgmt.swift
//  sanus
//
//  Created by aly hassan on 03/11/2021.
//

import Foundation
import UIKit
let defaults = UserDefaults.standard
class DayMgmt{
    
    public static func  loadDay(){
        
        if let day = defaults.value(forKey: "currentDay") as? [String:String]{
            print("day \(day)")
        }else{
            let defaultDay = ["date":convDateToStr(date: Date()),"cals":"0","aero":"non2", "gym":"non"]
            defaults.set(defaultDay, forKey: "currentDay")
//            print("First time!!!!")
        }
    }
    
    public static func saveCurrDay(day: Day){
        let defaultDay = ["date":day.date ,"cals":"\(day.calories)","aero":day.aerobics, "gym":day.gym]
        defaults.set(defaultDay, forKey: "currentDay")
    }
    
    public static func getCurrentDay() -> Day{
        var theDay = Day(date: convDateToStr(date: Date()), calories: 0, gym: "non", aerobics: "non2")
        if let tempDay = defaults.value(forKey: "currentDay") as? [String:String]{
            let day = Day(date: tempDay["date"]! , calories: (tempDay["cals"]! as NSString).doubleValue, gym: tempDay["gym"]!, aerobics: tempDay["aero"]!)
        theDay = day
        }
        return theDay
    }
    
    public static func prepareAerobicsBtn(btn: UIButton) {
        let tempDay = DayMgmt.getCurrentDay()
        print("aero \(tempDay.aerobics)")
        let img = UIImage(named: tempDay.aerobics)
        let targetSize = CGSize(width: 20, height: 20)
        let myImg = UIGraphicsImageRenderer(size:targetSize).image { _ in
            img?.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        btn.setImage(myImg, for: .normal)
    }
    
    public static func prepareGymBtn(btn: UIButton) {
        let tempDay = DayMgmt.getCurrentDay()
        let img = UIImage(named: tempDay.gym)
        let targetSize = CGSize(width: 25, height: 25)
        let myImg = UIGraphicsImageRenderer(size:targetSize).image { _ in
            img?.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        btn.setImage(myImg, for: .normal)
    }
    
    public static func updateDaysBeforeReset() -> String{
        print("updateDaysBeforeReset \(getCurrentDay().date)")
        var myData = UnArchiveDays()
        let day = getCurrentDay()
        if day.date != "" {
            myData.updateValue(day, forKey: day.date)
            ArchiveDays(db: myData)
            let dayToBeSaved = DayMgmt.compareDates()
            let newCurrDay = Day(date: convDateToStr(date: Date()), calories: 0, gym: "non", aerobics: "non2")
            saveCurrDay(day: newCurrDay)
            return dayToBeSaved
        }else {
            let newCurrDay = Day(date: convDateToStr(date: Date()), calories: 0, gym: "non", aerobics: "non2")
            saveCurrDay(day: newCurrDay)
            return "null"
        }
    }
    
    public static func compareDates () -> String{
        let currDateStr = DayMgmt.getCurrDateStr()
        let currDate = DayMgmt.convStrToDate(string: currDateStr)
        let todayStr = DayMgmt.convDateToStr(date: Date())
        let today = DayMgmt.convStrToDate(string: todayStr)
        if currDate < today {
            return currDateStr
        }else{
            return todayStr
        }
    }
    
    public static func setCurrDateDefault(){
        if let day = defaults.value(forKey: "currentDate") as? String{
            print("day \(day)")
        }else{
            let defaultDay = convDateToStr(date: Date())
            defaults.set(defaultDay, forKey: "currentDate")
//            print("First time!!!!")
        }
    }
    public static func saveCurrDate(){
        let dateStr = convDateToStr(date: Date())
        defaults.set(dateStr, forKey: "currentDate")
    }
    
    public static func getCurrDateStr() -> String{
        var result = "1 oct 1974"
        if let day = defaults.value(forKey: "currentDate") as? String{
            result = day
        }
        return result
    }
    
    public static func convDateToStr (date:Date) -> String{
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "d MMM y"
        let result = formatter3.string(from: date)
        return result
    }
    
    public static func convStrToDate (string:String) -> Date {
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "d MMM y"
        let result = formatter4.date(from: string) ?? Date()
        return result
    }
    
   
    public static func ArchiveDays(db: [String : Day]){
        let filePath = UtilFun.getFileUrl(fileName: "days.aly")
        let json = try? JSONEncoder().encode(db)
        do {
            try json!.write(to: filePath)
//            print("done aly")
        } catch {
//            print("Failed to write JSON data: \(error.localizedDescription)")
        }
    }
    
    public static func UnArchiveDays()-> [String : Day]{

        let path = UtilFun.getFileUrl(fileName: "days.aly")
        //let jsonData = NSData(contentsOfMappedFile: path.path)
        var MyData = Data()
        var MyDict = [String : Day]()
        do{
            let myJsonData = try Data(contentsOf: path)
            MyData = myJsonData
        }catch{
//            let day1 = Day(date: "1 Oct 2022", calories: 1000, gym: "arm", aerobics: "run2")
//            let day2 = Day(date: "1 Jan 2021", calories: 1000, gym: "arm", aerobics: "run2")
//            let day3 = Day(date: "1 Dec 2021", calories: 1000, gym: "arm", aerobics: "run2")
//
//            MyDict = [day1.date : day1, day2.date : day2, day3.date: day3]
            MyDict = [:]
            print("Failed to read JSON data: \(error.localizedDescription)")
        }
//        print(MyData)
        // now decode the data to array
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([String : Day].self, from: MyData) {
            MyDict = decoded
        }
        // now reverse sort the array
//        print(MyDict)
        return MyDict
    }
    
    public static func prepareDataForChart(myDataDic: [String: Day]) -> [Date]{
        let myDataStr = Array(myDataDic.keys)
        print("myDataStr \(myDataStr)")
        var myData = [Date]()
        for item in myDataStr {
            let date = DayMgmt.convStrToDate(string: item)
            myData.append(date)
        }
        return myData.sorted()
    }
    
}
