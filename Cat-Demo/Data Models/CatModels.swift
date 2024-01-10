// Copyright © 2021 Intuit, Inc. All rights reserved.

import Foundation

/// Data Model for network response
struct CatBreed: Decodable {
    /// internal ID
    let id: String?
    
    /// Name of cat (e.g. "Somali")
    let name: String?
    
    /// Description
    let description: String?
    
    /// Range (e.g. 12-16)
    let life_span: String?
    
    /// Reference
    let wikipedia_url: String?
    
    /// General traits and characteristic rankings (0-10)
    let adaptability: Int?
    let affection_level: Int?
    let child_friendly: Int?
    let dog_friendly: Int?
    let energy_level: Int?
    let grooming: Int?
    let health_issues: Int?
    let intelligence: Int?
    let shedding_level: Int?
    let social_needs: Int?
    let stranger_friendly: Int?
    let vocalisation: Int?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        
        description = ""
        life_span = ""
        wikipedia_url = ""
        adaptability = 0
        affection_level = 0
        child_friendly = 0
        dog_friendly = 0
        energy_level = 0
        grooming = 0
        health_issues = 0
        intelligence = 0
        shedding_level = 0
        social_needs = 0
        stranger_friendly = 0
        vocalisation = 0
    }
}

struct IntuitCatDetails: Decodable {
    let breeds: [CatBreedDetails]?
    
    struct CatBreedDetails: Decodable {
        let id: String?
        let name: String?
        let temperament: String?
    }
    
    let url: String?    // image URL
}
