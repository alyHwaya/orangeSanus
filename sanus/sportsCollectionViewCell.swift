//
//  sportsCollectionViewCell.swift
//  sanus
//
//  Created by aly hassan on 03/11/2021.
//

import UIKit

class sportsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    override var isSelected: Bool {
           didSet {
               contentView.backgroundColor = isSelected ? .lightGray : .white
           }
       }
}
