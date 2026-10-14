//
//  Hello_MapsUITests.swift
//  Hello-MapsUITests
//
//  Created by Kit Sitou on 10/11/26.
//

import XCTest

final class Hello_MapsUITests: XCTestCase {
    var app: XCUIApplication!
//    var onboardingScreen: OnBoardingScreen!
//    var addressSearchScreen: AddressSearchScrenn!
//    var dashboardScreen: DahboardScreen!
    
    

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITestin-Reset"]
        app.launch()
//        onboardingScreen = onboardingScreen(app: app)
//        dashboardScreen = dashboardScreen(app: app)
//        addressSearchScreen = addressSearchScreen(app: app)
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.


    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func test_01_elementExit() throws{
   
      XCTAssertTrue(app.staticTexts["bagReminderText"].exists, "resuable bag reminder not visible")
        XCTAssertTrue(app.staticTexts["beforeInputStoreText"].exists, "store address needed reminder not visible")
    
    }
    
    func test_navigation_addressView() throws{
        let addHomeButton = app.buttons["add_home_button"]
        XCTAssertTrue(addHomeButton.exists)
        addHomeButton.tap()
        XCTAssertTrue(
        app.staticTexts["addressSearchViewText"]
            .waitForExistence(timeout: 5)
        )
    }
    
    func test_navigation_afterCancel() throws{
        let addHomeButton = app.buttons["add_home_button"]
        addHomeButton.tap()
        let cancelButton = app.buttons["cancelButton"]
        cancelButton.tap()
        XCTAssertTrue(
            app.staticTexts["beforeInputStoreText"]
                .waitForExistence(timeout: 5)
        )
        
    }
   
}
