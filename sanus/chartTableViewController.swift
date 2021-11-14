//
//  chartTableViewController.swift
//  sanus
//
//  Created by aly hassan on 02/11/2021.
//

import UIKit

class chartTableViewController: UITableViewController {
    var myDataDic = [String : Day]()
    var maxDailyCal = 1800
    var myData = [Date]()
    var selectedDay : Day?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        myDataDic = DayMgmt.UnArchiveDays()
        myData = DayMgmt.prepareDataForChart(myDataDic: myDataDic)
        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {

        print("did appear")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateStr = DayMgmt.convDateToStr(date: myData[indexPath.row])
        print("myDataDic \(myDataDic)")
        let tempChartObj = myDataDic[dateStr]
        let cell = tableView.dequeueReusableCell(withIdentifier: "chartCell", for: indexPath) as! chartTableViewCell
        
        cell.dateAndCalsLbl.text = "\(tempChartObj?.date ?? "1 Nov 1974"):  \(tempChartObj?.calories ?? 0) kCal"
        let tempCals = tempChartObj?.calories ?? 0
        let progress = Float(tempCals / Double(maxDailyCal))
        print("progress \(progress)")
        if progress >= 1 {
            cell.myProgressBar.progressTintColor = .red
        }
        cell.myProgressBar.progress = Float(tempCals / 4000)
        let myImgGym = UIImage(named: tempChartObj?.gym ?? "non")
        cell.gymImg.image = myImgGym
        let myImgAero = UIImage(named: tempChartObj?.aerobics ?? "non2")
        cell.aeroImg.image = myImgAero
        
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
                   let key = myData[indexPath.row]
                   let keyStr = DayMgmt.convDateToStr(date: key)
                   myDataDic.removeValue(forKey: keyStr)
                   myData.remove(at: indexPath.row)
                   DayMgmt.ArchiveDays(db: myDataDic)
                   tableView.reloadData()
       
                   // handle delete (by removing the data from your array and updating the tableview)
               }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateStr = DayMgmt.convDateToStr(date: myData[indexPath.row])
        selectedDay =  myDataDic[dateStr]!
        performSegue(withIdentifier: "toChartDetail", sender: self)
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ChartDetailViewController
        vc.currentDay = selectedDay
        
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
