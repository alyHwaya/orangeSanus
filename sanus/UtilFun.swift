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
