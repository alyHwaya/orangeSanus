//
//  Food.swift
//  sanus
//
//  Created by aly hassan on 27/09/2021.
//

import Foundation
import UIKit

class Food : Codable {
    var name = String()
    var calories = Double()
    var unit =  String()
    var servingSize = Double()
    var recipe = String()
    var category = String()
    var isIngredient = Bool()
    var image = String()
    var taken = Int()
    var isSelected = Bool()
    init (name: String, calories: Double, unit: String, servingSize: Double, recipe: String, catigory:String, ingredient: Bool, image:String, taken: Int, selected: Bool){
        self.name = name
        self.calories = calories
        self.unit = unit
        self.servingSize = servingSize
        self.recipe = recipe
        self.category = catigory
        self.isIngredient = ingredient
        self.image = image
        self.taken = taken
        self.isSelected = selected
    }
}
