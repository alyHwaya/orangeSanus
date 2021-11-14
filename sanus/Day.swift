//
//  Day.swift
//  sanus
//
//  Created by aly hassan on 03/11/2021.
//

import Foundation
import UIKit

class Day : Codable {
    var date = String()
    var calories = Double()
    var gym =  String()
    var aerobics = String()
    
    init (date: String, calories: Double, gym: String,  aerobics: String){
        self.date = date
        self.calories = calories
        self.gym = gym
        self.aerobics = aerobics
       
    }
}
