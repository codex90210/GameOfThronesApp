//
//  DetailViewController.swift
//  GameOfThronesApp
//
//  Created by David Mompoint on 10/26/21.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var characterList = [String]()
    var appendedChar = [GOTCharacterData]()
    var characterData: GOTCharacterData?
    var countdown = Double(0)
    
    var managerCharacterAPI = APICharacterManager()
    
    var hasErrorOccured = Bool()
    
    @IBOutlet weak var charactersTableView: UITableView!
    
    private var loadingImgView: UIImageView = {
        var loadingImgView = UIImageView()
        return loadingImgView
    }()
    
    var navTitle = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersTableView.dataSource = self
        self.charactersTableView.rowHeight = 175
        
        // characterList -- used for in main ViewController for count in number of characters in each house.
        
        if characterList.count == 0 {
            self.charactersTableView.rowHeight = view.frame.size.height
            
            navTitle.title = "No Pledgers Available"
            
        } else {
            navTitle.title = "Characters"
        }
        
        // fetch API, Handle Errors, Update UI
        fetchingAPIChar()
    }
    
//MARK:- FETCH CHARACTER API, ERROR HANDLING, & UPDATE UI
    
    func fetchingAPIChar() {
        
        // fetching URLS for every character on the list from main View Controller
        for urls in characterList {
           
            //FETCH
            managerCharacterAPI.fetchCharacterList(URLData: urls, completionHandler: { result in
                
                switch result {
                
                //SUCESS
                case .success(let data):
                   
                    //Append Character List
                    self.appendedChar.append(data)
                    
                //FAILURE
                case .failure(let error):
                    // Raw value of error message as alert message.
                    
                    let errorMSG = error as! NetworkError
                    //print(errorMSG.rawValue)
                    // update UI on main thread
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "Page Not Found", message: errorMSG.rawValue, preferredStyle: .actionSheet)
                        
                        let refresh = UIAlertAction(title: "Refresh", style: .default, handler: {
                            UIAlertAction in
                            
                            self.charactersTableView.reloadData()
                        })
                        
                        let reportBug = UIAlertAction(title: "Report Bug", style: .cancel, handler: {
                            UIAlertAction in
                            
                            if let url = URL(string: "https://iosworld.blog/contact/") {
                                UIApplication.shared.open(url)
                            }
                        })
                        // Handles emtpy House API Data according to conditions below:
                        
                        if errorMSG.rawValue == NetworkError.emptyData.rawValue {
                            alert.addAction(refresh)
                        } else {
                            alert.addAction(reportBug)
                        }
                        // Present alert controller
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            })
        }
    
        //UPDATE UI
        
        // ternary for size of data set if greater than 50, return 7 seconds else; 3 seconds
        self.countdown = self.characterList.count > 50 ? 6 : 1.5
        
        // completion handler setup for string title so navigation title is updated when loading process completes through self
        let navTitleStringFunc = {(navString: (String)) in
            self.title = navString
        }
        
        // place this function outside of forloop,
        // which eliminates reptitive glitchy loading process.
        
        DispatchQueue.main.async {
            loaderView(navTitle: self.navTitle, loadingImg: self.loadingImgView, MainView: self.view, tableView: self.charactersTableView, timerCount: self.countdown, completion: navTitleStringFunc)
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appendedChar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell") as! charactersCustomCell
        
        cell.characterName.text = appendedChar[indexPath.row].name
        cell.birthLabel.text =  appendedChar[indexPath.row].born != "" ? "Birth: \(appendedChar[indexPath.row].born)" : "Birth: Unknown"
        
        let value = appendedChar[indexPath.row].titles.joined(separator: ", ")
        
        // ternary for empty values
        cell.characterTitle.text = value != "" ? "Titles: \(value)" : "Titles: Unknown"
        cell.deceasedLabel.text = appendedChar[indexPath.row].died != "" ? "Death: \(appendedChar[indexPath.row].died!)" : "Death: Unknown"
        
        
        // Ternary for text color
        cell.birthLabel.textColor = cell.birthLabel.text == "Birth: Unknown" ? .systemBlue : .white
        cell.characterTitle.textColor = cell.characterTitle.text == "Titles: Unknown" ? .lightGray: .white
        
        cell.birthLabel.alpha = cell.birthLabel.text == "Birth: Unknown" ? 0.8 : 1.0
        cell.characterTitle.alpha = cell.characterTitle.text == "Titles: Unknown" ? 0.8 : 1.0
        
        return cell
    }
    
}
