//
//  CountyListViewController.swift
//  CovidGroupProject
//
//  Created by Student on 4/13/20.
//  Copyright © 2020 jgonz956. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CountyListViewController: UITableViewController {
    
    let Central = ViewControllerCommunication.shared
    var countyList = [String]()
    var filteredCountyList = [String]()
    var displayList = [String]()
    
    @IBOutlet var searchBar: UISearchBar!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSearchResults()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSearchResults), userInfo: nil, repeats: true)
        //SaveCounty()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    private func SaveCounty(){
        guard let path = Bundle.main.path(forResource: "HospitalList", ofType: "json") else{ return }
        let url = URL(fileURLWithPath: path)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "County", in: context)
        do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let list = json as? [String: Any] else { return }
            guard let list2 = list["features"] as? [Any] else { return }
            guard let countyList = list2 as? [[String: Any]] else { return }

            for county in countyList {
                guard let countyDic = county["attributes"] as? [String: Any] else { return }
                let newCounty = NSManagedObject(entity: entity!, insertInto: context)
                newCounty.setValue(countyDic["COUNTY"], forKey: "name")
                newCounty.setValue(countyDic["STATE"], forKey: "state")
                newCounty.setValue(countyDic["NAME"], forKey: "hospitalName")
            }
            try context.save()
        }
        catch{
            print(error)
        }
    }
    
    private func LoadCounty(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "County")
        request.returnsObjectsAsFaults=false
        request.predicate =  NSPredicate(format: "state == %@", Central.getState())
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if !countyList.contains(data.value(forKey: "name") as! String){
                    countyList.append(data.value(forKey:"name") as! String)
                }
            }
        }
        catch{
            print("Failed to request data")
        }
        
    }
    
    
    @objc func updateSearchResults(){
        displayList.removeAll()
        if(!isSearchBarEmpty){
            filterContentsForSearchText(searchBar.text!)
            for county in filteredCountyList{
                displayList.append(county)
            }
        }
        else{
            for county in countyList{
                    displayList.append(county)
            }
        }
        tableView.reloadData()
    }
    
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func filterContentsForSearchText(_ searchText: String){
        filteredCountyList.removeAll()
        for county in countyList{
            if(county.lowercased().contains(searchText.lowercased())){
                filteredCountyList.append(county)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LoadCounty()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Fetch
        let item = displayList[indexPath.row]
        // Configure Cell
        cell.textLabel?.text = item
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        Central.countySelect(county: (selectedCell.textLabel?.text)!)
    }
    
}
