//
//  ChartDetailViewController.swift
//  sanus
//
//  Created by aly hassan on 09/11/2021.
//

import UIKit

class ChartDetailViewController: UIViewController, UIPickerViewDelegate ,UIPickerViewDataSource, UITextFieldDelegate {
   
    let gymData = ["No Activity":"non" ,"Upper limbs":"arm", "Back":"back", "Back & Biceps":"bb", "Chest":"chest", "Chest & Triceps":"ct", "Lower limbs":"legs", "Shoulders":"shoulder", "Abdomen":"abs", "General":"all"]
    let aeroData = ["Running":"run2", "Walking":"walk2", "Cycling":"cycle2", "Resting":"non2" ]
    var pickerData = ["1", "2", "3"]
    let myPicker = UIPickerView()
    var currentDay : Day?
    
    @IBOutlet weak var calsTxtFld: UITextField!
    @IBOutlet weak var aeroTxtFld: UITextField!
    @IBOutlet weak var aeroImgVw: UIImageView!
    @IBOutlet weak var gymTxtFld: UITextField!
    @IBOutlet weak var gymImgVw: UIImageView!
    
    @IBAction func saveBtnAct(_ sender: Any) {
        if calsTxtFld.text != ""{
            print("saving")
        let cals = (calsTxtFld.text! as NSString).doubleValue
        let myDay = Day(date: currentDay?.date ?? "1 Oct 1974", calories: cals, gym: currentDay?.gym ?? "non", aerobics: currentDay?.aerobics ?? "non2")
        var days = DayMgmt.UnArchiveDays()
            print("date \(days)")
            days.updateValue(myDay, forKey: currentDay!.date)
            print("date \(days[currentDay!.date]?.gym)")
        DayMgmt.ArchiveDays(db: days)
        }else {
            UtilFun.simpleToast(title: "Missing calories", msg: "Enter calories", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        myPicker.dataSource = self
        myPicker.delegate = self
        aeroTxtFld.inputView = myPicker
        aeroTxtFld.delegate = self
        gymTxtFld.delegate = self
        gymTxtFld.inputView = myPicker
        
        gymImgVw.image = UIImage(named: currentDay?.gym ?? "non")
        aeroImgVw.image = UIImage(named: currentDay?.aerobics ?? "non2")
        calsTxtFld.text = "\(currentDay?.calories ?? 0)"
        aeroTxtFld.text = aeroData.key(from: currentDay?.aerobics ?? "non2")
        gymTxtFld.text = gymData.key(from: currentDay?.gym ?? "non")
        // Do any additional setup after loading the view.
    }
    
    func getKeyForValue (searchingValue: String, dict: [String:String]) -> String{
        print("name \(searchingValue)")
        let tempDict = dict.filter {$0.value == searchingValue}
        print("name arr \(tempDict)")
        let value = tempDict.keys.first!
        return value
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == aeroTxtFld {
            pickerData = Array(aeroData.keys)
            myPicker.reloadAllComponents()
            myPicker.tag = 1
        }else if textField == gymTxtFld {
            pickerData = Array(gymData.keys)
            myPicker.reloadAllComponents()
            myPicker.tag = 2
        }
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        return true
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let myKey = pickerData[row]
        if pickerView.tag == 1{
            aeroTxtFld.text = myKey
            aeroImgVw.image = UIImage(named: aeroData[myKey] ?? "non2")
            currentDay?.aerobics = aeroData[myKey] ?? "non2"
        }else if pickerView.tag == 2{
            gymTxtFld.text = myKey
            gymImgVw.image = UIImage(named: gymData[myKey] ?? "non")
            currentDay?.gym = gymData[myKey] ?? "non"
        }
         
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
