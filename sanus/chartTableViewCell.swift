//
//  chartTableViewCell.swift
//  sanus
//
//  Created by aly hassan on 02/11/2021.
//

import UIKit

class chartTableViewCell: UITableViewCell {

    @IBOutlet weak var myProgressBar: UIProgressView!
    @IBOutlet weak var dateAndCalsLbl: UILabel!
    @IBOutlet weak var gymImg: UIImageView!
    @IBOutlet weak var aeroImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
