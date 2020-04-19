//
//  TestResultViewController.swift
//  CovidApp
//
//  Created by green blue on 4/18/20.
//  Copyright © 2020 BowenWu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TestResultViewController: UIViewController {
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblPos: UILabel!
    @IBOutlet weak var lblNeg: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDeath: UILabel!
    
    var count = 0
    let Central = ViewControllerCommunication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SaveResults()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func SaveResults(){
        guard let path = Bundle.main.path(forResource: "daily", ofType: "json") else{ return }
        let url = URL(fileURLWithPath: path)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TestResult", in: context)
        do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let list = json as? [[String: Any]] else { return }
            
            for data in list{
                if data["date"] as? Int == 20200417{
                    let newResult = NSManagedObject(entity: entity!, insertInto: context)
                    newResult.setValue(data["state"] as? String, forKey: "state")
                    newResult.setValue(data["recovered"] as? Int32, forKey: "recovered")
                    newResult.setValue(data["negative"] as? Int32, forKey: "negative")
                    newResult.setValue(data["positive"] as? Int32, forKey: "positive")
                    newResult.setValue(data["total"] as? Int32, forKey: "total")
                    newResult.setValue(data["death"] as? Int32, forKey: "deaths")
                }
            }
        try context.save()
        }
        catch{
            print(error)
        }
    }
    
    private func LoadCase(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TestResult")
        request.returnsObjectsAsFaults=false
        request.predicate =  NSPredicate(format: "state == %@", Central.getState())
        
        do{
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject]{

                lblState.text = data.value(forKey: "state") as? String
                lblNeg.text = String(data.value(forKey: "negative") as! Int)
                lblPos.text = String(data.value(forKey: "positive") as! Int)
                lblTotal.text = String(data.value(forKey: "total") as! Int)
                lblDeath.text = String(data.value(forKey: "deaths") as! Int)
            }

        }
        catch{
            print("Failed to request data")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LoadCase()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
