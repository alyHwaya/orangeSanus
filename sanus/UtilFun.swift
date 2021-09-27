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
    
    public static func Archive(foodsDb: [Food], fileName: String){
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
    
    public static func UnArchive(fromFileName: String)-> [Food]{
        let path = getFileUrl(fileName: fromFileName)
        //let jsonData = NSData(contentsOfMappedFile: path.path)
        var MyData = Data()
        var MyDict = [Food]()
        do{
            let myJsonData = try Data(contentsOf: path)
            MyData = myJsonData
        }catch{
            print("Failed to read JSON data: \(error.localizedDescription)")
        }
        print(MyData)
        // now decode the data to array
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Food].self, from: MyData) {
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
