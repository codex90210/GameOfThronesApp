//
//  houseCustomCell.swift
//  GameOfThronesApp
//
//  Created by David Mompoint on 10/21/21.
//

import Foundation
import UIKit

class houseCustomCell: UITableViewCell {
    
    @IBOutlet weak var customCellView: UIView!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var houseWordLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var swornMembersLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        customSettings()
    }

    // customizable cell settings on UI
    
    func customSettings() {
        houseNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        houseNameLabel.textAlignment = .center
        houseNameLabel.textColor = .white
        
        swornMembersLabel.font = UIFont.systemFont(ofSize: 12)
        swornMembersLabel.textAlignment = .center
        swornMembersLabel.textColor = .white
        
        houseWordLabel.textColor = .white
        regionLabel.textColor = .white
        arrowImageView.image = UIImage(systemName: "chevron.forward.circle")
        arrowImageView.tintColor = UIColor.systemBlue
        
        customCellView.backgroundColor = UIColor(displayP3Red: 41/255.0, green: 43/255.0, blue: 54/255.0, alpha: 1.0)
    }
}
