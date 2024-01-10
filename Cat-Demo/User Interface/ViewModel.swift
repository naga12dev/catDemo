// Copyright © 2021 Intuit, Inc. All rights reserved.

import Foundation
import UIKit

protocol CatDataDelegate {
    func breedsChangedNotification()
    func imageChangedNotification()
}

class ViewModel {

    var catDataDelegate: CatDataDelegate?
    var filterText = "" {
        didSet {
            filterCats()
        }
    }
    
    /// Array of cat breeds
    var catBreeds: [CatBreed]?
    
    var filteredCatBreeds: [CatBreed]?  {
        didSet {
            self.catDataDelegate?.breedsChangedNotification()
        }
    }
    
    var catImage: UIImage? {
        didSet {
            self.catDataDelegate?.imageChangedNotification()
        }
    }
    
    func filterCats() {
        if filterText.count > 0 {
            filteredCatBreeds = catBreeds?.filter {
                if let catname = $0.name {  //unwrapping
                    return catname.contains(filterText)
                }
                
                return false
            }
        } else {    //if no search text, show all
            filteredCatBreeds = catBreeds
        }
    }
    
    /// Get the breeds
    func getBreeds() {

        NetworkAdapter.fetchCatBreeds { result in
            switch result
            {
            case .success(let breeds):
                self.catBreeds = breeds
                self.filterCats()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDetails(breedId: String) {

        Network.fetchCatDetails(breedId: breedId) { (result) in
            switch result
            {
            case .success(let image):
                self.catImage = image
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
