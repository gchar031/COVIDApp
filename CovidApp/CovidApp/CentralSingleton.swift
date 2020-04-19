//
//  CentralSingleton.swift
//  CovidApp
//
//  Created by green blue on 4/15/20.
//  Copyright © 2020 BowenWu. All rights reserved.
//

import Foundation

final class ViewControllerCommunication {
    
    static let shared = ViewControllerCommunication()
    let States:[String: String] = ["AL": "Alabama", "AK": "Alaska", "AZ": "Arizona", "AR": "Arkansas", "CA": "California", "CO": "Calorado", "CT": "Connecticut", "DE":"Delaware", "FL": "Florida", "GA": "Georgia", "HI": "Hawaii", "ID": "Idaho", "IL": "Illinois", "IN": "Indiana", "IA": "Iowa", "KS": "Kansas", "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine", "MD": "Maryland", "MA": "Massachusetts", "MI": "Michigan", "MN": "Minnesota", "MS": "Mississippi", "MO": "Missouri", "MT": "Montana", "NE": "Nebraska", "NV": "Nevada", "NH": "New Hampshire", "NJ": "New Jersey", "NM": "New Mexico", "NY": "New York", "NC": "North Carolina", "ND": "North Dakota", "OH": "Ohio", "OK": "Oklahoma", "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode Island", "SC": "South Carolina", "SD": "South Dakota", "TN": "Tennessee", "TX": "Texas", "UT": "Utah", "VT": "Vermont", "VA": "Virginia", "WA": "Washington", "WV": "West Virginia", "WI": "Wisconsin", "WY": "Wyoming"]
    private var selectedState = ""
    private var selectedCounty = ""
    private var selectedHosp = ""

    func stateSelect(state: String){
        for item in States {
            if item.value == state {
                selectedState = item.key
            }
        }
    }
    
    func countySelect(county: String){
        selectedCounty = county
    }
    
    func hospSelect(hospital: String){
        selectedHosp = hospital
    }
    
    func getState() -> String{
        return selectedState
    }
    
    func getCounty() -> String{
        return selectedCounty
    }
    
    func getHosp() -> String {
        return selectedHosp
    }
}
