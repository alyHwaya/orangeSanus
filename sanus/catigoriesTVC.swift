//
//  searchableTableViewController.swift
//  newSanus
//
//  Created by aly hassan on 23/02/2021.
// catigoriesTVC

import UIKit

class catigoriesTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBAction func addBtnAct(_ sender: Any) {
        UtilFun.alertWithTextFld(title: "Add Catigory", msg: "Enter catigory name", BtnTitle: "Add", senderVC: self, completionHandler: {
            newCat in
//            print("All----\(newCat)")
            if !self.myDb.contains(newCat){
            if newCat != "All" && newCat != ""{
                self.myDb.append(newCat)
//                print("not All")
                UtilFun.saveCatigories(catigories: self.myDb)
                self.myTableView.reloadData()
            }else{
//                print("All")
            }
            }else{
                UtilFun.simpleAlertActionSheet(title: "Duplicate catigory", msg: "This catigory already exists!", sender: self)
            }
        })
       
    }
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var myDb = [String]()
    var filteredDb = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredDb.count
        }else{
        return myDb.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var object = String()
        if searchController.isActive && searchController.searchBar.text != ""{
            object = filteredDb[indexPath.row]
        }else{
            object = myDb[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        cell.textLabel?.text = object
        return cell
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterMyDb(filterStr: searchController.searchBar.text ?? "")
    }
    func filterMyDb(filterStr : String){
        filteredDb = myDb.filter({
            item in
            return item.lowercased().contains(filterStr.lowercased())
        })
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == UITableViewCell.EditingStyle.delete {
            //let chosenRecipe = recipesDict[recipesArr[indexPath.row]]
              if searchController.isActive && searchController.searchBar.text != ""{
                  if filteredDb[indexPath.row] != "All"{
                      let item = filteredDb[indexPath.row]
                      let mainDBIndex = myDb.firstIndex(of: item)!
                      myDb.remove(at: mainDBIndex)
                      filteredDb.remove(at: indexPath.row)
                      UtilFun.saveCatigories(catigories: self.myDb)
                      self.myTableView.reloadData()
                  }
                  
              }else{
                  if myDb[indexPath.row] != "All"{
                      myDb.remove(at: indexPath.row)
                      UtilFun.saveCatigories(catigories: self.myDb)
                      self.myTableView.reloadData()
                  }
                 
              }
          }
      }
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDb = UtilFun.getCatigories()
        myTableView.dataSource = self
        myTableView.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        myTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.lightGray
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
