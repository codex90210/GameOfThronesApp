//
//  APIManager.swift
//  GameOfThronesApp
//
//  Created by David Mompoint on 10/24/21.
//

import Foundation
import Network

// success or fail result type that conforms to error switch case enum error type

protocol APIManagerProtocol {
    
    func testConnection(completion: @escaping (Result<String, Error>) -> Void)
    
    func fetchHouseList(completion: @escaping (Result<[GOTHouseData], Error>) -> Void)
    
    func fetchCharacterList(URLData: String, completionHandler: @escaping (Result<GOTCharacterData, Error>) -> ())
}

enum NetworkError: String, Error {
    
    // url no longer valid -- http server response
    case invalidURL = "Invalid URL"
    
    // empty data from server.
    case emptyData = "Unable to receive data."
    
    // URL string is sent empty to server
    case emptyURL = "Invalid URL request."
    
    // network connectivity -- internet
    case noInternet = "Unable to connect to the server. Please check your WiFi Connectivity."
}

// MARK:- Network connection status condition
struct networkStatus {

    // check internet connection on device
    
    func testConnection(completion: @escaping (Result<String, Error>) -> Void) {
                
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                completion(.success("CONNECTED"))
                // post connected notification
            } else {
                // present error failure
                completion(.failure(NetworkError.noInternet))
            }
        }
 
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        // start monotiring device for internet
        monitor.start(queue: queue)
        
        // cancel device monitoring for internet
        monitor.cancel()
    }
}

// MARK:- API House Manager for View Controller

struct APIHouseManager {

    // String URL Request
    var GOTHouseURL = "https://www.anapioficeandfire.com/api/houses?hasWords=true&pageSize=50"

    // fetch API Function
    func fetchHouseList(completion: @escaping (Result<[GOTHouseData], Error>) -> Void) {
    
        // handle empty URL String
        if GOTHouseURL == "" {
            completion(.failure(NetworkError.emptyURL))
            return
        }
    
        // second case of handling url string
        guard let url = URL(string: GOTHouseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
     
        // handle url response, data, and error error type
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(NetworkError.noInternet))
                return
            }
            
            // http response check for 200 ok code or failure
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            // data from url check if empty or not
            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            // handle list if empty or bad
            guard let list = try? JSONDecoder().decode([GOTHouseData].self, from: data) else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            // if all case pass, pass data to ViewController
            
            completion(.success(list))
        }
        
        task.resume()
    }
}

// MARK:- API Characater Manager for Detail View Controller

struct APICharacterManager {
    
    func fetchCharacterList(URLData: String, completionHandler: @escaping (Result<GOTCharacterData, Error>) -> ()) {
        
        // handle empty URL String
        if URLData == "" {
            completionHandler(.failure(NetworkError.emptyURL))
        }
        
        // second case of handling url string
        guard let url = URL(string: URLData) else {
            print("Invalid URL")
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }
        
        // handle url response, data, and error error type
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            if let _ = error {
                completionHandler(.failure(NetworkError.noInternet))
                return
            }
            
            // http response check for 200 ok code or failure
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(NetworkError.invalidURL))
                return
            }
            
            // data from url check if empty or not
            guard let data = data else {
                completionHandler(.failure(NetworkError.emptyData))
                return
            }
            // handle empty data list from API call
            guard let characterList = try? JSONDecoder().decode(GOTCharacterData.self, from: data) else {
                completionHandler(.failure(NetworkError.emptyData))
                return
            }
            
            // if all case pass, pass data to Detail View Controller
            completionHandler(.success(characterList))
          
        }
        
        task.resume()
    }
}

