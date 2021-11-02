//
//  GOTStructModels.swift
//  GameOfThronesApp
//
//  Created by David Mompoint on 10/24/21.
//

import Foundation

// House and Character API Data

struct GOTHouseData: Codable {
    let url: URL
    let name: String
    let region: String
    let words: String
    let swornMembers: [String]
}

struct GOTCharacterData: Codable {
    let url: URL
    let name: String
    let titles: [String]
    let born: String
    let died: String?
    
}
