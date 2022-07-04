//
//  _0220702_RolanMarat_NYCSchoolsTests.swift
//  20220702-RolanMarat-NYCSchoolsTests
//
//  Created by Rolan on 7/2/22.
//

import XCTest
import Combine

@testable import _0220702_RolanMarat_NYCSchools

class _0220702_RolanMarat_NYCSchoolsTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Unit Tests with Mocked Result
    
    // Testing with mocked API result that returns empty list
    func testMockedAPIWithMockedEmptySchoolsList() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .empty
        
        mockedAPI.getSchools(completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected to receive success response with no schools, but received failure instead with error \(error)")
            case .success(let schools):
                XCTAssertTrue(schools.isEmpty, "Expected to have empty schools list, but received actual schools.")
            }
        })
    }
    
    // Testing with mocked API result that returns empty SAT result list
    func testMockedAPIWithMockedEmptySATList() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .empty
        
        mockedAPI.getSchoolSATResults(completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected to receive success response with no SAT results, but received failure instead with error \(error)")
            case .success(let satResults):
                XCTAssertTrue(satResults.isEmpty, "Expected to have empty SAT result list, but received actual SAT results.")
            }
        })
    }
    
    // Testing with mocked API result that returns empty list
    // We are testing view model here with mocked API class
    func testViewModelWithMockedEmptySchoolList() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .empty

        let viewModel = SchoolsViewModel(schoolAPI: mockedAPI)
        viewModel.getSchools()

        viewModel.$schools
            .receive(on: RunLoop.main)
            .sink { schools in
                XCTAssertTrue(schools?.isEmpty == true, "Expected empty schools list, but got actual schools")
            }
            .store(in: &cancellables)
    }
    
    // Testing with mocked API result that returns empty SAT list
    // We are testing view model here with mocked API class
    func testViewModelWithMockedEmptySATList() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .empty

        let viewModel = SchoolsViewModel(schoolAPI: mockedAPI)
        viewModel.getSchoolSATs()

        viewModel.$schoolSATs
            .receive(on: RunLoop.main)
            .sink { schoolSATs in
                XCTAssertTrue(schoolSATs?.isEmpty == true, "Expected empty SAT result list, but got actual SAT result")
            }
            .store(in: &cancellables)
    }

    // Testing with mocked API result that returns mocked school data list
    func testMockedAPIWithMockedSchoolsList() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .loaded

        mockedAPI.getSchools(completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected to receive success response with schools, but received failure instead with error \(error)")
            case .success(let schools):
                XCTAssertTrue(schools.isEmpty == false, "Expected to have non-empty schools list, but received no schools.")
            }
        })
    }
    
    // Testing with mocked API result that returns mocked SAT data list
    func testMockedAPIWithMockedSATList() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .loaded

        mockedAPI.getSchoolSATResults(completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected to receive success response with SATs, but received failure instead with error \(error)")
            case .success(let schoolSATs):
                XCTAssertTrue(schoolSATs.isEmpty == false, "Expected to have non-empty school SAT list, but received no schools.")
            }
        })
    }

    // Testing with mocked API result that returns non-empty schools list
    // We are testing view model here with mocked API class
    func testViewModelWithMockedNonEmptySchoolsList() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .loaded

        let viewModel = SchoolsViewModel(schoolAPI: mockedAPI)
        viewModel.getSchools()

        viewModel.$schools
            .receive(on: RunLoop.main)
            .sink { schools in
                XCTAssertTrue(schools?.isEmpty == false,
                              "Expected non-empty schools list, but got no schools")
            }
            .store(in: &cancellables)
    }
    
    // Testing with mocked API result that returns non-empty SAT list
    // We are testing view model here with mocked API class
    func testViewModelWithMockedNonEmptySATList() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .loaded

        let viewModel = SchoolsViewModel(schoolAPI: mockedAPI)
        viewModel.getSchoolSATs()

        viewModel.$schoolSATs
            .receive(on: RunLoop.main)
            .sink { schoolSATs in
                XCTAssertTrue(schoolSATs?.isEmpty == false,
                              "Expected non-empty SAT list, but got no SATs")
            }
            .store(in: &cancellables)
    }

    // Testing with mocked API result that returns mocked error result
    func testMockedAPIWithMockedError() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .error

        mockedAPI.getSchools(completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error, "Expected to receive an error response, but got no error")
            case .success:
                XCTFail("Expected to receive failure, but got success")
            }
        })
    }
    
    // Testing with mocked API result that returns mocked error result
    func testMockedAPIWithMockedSATError() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .error

        mockedAPI.getSchoolSATResults(completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error, "Expected to receive an error response, but got no error")
            case .success:
                XCTFail("Expected to receive failure, but got success")
            }
        })
    }

    // Testing with mocked API result that returns error
    // We are testing view model here with mocked API class
    func testViewModelWithMockedError() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .error

        let viewModel = SchoolsViewModel(schoolAPI: mockedAPI)
        viewModel.getSchools()

        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { error in
                XCTAssertNotNil(error, "Expected to get an error, but received no error")
            }
            .store(in: &cancellables)
    }
    
    // Testing with mocked API result that returns error
    // We are testing view model here with mocked API class
    func testViewModelWithMockedSATError() {
        let mockedAPI = MockSchoolAPI()
        mockedAPI.state = .error

        let viewModel = SchoolsViewModel(schoolAPI: mockedAPI)
        viewModel.getSchoolSATs()

        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { error in
                XCTAssertNotNil(error, "Expected to get an error, but received no error")
            }
            .store(in: &cancellables)
    }

    ///Integration end to end tests: we connect to the server

    //Test whether we are able to download raw school list data with no errors
    func testDownloadSchoolsWithCorrectResponse() {
        let api = SchoolAPI()

        api.getSchools { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            case .success(let schools):
                XCTAssertFalse(schools.isEmpty, "Expected schools to be retrieved, but did not get any school")
            }
        }
    }
    
    //Test whether we are able to download raw SAT data with no errors
    func testDownloadSATsWithCorrectResponse() {
        let api = SchoolAPI()

        api.getSchoolSATResults { result in
            switch result {
            case .failure(let error):
                XCTFail("Expected success, got failure with error: \(error)")
            case .success(let schoolSATs):
                XCTAssertFalse(schoolSATs.isEmpty, "Expected SATs to be retrieved, but did not get any SAT")
            }
        }
    }

}
