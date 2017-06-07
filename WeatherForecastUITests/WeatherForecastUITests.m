//
//  WeatherForecastUITests.m
//  WeatherForecastUITests
//
//  A test class to test the weather forecast view user interface.
//
//  Created by Prathesh Santh Muthuramalingam on 6/6/17.
//  Copyright © 2017 Prathesh Santh Muthuramalingam. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherForecastTableViewController.h"

@interface WeatherForecastUITests : XCTestCase

@end

@implementation WeatherForecastUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
 * an api to test if the weather information is retrieved in UI properly for valid city search
 */
- (void)testCitySearch {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.searchFields.element tap];
    [app.searchFields.element typeText:@"Raleigh"];
}

@end
