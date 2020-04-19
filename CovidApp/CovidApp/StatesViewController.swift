//
//  ViewController.swift
//  CovidGroupProject
//
//  Created by Student on 4/9/20.
//  Copyright © 2020 jgonz956. All rights reserved.
//

import UIKit
import CoreData

class StatesViewController: UITableViewController {
    var stateList = [String]()
    var filteredStateList = [String]()
    var displayList = [String]()
    
    @IBOutlet var searchBar: UISearchBar!
    var timer = Timer()

    let central = ViewControllerCommunication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSearchResults()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSearchResults), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func updateSearchResults(){
        displayList.removeAll()
        if(!isSearchBarEmpty){
            filterContentsForSearchText(searchBar.text!)
            for state in filteredStateList{
                displayList.append(state)
            }
        }
        else{
            for state in central.States.values{
                displayList.append(state)
            }
        }
        tableView.reloadData()
    }
    
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func filterContentsForSearchText(_ searchText: String){
        filteredStateList.removeAll()
        for state in central.States.values{
            if(state.lowercased().contains(searchText.lowercased())){
                filteredStateList.append(state)
            }
        }
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        displayList = displayList.sorted(by: {$0 < $1})
        // Fetch
        let item = displayList[indexPath.row]

        // Configure Cell
        cell.textLabel?.text = item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        central.stateSelect(state: (selectedCell.textLabel?.text)!)
    }
    
}

