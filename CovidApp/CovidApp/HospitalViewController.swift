//
//  HospitalViewController.swift
//  CovidGroupProject
//
//  Created by Sarah C on 4/14/20.
//  Copyright © 2020 jgonz956. All rights reserved.
//
import UIKit
import CoreData
class HospitalViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    

    let Central = ViewControllerCommunication.shared
    var hospList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func LoadHosp(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Hospitals")
        request.returnsObjectsAsFaults=false
        let firstPredicate = NSPredicate(format: "state == %@", Central.getState())
        let secondPredicate = NSPredicate(format: "county == %@", Central.getCounty())
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [firstPredicate, secondPredicate])
        request.predicate = compoundPredicate
        
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                hospList.append(data.value(forKey: "name") as! String)
            }
        }
        catch{
            print("Failed to request data")
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        LoadHosp()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hospCell", for: indexPath)
        cell.textLabel?.text = hospList[indexPath.row]
         //configure cell
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellSelected = tableView.cellForRow(at: indexPath) as! UITableViewCell
        Central.hospSelect(hospital: (cellSelected.textLabel?.text)!)
    }
    
}


