//
//  dailyCell.swift
//  sanus
//
//  Created by aly hassan on 27/09/2021.
//

import UIKit

class dailyCell: UITableViewCell {

    @IBOutlet weak var minusBtnOut: UIButton!
    @IBOutlet weak var plusBtnOut: UIButton!
    @IBAction func plusBtnAct(_ sender: Any) {
    }
    @IBOutlet weak var takenAmountLbl: UILabel!
    @IBOutlet weak var usedCalLbl: UILabel!
    @IBOutlet weak var calUnitLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBAction func selectedBtnAct(_ sender: Any) {
    }
    @IBOutlet weak var selectedBtnOut: UIButton!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
