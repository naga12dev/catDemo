// Copyright © 2021 Intuit, Inc. All rights reserved.

import XCTest
@testable import Cat_Demo

class Cat_DemoTests: XCTestCase {
    let model = ViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let cats = [
            CatBreed(id: "1", name: "Black cat"),
            CatBreed(id: "2", name: "White cat"),
            CatBreed(id: "2", name: "Brown cat")
        ]
        
        model.catBreeds = cats
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchCatDetails() {
    
        let handlerExpectation = expectation(description: "waiter")
        
        Network.fetchCatDetails(breedId: "amis") { (result) in
            switch result {
            case .success(let details):
                print("\(details)")
                
                handlerExpectation.fulfill()
                break
                
            case .failure(let error):
                print("\(error)")
                XCTFail()
            }
        }
        
        let result = XCTWaiter().wait(for: [handlerExpectation], timeout: 5)
        XCTAssert(result == .completed)
    }

    func testFilterTextMethod() {
        model.filterText = "ck"
        model.filterCats()
        XCTAssertTrue(model.filteredCatBreeds?.count == 1)
    }
    
    func testEmptyFilteredText() {
        model.filterText = "z"
        model.filterCats()
        XCTAssertTrue(model.filteredCatBreeds?.count == 0)
    }
}
