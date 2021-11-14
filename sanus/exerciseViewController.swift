//
//  exerciseViewController.swift
//  sanus
//
//  Created by aly hassan on 02/11/2021.
//

import UIKit

class exerciseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let myData = [ "non" ,"arm", "back", "bb", "chest", "ct", "legs", "shoulder", "abs", "all"]
    let aeroData = ["run2", "walk2", "cycle2", "non2" ]
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var aeroVollectionView: UICollectionView!
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == aeroVollectionView{
            return aeroData.count
        }else{
        return myData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "sportsCell", for: indexPath) as! sportsCollectionViewCell
        if collectionView == aeroVollectionView{
            cell.image.image = UIImage(named: aeroData[indexPath.row])
        }else{
        cell.image.image = UIImage(named: myData[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let yourWidth = collectionView.bounds.width/3.0
        let yourWidth = 100
        let yourHeight = 150

        return CGSize(width: yourWidth, height: yourHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currDay = DayMgmt.getCurrentDay()
        var tempData = [String]()
        if collectionView == aeroVollectionView{
            tempData = aeroData
        }else{
            tempData = myData
        }
        currDay.date = DayMgmt.getCurrDateStr()
        var msgVar = ""
        switch tempData[indexPath.row]{
            // let myData = [ "non" ,"arm", "back","bb","chest","ct","legs","shoulder","abs"]
        case "abs":
            msgVar = "Abdomen muscles"
            currDay.gym = tempData[indexPath.row]
        case "arm":
            msgVar = "Upper limb muscles"
            currDay.gym = tempData[indexPath.row]
        case "back":
            msgVar = "Back muscles"
            currDay.gym = tempData[indexPath.row]
        case "bb":
            msgVar = "Back and Biceps muscles"
            currDay.gym = tempData[indexPath.row]
        case "chest":
            msgVar = "Chest muscles"
            currDay.gym = tempData[indexPath.row]
        case "ct":
            msgVar = "Chest and Triceps muscles"
            currDay.gym = tempData[indexPath.row]
        case "legs":
            msgVar = "Lower limbs muscles"
            currDay.gym = tempData[indexPath.row]
        case "shoulder":
            msgVar = "Shoulder muscles"
            currDay.gym = tempData[indexPath.row]
        case "all":
            msgVar = "General muscles"
            currDay.gym = tempData[indexPath.row]
        case "run2":
            msgVar = "Running or Jogging activity"
            currDay.aerobics = tempData[indexPath.row]
        case "walk2":
            msgVar = "Walking activity"
            currDay.aerobics = tempData[indexPath.row]
        case "cycle2":
            msgVar = "Cycling activity"
            currDay.aerobics = tempData[indexPath.row]
        case "non2":
            msgVar = "Resting"
            currDay.aerobics = tempData[indexPath.row]
            
        default:
            msgVar = "Non"
        }
        UtilFun.simpleToast(title: msgVar, msg: "Selected", sender: self)
        DayMgmt.saveCurrDay(day: currDay)
//        print("****Selected \(msgVar)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        aeroVollectionView.dataSource = self
        aeroVollectionView.delegate = self
        // Do any additional setup after loading the view.
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
