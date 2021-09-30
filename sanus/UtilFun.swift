//
//  UtilFun.swift
//  sanus
//
//  Created by aly hassan on 27/09/2021.
//

import Foundation
import UIKit
class UtilFun{
    public static func convertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
}
    public static func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
    public static func Archive(foodsDb: [String : Food], fileName: String){
        let filePath = getFileUrl(fileName: fileName)
        let json = try? JSONEncoder().encode(foodsDb)
        do {
            try json!.write(to: filePath)
            print("done aly")
        } catch {
            print("Failed to write JSON data: \(error.localizedDescription)")
        }
    }
    public static func getFileUrl(fileName:String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let pathDirectory = paths[0]
        try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)
        let path = pathDirectory.appendingPathComponent(fileName)
        return path
    }
    
    public static func UnArchive(fromFileName: String)-> [String : Food]{
        let path = getFileUrl(fileName: fromFileName)
        //let jsonData = NSData(contentsOfMappedFile: path.path)
        var MyData = Data()
        var MyDict = [String : Food]()
        do{
            let myJsonData = try Data(contentsOf: path)
            MyData = myJsonData
        }catch{
            print("Failed to read JSON data: \(error.localizedDescription)")
        }
        print(MyData)
        // now decode the data to array
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([String : Food].self, from: MyData) {
            MyDict = decoded
        }
        // now reverse sort the array
        print(MyDict)
        return MyDict
    }
    public static    func makeActivityIndicator(sender: UIView)-> UIActivityIndicatorView{
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.backgroundColor = .lightGray
        activityIndicator.color = .orange
        
        sender.addSubview(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: sender.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: sender.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    public static func myAdjustForKeyboard(notification: Notification, myScrollView: UIScrollView, txtFieldOrViewRect: CGRect, view: UIView) {
        
        /*
         // 1-Add these to viewDidLoad
         
         (dont forget to make the viewcontroler a text field and view delegate and in here add self as delegate to the views
         
         let notificationCenter = NotificationCenter.default
         notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
         notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
         
         // 2- add this to viewControler
         @objc func adjustForKeyboard(notification: Notification) {
             UtilFun.myAdjustForKeyboard(notification: notification, myScrollView: myScrollView, txtFieldOrViewRect: currentTxtFieldRect, view: self.view)
         // 3- declair currentTxtFieldRect in the viewControler
         var currentTxtFieldRect = CGRect(x: 0, y: 0, width: 0, height: 0)
         
         // 4- add this for textField
         func textFieldDidBeginEditing(_ textField: UITextField) {
             currentTxtFieldRect = textField.frame
         }
         
         // 5- add this for textView
         func textViewDidBeginEditing(_ textView: UITextView) {
             currentTxtFieldRect = textView.frame
         }
         
         */
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            myScrollView.contentInset = .zero
        } else {
            myScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        myScrollView.scrollIndicatorInsets = myScrollView.contentInset

        
        myScrollView.scrollRectToVisible(txtFieldOrViewRect, animated: true)
    }
    
    public static func getCatigories() -> [String]{
        let defaults = UserDefaults.standard
        var catigories = [String]()
        if let catigoriesArr = defaults.value(forKey: "catigories"){
            catigories = catigoriesArr as! [String]
        }else{
            catigories = ["All", "Breakfast", "Lunch", "Dinner", "Snacks", "Drinks"]
        }
        return catigories
    }
    public static func saveCatigories(catigories: [String]){
        let defaults = UserDefaults.standard
        defaults.set(catigories, forKey: "catigories")
    }
    public static func alertWithTextFld(title: String, msg: String, BtnTitle: String, senderVC: UIViewController, completionHandler: @escaping ((String)->())) {
        var myTxt = UITextField()
        let myAlertContr = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//        myAlertContr.addTextField(configurationHandler: {tempTxtF in
//            tempTxtF.textAlignment = .center
//            tempTxtF.placeholder = "Date"
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd-MM-yyy"
//            tempTxtF.text = formatter.string(from: Date())
//
//        })
        myAlertContr.addTextField(configurationHandler: {tempTxtF in
            tempTxtF.textAlignment = .center
            tempTxtF.placeholder = "Catigorie"
            myTxt = tempTxtF
            //        self.caloriesTxtField.addTarget(self, action:  #selector(self.datePickerChanged(picker:)), for: .editingDidEnd)
        })
        myAlertContr.addAction(UIAlertAction(title: BtnTitle, style: .default, handler:  {
            _ in
            completionHandler(myTxt.text ?? "All")
        }))
        myAlertContr.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            _ in
            myAlertContr.dismiss(animated: true, completion: { print("kk")
            })
        }))
        senderVC.present(myAlertContr, animated: false, completion: nil)
        
    }
    
    public static func simpleToast(title: String, msg: String, sender:Any){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        (sender as AnyObject).present(alert, animated: true, completion: nil)
    }
    
    public static func simpleAlertActionSheet(title: String, msg: String, sender:Any){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        (sender as AnyObject).present(alert, animated: true, completion: nil)
    }

}


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideSideMenu(){
        
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
}
extension UIView {
func applyGradient(colours: [UIColor]) -> Void {
 let gradient: CAGradientLayer = CAGradientLayer()
 gradient.frame = self.bounds
 gradient.colors = colours.map { $0.cgColor }
 gradient.startPoint = CGPoint(x : 0.5, y : 0.0)
 gradient.endPoint = CGPoint(x :0.5, y: 1.0)
 self.layer.insertSublayer(gradient, at: 0)
 self.layer.sublayers![0].name = "gradient"
 }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}
extension UIImage {
    class func scaleImageWithDivisor(img: UIImage, divisor: CGFloat) -> UIImage {
        let size = CGSize(width: img.size.width/divisor, height: img.size.height/divisor)
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    class func scaleImage150x150(img: UIImage) -> UIImage {
        let size = CGSize(width: 150, height: 150)
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
extension UIView {
    var textFieldsInView: [UITextField] {
        return subviews
            .filter ({ !($0 is UITextField) })
            .reduce (( subviews.compactMap { $0 as? UITextField }), { summ, current in
                return summ + current.textFieldsInView
            })
    }
    var selectedTextField: UITextField? {
        return textFieldsInView.filter { $0.isFirstResponder }.first
    }
}
