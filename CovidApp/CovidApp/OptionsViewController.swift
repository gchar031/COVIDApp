//
//  OptionsViewController.swift
//  CovidApp
//
//  Created by green blue on 4/18/20.
//  Copyright © 2020 BowenWu. All rights reserved.
//

import UIKit
import CoreData


class OptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //SaveHospitals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func SaveHospitals(){
        guard let path = Bundle.main.path(forResource: "HospitalList", ofType: "json") else{ return }
        let url = URL(fileURLWithPath: path)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Hospitals", in: context)
        do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let list = json as? [String: Any] else { return }
            guard let list2 = list["features"] as? [Any] else { return }
            guard let hospitalList = list2 as? [[String: Any]] else { return }
            
            for hospital in hospitalList {
                guard let hospitalDic = hospital["attributes"] as? [String: Any] else { return }
                let newHosp = NSManagedObject(entity: entity!, insertInto: context)
                newHosp.setValue(hospitalDic["NAME"], forKey: "name")
                newHosp.setValue(hospitalDic["COUNTY"], forKey: "county")
                newHosp.setValue(hospitalDic["ADDRESS"], forKey: "address")
                newHosp.setValue(hospitalDic["BEDS"] as? Int32, forKey: "beds")
                newHosp.setValue(hospitalDic["TELEPHONE"], forKey: "phone")
                newHosp.setValue(hospitalDic["WEBSITE"], forKey: "website")
                newHosp.setValue(hospitalDic["CITY"], forKey: "city")
                newHosp.setValue(hospitalDic["STATE"], forKey: "state")
                newHosp.setValue(hospitalDic["ZIP"], forKey: "zip")
            }
            try context.save()
        }
        catch{
            print(error)
        }
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
