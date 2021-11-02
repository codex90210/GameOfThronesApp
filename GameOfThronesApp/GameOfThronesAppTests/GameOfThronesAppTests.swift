//
//  GameOfThronesAppTests.swift
//  GameOfThronesAppTests
//
//  Created by David Mompoint on 10/21/21.
//

import XCTest
@testable import GameOfThronesApp

class GameOfThronesAppTests: XCTestCase {
    
    var SUTModelTestHouse: GOTHouseData?
    var SUTModelTestCharacters: GOTCharacterData!
    
    var SUTAPIHouse: APIHouseManager!
    var SUTAPICharacter: APICharacterManager!
    
    let API = APIHouseManager()
    enum MockNetworkError: String, Error {
        
        // url no longer valid -- http server response
        case invalidURL = "Invalid URL"
        
        // empty data from server.
        case emptyData = "Unable to receive data."
        
        // URL string is sent empty to server
        case emptyURL = "Invalid URL request."
        
        // network connectivity -- internet
        case noInternet = "Unable to connect to the server. Please check your WiFi Connectivity."
    }

    var SUTurl = URL(string: "https://anapioficeandfire.com/api/houses/35")!

    var SUTCharUrl = URL(string: "https://anapioficeandfire.com/api/characters/583")!

    override func setUp() {
        super.setUp()
        
        SUTAPIHouse = APIHouseManager()
        SUTAPICharacter = APICharacterManager()
        
        SUTModelTestHouse = GOTHouseData(url: URL(string: "https://anapioficeandfire.com/api/houses/4")!, name: "House Ambrose", region: "The Reach", words: "Never Resting", swornMembers: [
            "https://anapioficeandfire.com/api/characters/82",
            "https://anapioficeandfire.com/api/characters/102",
            "https://anapioficeandfire.com/api/characters/141",
            "https://anapioficeandfire.com/api/characters/152",
            "https://anapioficeandfire.com/api/characters/344"
        ])
        
        SUTModelTestCharacters = GOTCharacterData(url: URL(string: "https://anapioficeandfire.com/api/characters/583")!, name: "Jon Snow", titles: [
            "Lord Commander of the Night's Watch"
        ], born: "In 283 AC", died: "")
    }
    override func tearDown() {
        
        SUTModelTestHouse = nil
        super.tearDown()
    }
    
    func testValidURL_CheckEmptyURL() {
        
        SUTAPIHouse.GOTHouseURL = "\(SUTurl)"
        
        XCTAssertNotEqual(SUTAPIHouse.GOTHouseURL, "")

    }
    
}


// Figure out a way to run tests via protocol with funcitons that carry completion blocks.
extension GameOfThronesAppTests: APIManagerProtocol {
    
    func testConnection(completion: @escaping (Result<String, Error>) -> Void) {
        // Test Functionality w. completion.
    }
    
    func fetchHouseList(completion: @escaping (Result<[GOTHouseData], Error>) -> Void) {
        // Test Functionality w. completion
    }
    
    func fetchCharacterList(URLData: String, completionHandler: @escaping (Result<GOTCharacterData, Error>) -> ()) {
        // Test Functionality w. completion
    }
    
    
}

