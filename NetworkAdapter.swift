//
//  NetworkAdapter.swift
//  Cat-Demo
//
//  Created by mounika on 11/10/22.
//

import Foundation

class NetworkAdapter {
    class func fetchCatBreeds(completion: @escaping (Swift.Result<[CatBreed], Error>) -> Void) {
        Network.fetchData(url: "https://api.thecatapi.com/v1/breeds",Pagination(0, limit: 5), method: .get, onCompletion: completion)
    }
}
