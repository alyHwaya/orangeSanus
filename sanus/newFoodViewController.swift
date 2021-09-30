//
//  newFoodViewController.swift
//  myDiet
//
//  Created by Aly Hassan on 11/4/19.
//  Copyright © 2019 Aly Hassan. All rights reserved.
//

import UIKit
import Vision

class newFoodViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate{
    var foodsDb = [String : Food]()
    var currentFoodType = Food(name: "", calories: 1, unit: "", servingSize: 1, recipe: "Ingredients", catigory: "All", ingredient: false, image: "", taken: 1, selected: false)
    var emptyFoodType = Food(name: "", calories: 1, unit: "", servingSize: 1, recipe: "Ingredients", catigory: "All", ingredient: false, image: "", taken: 1, selected: false)
    var recognizedTextArr : [String] = ["----"]
    var currentTxtFieldRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recognizedTextArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recognizedTextArr[row]
    }
    let datePicker = UIPickerView()
    
    var pickerType = String()
    @IBAction func backBtn(_ sender: Any) {
        let myImg = UIImage(named: "lunch2.png")
        let imgStr = UtilFun.convertImageToBase64String(img: myImg!)
        currentFoodType = Food(name: "", calories: 1, unit: "", servingSize: 1, recipe: "Ingredients", catigory: "All", ingredient: false, image: imgStr, taken: 1, selected: false)
    }
    var myPicker = UIImagePickerController()
    
    @IBAction func saveBtn(_ sender: Any) {
        let myValueStr = NSString(string: foodCalTxt.text ?? "0.0")
        let myTakenStr = NSString(string: servingSizeTxt.text ?? "1.0")
        let myValue = myValueStr.doubleValue
        let myTaken = myTakenStr.doubleValue
//        let myAmountUsed = currentFoodType.taken
        let theScaledImage = UIImage.scaleImage150x150(img: pickedImage.image!)
        let myFoodType: Food = Food(name: foodNameTxt.text ?? "Food", calories: myValue, unit: foodUnitTxt.text ?? "Unit", servingSize: myTaken, recipe: recipeTxt.text, catigory: catTxt.text ?? "All", ingredient: false, image: UtilFun.convertImageToBase64String(img: theScaledImage), taken: currentFoodType.taken, selected: false)
        foodsDb.updateValue(myFoodType, forKey: myFoodType.name)
        if myPicker.sourceType == .camera{
            UIImageWriteToSavedPhotosAlbum(pickedImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            print("Camera")
        }else{
            let ac = UIAlertController(title: "Saved!", message: "Your Food  has been saved.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            print("Not camera")
        }
        UtilFun.Archive(foodsDb: foodsDb, fileName: "foodList.aly")
        let myImg = UIImage(named: "lunch2.png")
        let imgStr = UtilFun.convertImageToBase64String(img: myImg!)
        emptyFoodType.image = imgStr
        currentFoodType = emptyFoodType
        foodCalTxt.text = "\(currentFoodType.calories)"
        foodNameTxt.text = currentFoodType.name
        foodUnitTxt.text = currentFoodType.unit
        servingSizeTxt.text = "\(currentFoodType.taken)"
        recipeTxt.text = currentFoodType.recipe
        // amountUsed.text = "\(currentFoodType.taken)"
        catTxt.text = "ALL ITEMS"
        pickedImage.image = UtilFun.convertBase64StringToImage(imageBase64String: currentFoodType.image)
        addGradient()
        
//        var myFoodType: foodType = foodType(name: foodNameTxt.text ?? "Food", checked: currentFoodType.checked, unit: foodUnitTxt.text ?? "Unit", value: myValue, takenUnit: myTaken, FoodImage: theScaledImage.pngData()!)
//        myFoodType.taken = myAmountUsed
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
          print("###########%%%%%%%%%%")
              if textField.restorationIdentifier == "catName"{
                  print("###########%%%%%%%%%%")
                  catTxt.inputView = datePicker
                  pickerType = "catName"
                  recognizedTextArr = UtilFun.getCatigories()
              }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTxtFieldRect = textField.frame
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        currentTxtFieldRect = textView.frame
        print("=========================\(currentTxtFieldRect.height)")
        
    }

    @IBOutlet var catTxt: UITextField!
    
    @IBOutlet var pageFoodTitle: UILabel!
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your Food  has been saved.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
    @IBAction func ocrBtnCal(_ sender: Any) {
        foodCalTxt.resignFirstResponder()
        foodCalTxt.inputView = datePicker
        foodCalTxt.becomeFirstResponder()
        pickerType = "ocrData"
        ocrAlert()
        
    }
    
    @IBAction func ocrBtnName(_ sender: Any) {
        foodNameTxt.resignFirstResponder()
        foodNameTxt.inputView = datePicker
        foodNameTxt.becomeFirstResponder()
        pickerType = "ocrName"
        ocrAlert()
 
    }
    func ocrAlert(){
        let ac = UIAlertController(title: "Nutrition data", message: "Read the nutrition data from a photo or shoot it using your camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            _ in
            print(self.pickerType)
            self.pickImageUsing(sourceType: .camera)
        }))
        ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: {
            _ in
            print(self.pickerType)
            self.pickImageUsing(sourceType: .photoLibrary)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func ingSwitchAct(_ sender: Any) {
    }
    
    @IBOutlet var ingSwitchOutlet: UISwitch!
    
    
    @IBOutlet weak var vwOfScrollVw: UIView!
    @IBOutlet weak var recipeTxt: UITextView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var recipeBtnOut: UIButton!
    @IBOutlet weak var ingredientLbl: UILabel!
    @IBOutlet weak var servingSizeLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var calPerUnitLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var saveBtnOut: UIButton!
    @IBOutlet var servingSizeTxt: UITextField!
    @IBOutlet var foodNameTxt: UITextField!
    @IBOutlet var foodCalTxt: UITextField!
    @IBOutlet var foodUnitTxt: UITextField!
    //@IBOutlet var amountUsed: UITextField!
    @IBAction func imagePicking(_ sender: Any) {
        pickerType = "camera"
        pickImageUsing(sourceType: .camera)
    }
    @IBAction func imagePickingAssets(_ sender: Any) {
        pickerType = "assets"
        pickImageUsing(sourceType: .photoLibrary)
    }
    func pickImageUsing(sourceType: UIImagePickerController.SourceType){
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
       @IBAction func recipeBtn(_ sender: Any) {
  
        }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        if currentFoodType.name == "" {
            let myImg = UIImage(named: "lunch2.png")
            let imgStr = UtilFun.convertImageToBase64String(img: myImg!)
            emptyFoodType = Food(name: "", calories: 1, unit: "", servingSize: 1, recipe: "Ingredients", catigory: "All", ingredient: false, image: imgStr, taken: 1, selected: false)
            currentFoodType = emptyFoodType
        }
        pageFoodTitle.text = currentFoodType.name
        hideKeyboardWhenTappedAround()
        datePicker.delegate = self
        datePicker.dataSource = self
        catTxt.delegate = self
        servingSizeTxt.delegate = self
        foodCalTxt.delegate = self
        foodNameTxt.delegate = self
        foodUnitTxt.delegate = self
        recipeTxt.delegate = self
        
        let toolbar = UIToolbar()
        let toolbarCat = UIToolbar()
        toolbarCat.sizeToFit()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKB));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil);
        let typeButton = UIBarButtonItem(title: "Type", style: .plain, target: self, action: #selector(convertPickerToKB));
        
        toolbar.setItems([typeButton, spaceButton, doneButton], animated: false)
        foodUnitTxt.inputAccessoryView = toolbar
        foodCalTxt.inputAccessoryView = toolbar
        foodNameTxt.inputAccessoryView = toolbar
        servingSizeTxt.inputAccessoryView = toolbar
        
        
        toolbarCat.setItems([spaceButton, doneButton], animated: false)
        catTxt.inputAccessoryView = toolbarCat
        // Do any additional setup after loading the view.
        recipeTxt.text = currentFoodType.recipe
        foodCalTxt.text = "\(currentFoodType.calories)"
        foodNameTxt.text = currentFoodType.name
        foodUnitTxt.text = currentFoodType.unit
        servingSizeTxt.text = "\(currentFoodType.taken)"
        catTxt.text = currentFoodType.category
        //amountUsed.text = "\(currentFoodType.taken)"
        pickedImage.image = UtilFun.convertBase64StringToImage(imageBase64String: currentFoodType.image)
        foodsDb = UtilFun.UnArchive(fromFileName: "foodList.aly")
        addGradient()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        UtilFun.myAdjustForKeyboard(notification: notification, myScrollView: myScrollView, txtFieldOrViewRect: currentTxtFieldRect, view: self.view)
//        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//
//        let keyboardScreenEndFrame = keyboardValue.cgRectValue
//        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            myScrollView.contentInset = .zero
//        } else {
//            myScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
//        }
//
//        myScrollView.scrollIndicatorInsets = myScrollView.contentInset
//
//
//        myScrollView.scrollRectToVisible(currentTxtFieldRect, animated: true)
    }
    
    @objc func dismissKB(){
        self.view.endEditing(true)
    }
    

    
    @IBOutlet var pickedImage: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if picker.sourceType == .camera{
            myPicker.sourceType = .camera
        }else if picker.sourceType == .photoLibrary{
            myPicker.sourceType = .photoLibrary
        }else if picker.sourceType == .savedPhotosAlbum{
            myPicker.sourceType = .savedPhotosAlbum
        }
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // print out the image size as a test
        print(image.size)
        
        if pickerType == "ocrName"{
            print(pickerType)
            let myString = OCR(image: image).joined(separator: "\n")
            foodNameTxt.text = myString
        }else if pickerType == "ocrData"{
            print(pickerType)
            let myString = OCR(image: image).joined(separator: "\n")
            foodCalTxt.text = myString
        }else {
            print(pickerType)
            pickedImage.image = image
            addGradient()
            
        }
        
        
        
        //pickedImage.image = UIImage.scaleImage150x150(img: image)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    
   
    
    func OCR(image: UIImage)-> [String]{
        recognizedTextArr.removeAll()
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                fatalError("Received invalid observations")
            }
            for observation in observations {
                guard let bestCandidate = observation.topCandidates(1).first else {
                    print("No Data")
                    continue
                }
                print("Found this candidate: \(bestCandidate.string)")
                self.recognizedTextArr.append(bestCandidate.string)
                print(self.recognizedTextArr)
            }
        }
        let requests = [request]
        
        guard let img = image.cgImage else {
            fatalError("Missing image to scan")
        }
        
        let handler = VNImageRequestHandler(cgImage: img, options: [:])
        try? handler.perform(requests)
        

        var tempArr = [String]()
        let caloriesNamesArr = ["kCal", "calories", "calory", "Calory", "Calories", "cal", "Cal"]
        
        for  (index, element) in recognizedTextArr.enumerated(){
            var isCalories = false
            for aName in caloriesNamesArr {
                if element.contains(aName) {
                    isCalories = true
                }
            }
            if isCalories{
                var calValStr = String()
//                if element.contains(" "){
//                    calValStr = recognizedTextArr[index]
//                }else{
//                    calValStr = recognizedTextArr[index + 1]
//                }
                print(index)
                calValStr = recognizedTextArr[index]
//                var calValStrBefore = String()
//                if index >= 1{
//                    calValStrBefore = recognizedTextArr[index - 1]
//                }else {
//                    calValStrBefore = "---"
//                }
                let resultNumericAfter = calValStr.filter("0123456789.".contains)
//                let resultNumericbefore = calValStrBefore.filter("0123456789.".contains)
                tempArr.append(resultNumericAfter)
                //tempArr = [resultNumericAfter]
                //recognizedTextArr = tempArr
            }
        }
        if pickerType == "ocrData"{
            recognizedTextArr = tempArr
        }
        if tempArr.count < 1 && pickerType == "ocrData"{
            recognizedTextArr.removeAll()
        }
        return recognizedTextArr
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerType == "ocrName"{
            if recognizedTextArr.count >= 1{
            foodNameTxt.text = recognizedTextArr[row]
            }
        }else if pickerType == "ocrData"{
            if recognizedTextArr.count >= 1{
            foodCalTxt.text = recognizedTextArr[row]
            }
        }else if pickerType == "catName" {
            if recognizedTextArr.count >= 1{
            catTxt.text = recognizedTextArr[row]
            }
        }
    }
    
    
    @objc func donedatePicker(){
        self.view.endEditing(true)
    }
    @objc func convertPickerToKB(){
        if pickerType == "ocrName"{
            foodNameTxt.resignFirstResponder()
            foodNameTxt.inputView = nil
            foodNameTxt.becomeFirstResponder()
        }else if pickerType == "ocrData"{
            foodCalTxt.resignFirstResponder()
            foodCalTxt.inputView = nil
            foodCalTxt.becomeFirstResponder()
        }
    }
    func addGradient(){
        self.view.backgroundColor = .white
        let mycolor = pickedImage.image?.averageColor ?? .green
        var secondColor = UIColor(ciColor: .white)
        if mycolor.isLight{
            secondColor = .gray
            saveBtnOut.setTitleColor(.black, for: .normal)
            pageFoodTitle.textColor = .black
            nameLbl.textColor = .white
            calPerUnitLbl.textColor = .white
            unitLbl.textColor = .white
            servingSizeLbl.textColor = .white
            ingredientLbl.textColor = .white
            recipeBtnOut.setTitleColor(.white, for: .normal)
            
        }else{
            saveBtnOut.setTitleColor(.white, for: .normal)
            pageFoodTitle.textColor = .white
            nameLbl.textColor = .white
            calPerUnitLbl.textColor = .white
            unitLbl.textColor = .white
            servingSizeLbl.textColor = .white
            ingredientLbl.textColor = .white
            recipeBtnOut.setTitleColor(.white, for: .normal)
        }
        let sublayers = self.view.layer.sublayers![0].name
        if sublayers == "gradient"{
            self.view.layer.sublayers![0].removeFromSuperlayer()
        }
        self.view.applyGradient(colours: [mycolor, .black])
        saveBtnOut.backgroundColor = mycolor
    }
}

