//
//  WeatherForecastTests.m
//  WeatherForecastTests
//
//  A test class to test the weather forecast api's.
//
//  Created by Prathesh Santh Muthuramalingam on 6/6/17.
//  Copyright © 2017 Prathesh Santh Muthuramalingam. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherForecastAPI.h"

@interface WeatherForecastTests : XCTestCase

@end

@implementation WeatherForecastTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

/**
 * an api to test if the weather information is returned properly for valid city
 */
- (void)testWeatherInfoApiForValidCity {
    
    NSString *city = @"Miamisburg";
    [WeatherForecastAPI getWeatherInfoForCity:city
                                   completion:^(NSURLSessionDataTask *task, WeatherForecast *resp, NSError *error) {
                                       XCTAssertTrue([resp.city isEqualToString:city]);
                                   }];
}

/**
 * an api to test if the weather information does not exist for invalid city mentioned
 */
- (void)testWeatherInfoApiForInvalidCity {
    
    NSString *city = @"nnonomm[[";
    [WeatherForecastAPI getWeatherInfoForCity:city
                                   completion:^(NSURLSessionDataTask *task, WeatherForecast *resp, NSError *error) {
                                       XCTAssertTrue(resp.city == nil);
                                   }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
