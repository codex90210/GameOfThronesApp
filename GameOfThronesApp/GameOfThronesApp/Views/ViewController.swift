//
//  ViewController.swift
//  GameOfThronesApp
//
//  Created by David Mompoint on 10/21/21.
//

import UIKit
import Network


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var houseTableView: UITableView!
    
    // handle api arrays
    var arrays = [GOTHouseData]()
    var managerHouseAPI = APIHouseManager()
    
    //Passed through to activtyLoader.swift file
    // add image view programmatically for customizable loading process
    
    private var loadingImgView: UIImageView = {
       var loadingImgView = UIImageView()
        return loadingImgView
    }()
    
    var navTitle = UINavigationController()
    
    // create instatnce to networkStatus struct
    let connection = networkStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.houseTableView.dataSource = self
        self.houseTableView.delegate = self
        self.houseTableView.rowHeight = 175

        navTitle.title = "House"
    
        // function below checks network connction status, fetchAPI, Update UI
        checkNetworkConnection()
    }
        
//MARK:- INTERNET STATUS & API REQUEST
    
    // NETWORK TEST
    func checkNetworkConnection() {
        connection.testConnection(completion: { result in
            switch result {
            
            case .success(let goodConnection):
                // fetch api if passed
                print(goodConnection)
    
                DispatchQueue.main.async {
                    self.fetchAPIData()
                }
                    
            case .failure(let error):
                
                // present error after connection test on main thread completes
                // update UI on main thread
                DispatchQueue.main.async {
                    self.navTitle.isToolbarHidden = true
                    
                    // code refractoring needed.
                    let errorMSG = error as! NetworkError
                    //self.resultType(.noInternet)
                    let alert = UIAlertController(title: "No Internet Connection", message: errorMSG.rawValue, preferredStyle: .actionSheet)
                    let checkSettings = UIAlertAction(title: "Check Connection", style: .default) {_ in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsURL) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                    alert.addAction(checkSettings)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
// API FETCH
    // fetching api data -- func passed into checkNetworkConnection()
    
    func fetchAPIData() {
        managerHouseAPI.fetchHouseList(completion: {result in
            
            switch result {
            // SUCESS
            case .success(let houseArrays):
                
                // set arrays from API
                self.arrays = houseArrays
                
                // update UI on main thread
                
                DispatchQueue.main.async {
                    let navTitleStringFunc = {(navString: (String)) in
                        self.title = navString
                    }
                    
                    // three seconds for data to load.
               
                    loaderView(navTitle: self.navTitle, loadingImg: self.loadingImgView, MainView: self.view, tableView: self.houseTableView, timerCount: 3, completion: navTitleStringFunc)
                }
            // FAILURE
            case .failure(let error):
                let errorMSG = error as! NetworkError
                print(errorMSG.rawValue)
  
                // Update UI on main thread
                DispatchQueue.main.async {
                    
                    // Present UI Alert for user to handle error
                    let alert = UIAlertController(title: "Page Not Found", message: errorMSG.rawValue, preferredStyle: .actionSheet)
                    
                    let refresh = UIAlertAction(title: "Refresh", style: .default, handler: {
                        UIAlertAction in
                        
                        self.houseTableView.reloadData()
                        
                    })
                    
                    let reportBug = UIAlertAction(title: "Report Bug", style: .cancel, handler: {
                        UIAlertAction in
                        
                        if let url = URL(string: "https://iosworld.blog/contact/") {
                            UIApplication.shared.open(url)
                        }
                    })
                    
                    // handle emtpy House API Data based off conditions below:
                    // refresh to reload tableView if UI loads before background fetch completes
                    // and the tableView shows up empty.
                    if errorMSG.rawValue == NetworkError.emptyData.rawValue {
                        alert.addAction(refresh)
                    } else {
                        alert.addAction(reportBug)
                    }
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! houseCustomCell
        
        cell.houseNameLabel.text = arrays[indexPath.row].name
        cell.houseWordLabel.text = "Motto: \(arrays[indexPath.row].words)"
        cell.regionLabel.text = arrays[indexPath.row].region
        cell.swornMembersLabel.text = "Pledge Members: \(arrays[indexPath.row].swornMembers.count)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Process action to Detail View Controller to seek character data.
        performSegue(withIdentifier: "toDetailView", sender: indexPath.row)
    }
    
    // setting segue action for code above.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = houseTableView.indexPathForSelectedRow {
            guard let destinationVC = segue.destination as? DetailViewController else {
                return
            }
            
            // Characters correspond to each house listed in main view controller.
            destinationVC.characterList = arrays[indexPath.row].swornMembers
        }
    }
}
