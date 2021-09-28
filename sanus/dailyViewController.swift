//
//  dailyViewController.swift
//  sanus
//
//  Created by aly hassan on 27/09/2021.
//

// "foodList.aly"
import UIKit

class dailyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate {
    @IBOutlet weak var percentageLbl: UILabel!
    var filteredDb = [String : Food]()
    var fullDb = [String : Food]()
   
    let mySearchController = UISearchController(searchResultsController: nil)
    
    func updateSearchResults(for searchController: UISearchController) {
        print(fullDb)
        if searchController.searchBar.text != ""{
            foodsDb = fullDb
            filteredDb = foodsDb.filter( { $0.key.range(of: searchController.searchBar.text ?? "", options: .caseInsensitive) != nil})
        foodsDb = filteredDb
        myTableView.reloadData()
        print(filteredDb)
        }else {foodsDb = fullDb
            myTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodsDb.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempArr = Array(foodsDb.keys)
        let FoodName = tempArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell") as! dailyCell
        cell.selectedBtnOut.tag = indexPath.row
        cell.plusBtnOut.tag = indexPath.row
        cell.minusBtnOut.tag = indexPath.row
        cell.selectedBtnOut.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        cell.plusBtnOut.addTarget(self, action: #selector(buttonPlus), for: .touchUpInside)
        cell.minusBtnOut.addTarget(self, action: #selector(buttonMinus), for: .touchUpInside)
        let str = foodsDb[FoodName]?.image
        let img = UtilFun.convertBase64StringToImage(imageBase64String: str!)
        cell.myImage.image = img
        cell.cellName.text = foodsDb[FoodName]?.name
        if foodsDb[FoodName]!.isSelected{
            cell.selectedBtnOut.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }else{
            cell.selectedBtnOut.setImage(UIImage(systemName: "square"), for: .normal)
        }
        cell.unitLbl.text = foodsDb[FoodName]?.unit
        cell.calUnitLbl.text = "\(foodsDb[FoodName]!.calories)"
        cell.takenAmountLbl.text = "\(foodsDb[FoodName]!.taken)"
        return cell
    }
    
    @objc func buttonSelected(sender: UIButton){
        print(sender.tag)
        let tempArr = Array(foodsDb.keys)
        let FoodName = tempArr[sender.tag]
        foodsDb[FoodName]?.isSelected.toggle()
        fullDb[FoodName]?.isSelected = foodsDb[FoodName]!.isSelected
        calculateTotalCalories()
        myTableView.reloadData()
    }
    @objc func buttonPlus(sender: UIButton){
        print(sender.tag)
        let tempArr = Array(foodsDb.keys)
        let FoodName = tempArr[sender.tag]
        var amount = foodsDb[FoodName]!.taken
        amount += 1
        foodsDb[FoodName]?.taken = amount
        fullDb[FoodName]?.taken = amount
        calculateTotalCalories()
        myTableView.reloadData()
    }
    
    @objc func buttonMinus(sender: UIButton){
        print(sender.tag)
        let tempArr = Array(foodsDb.keys)
        let FoodName = tempArr[sender.tag]
        var amount = foodsDb[FoodName]!.taken
        amount -= 1
        if amount < 0 {
            amount = 0
        }
        foodsDb[FoodName]!.taken = amount
        fullDb[FoodName]!.taken = amount
        calculateTotalCalories()
        myTableView.reloadData()
    }
    
    var totalCal = 0.0
    var foodsDb = [String : Food]()
    var maxDailyCal = 1800
    
    @IBOutlet weak var totalCaloriesOut: UILabel!
    @IBOutlet weak var myProgressBar: UIProgressView!
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        mySearchController.delegate = self
        let myImg = UIImage(named: "lunch2.png")
        let imgStr = UtilFun.convertImageToBase64String(img: myImg!)
        print(imgStr)
        let tempFood1 = Food(name: "test1", calories: 100, unit: "test1", servingSize: 1, recipe: "recipeeee", catigory: "fast food", ingredient: false, image: imgStr, taken: 1, selected: false)
        let tempFood2 = Food(name: "test2", calories: 300, unit: "test1", servingSize: 1, recipe: "recipeeee", catigory: "fast food", ingredient: false, image: imgStr, taken: 1, selected: false)
        let tempFood3 = Food(name: "test3", calories: 500, unit: "test1", servingSize: 1, recipe: "recipeeee", catigory: "fast food", ingredient: false, image: imgStr, taken: 1, selected: false)
        foodsDb = UtilFun.UnArchive(fromFileName: "foodList.aly")
        if foodsDb.isEmpty{
            foodsDb = [tempFood1.name : tempFood1,tempFood2.name :tempFood2,tempFood3.name : tempFood3]
        }
        fullDb = foodsDb
        calculateTotalCalories()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        fullDb = foodsDb
        calculateTotalCalories()
    }
    
    func calculateTotalCalories(){
        
        totalCal = 0.0
        for aFoodDic in fullDb{
            let aFood = aFoodDic.value
            if aFood.isSelected{
            let caloriesPerFood = Double(aFood.taken) * aFood.calories
            totalCal = totalCal + caloriesPerFood
            }
        }
        totalCaloriesOut.text = "\(totalCal)"
        let progress = Float(totalCal/3000)
        let percentage = Double(totalCal * 100/Double(maxDailyCal))
        let percentageStr = String(format: "%.1f", percentage)
        percentageLbl.text = "\(percentageStr)%"
        myProgressBar.progress = progress
        if totalCal > Double(maxDailyCal) {
            myProgressBar.tintColor = UIColor.red
        }else {
            myProgressBar.tintColor = UIColor.systemGreen
        }
        UtilFun.Archive(foodsDb: fullDb, fileName: "foodList.aly")
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
