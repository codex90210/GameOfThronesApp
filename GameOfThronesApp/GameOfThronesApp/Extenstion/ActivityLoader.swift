//
//  ActivityLoader.swift
//  GameOfThronesApp
//
//  Created by David Mompoint on 10/28/21.
//

import Foundation
import UIKit
import Network

// activity custom loader view.
func loaderView(navTitle: UINavigationController, loadingImg: UIImageView, MainView: UIView, tableView: UITableView, timerCount: Double, completion: @escaping (String) -> ())
    {
    // random icons for activty loader
    let GOTIconImgs = ["arrynxeyrie512", "aryaxstark512", "briennex512", "daryen512", "dragonx512", "gotx512png", "greyjoyxpyke512", "jonsnowx512", "petyrx512", "robbx512", "tyrellx512", "robertx512", "starkwolfx512", "tullyxriverrun512"]
    
    let randomImg = GOTIconImgs.randomElement()!
    
    // setting icon image to imageView
    let loadImage = UIImage(named: randomImg)
    let tintImage = loadImage?.withRenderingMode(.alwaysTemplate)
    loadingImg.contentMode = .scaleAspectFill
    loadingImg.image = tintImage
    
    navTitle.isNavigationBarHidden = true
    
// MARK:- CUSTOMIZE UI
    // obtain view height & width
    let viewHeight = MainView.frame.height
    let viewWidth = MainView.frame.width
    
    // image Message View Two Configuration
    // subtle flash animation for image message two?
    
    let imgHeight = viewHeight / 3
    let imgWidth = viewWidth / 3
    
    MainView.backgroundColor = UIColor(displayP3Red: 40/255.0, green: 43/255.0, blue: 53/255.0, alpha: 1.0)
    tableView.backgroundColor = UIColor(displayP3Red: 40/255.0, green: 43/255.0, blue: 53/255.0, alpha: 1.0)
    
    loadingImg.frame = CGRect(x: (viewWidth / 2) - (imgWidth / 2), y: (viewHeight / 2) - (imgHeight / 2), width: imgWidth, height: imgHeight)

    loadingImg.tintColor = .darkGray
    UIImageView.animate(withDuration: 0.9, delay: 0, options: [.autoreverse, .repeat], animations: ({
        loadingImg.tintColor = .systemIndigo
    }), completion: nil)

    
    MainView.addSubview(loadingImg)
    // set up loading icon indicator, tableView, and pass custom countdown time.
    tableView.isHidden = true

// MARK:- LOAD CONTENTS AFTER # OF SECONDS VIA INPUT
    // load UI after background fetch at specific time
    DispatchQueue.main.asyncAfter(deadline: .now() + timerCount) {
        // end network activty spinner
        
        loadingImg.isHidden = true
        completion(navTitle.title!)

        navTitle.isNavigationBarHidden = false
        tableView.isHidden = false
        tableView.alpha = 0.0
        UITableView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: ({
            tableView.alpha = 1.0
        }))
        
        tableView.reloadData()
        loadingImg.image = nil
    
    }
}
