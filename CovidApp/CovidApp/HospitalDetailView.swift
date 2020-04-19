//
//  ViewController.swift
//  TeamProjectApp
//
//  Created by Sarah C on 4/16/20.
//  Copyright © 2020 FIU. All rights reserved.
//

import UIKit
import CoreData

class HospitalDetailView: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    @IBOutlet weak var lblWeb: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblBeds: UILabel!
    
    var central = ViewControllerCommunication.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func displayHospInfo(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Hospitals")
        request.returnsObjectsAsFaults=false
        request.predicate = NSPredicate(format: "name == %@", central.getHosp())
        
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                lblName.text = data.value(forKey: "name") as? String
                lblAddress.text = data.value(forKey: "address") as? String
                lblCity.text = data.value(forKey: "city") as? String
                lblState.text = data.value(forKey: "state") as? String
                lblZip.text = data.value(forKey: "zip") as? String
                lblWeb.text = data.value(forKey: "website") as? String
                lblPhone.text = data.value(forKey: "phone") as? String
                if data.value(forKey: "beds") as! Int == -999{
                    lblBeds.text = "Unavailable"
                }
                else{
                    lblBeds.text = String(data.value(forKey: "beds") as! Int)
                }
            }
        }
        catch{
            print("Failed to request data")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        displayHospInfo()
    }
}

