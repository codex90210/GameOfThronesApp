//
//  charactersCustomCell.swift
//  GameOfThronesApp
//
//  Created by David Mompoint on 10/26/21.
//

import Foundation

import UIKit

class charactersCustomCell: UITableViewCell {
    
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterTitle: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var deceasedLabel: UILabel!
    @IBOutlet weak var customCharCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customSettings()
    }
    
    // customizable cell settings on UI
    
    func customSettings() {

        let labels: [UILabel] = [birthLabel, deceasedLabel, characterTitle]
        
        customCharCellView.backgroundColor = UIColor(displayP3Red: 41/255.0, green: 43/255.0, blue: 54/255.0, alpha: 1.0)
        
        characterName.font = .boldSystemFont(ofSize: 16)
        characterName.textAlignment = .center
        characterName.textColor = .white

        birthLabel.font = .systemFont(ofSize: 12)
        birthLabel.textColor = .white
        
        deceasedLabel.font = .systemFont(ofSize: 12)
        deceasedLabel.textColor = .white
        
        characterTitle.font = .italicSystemFont(ofSize: 12)
        characterTitle.numberOfLines = 2
        characterTitle.textColor = .white
        
        for label in labels {
            alpha(labels: label, alphaCGFloat: 0.0)
        }

        UITableView.animate(withDuration: 1.3, delay: 0.0, options: [], animations: ({
            
            for label in labels {
                self.alpha(labels: label, alphaCGFloat: 1.0)
            }
        }))
        
    }
    
    func alpha(labels: UILabel, alphaCGFloat: CGFloat) {
        labels.alpha = alphaCGFloat
    }
}
