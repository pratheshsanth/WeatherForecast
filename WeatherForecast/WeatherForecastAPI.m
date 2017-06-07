//
//  WeatherForecastAPI.m
//  WeatherForecast
//
//  Created by Prathesh Santh Muthuramalingam on 6/6/17.
//  Copyright © 2017 Prathesh Santh Muthuramalingam. All rights reserved.
//

#import "WeatherForecastAPI.h"
#import "WeatherForecastSessionManager.h"

static NSString *appId = @"0c87c13953e1619ae45e4f520241cbac";

@interface WeatherForecastAPI ()

/**
 * convert time string to formatted date string
 * @param timeStr time as string.
 * @returns formatted date string
 */
+ (NSString *)getDatefromSysTime:(NSString *)timeStr;
/**
 * convert time string to formatted time string
 * @param timeStr time as string.
 * @returns formatted time string
 */
+ (NSString *)getTimefromSysTime:(NSString *)timeStr;

@end

@implementation WeatherForecastAPI

#pragma mark - Class Methods

+ (void) getWeatherInfoForCity:(NSString *)city
                    completion:(void (^)(NSURLSessionDataTask* task, WeatherForecast *resp, NSError* error))completionBlock {
    
    NSString *urlString =
    [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@&units=metric", city, appId];
    
    [[WeatherForecastSessionManager sharedInstance] GET:urlString
                                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                                    if (responseObject !=  nil) {
                                                        WeatherForecast *weatherForecast = [[WeatherForecast alloc] init];
                                                        
                                                        NSArray *weatherInfo = responseObject[@"weather"];
                                                        weatherForecast.cloudInfo = [weatherInfo.firstObject[@"description"] capitalizedString];
                                                        weatherForecast.iconName  = weatherInfo.firstObject[@"icon"];
                                                        
                                                        weatherForecast.city = responseObject[@"name"];
                                                        weatherForecast.country = responseObject[@"sys"][@"country"];
                                                        weatherForecast.currentTemp = [NSString stringWithFormat:@"%.1f",[responseObject[@"main"][@"temp"] floatValue]];
                                                        weatherForecast.highTemp = [NSString stringWithFormat:@"%d",[responseObject[@"main"][@"temp_max"] intValue]];
                                                        weatherForecast.lowTemp = [NSString stringWithFormat:@"%d",[responseObject[@"main"][@"temp_min"] intValue]];
                                                        weatherForecast.currentDate =
                                                        [self getDatefromSysTime:[responseObject[@"sys"][@"sunrise"] stringValue]];
                                                        weatherForecast.sunrise =
                                                        [self getTimefromSysTime:[responseObject[@"sys"][@"sunrise"] stringValue]];
                                                        weatherForecast.sunset =
                                                        [self getTimefromSysTime:[responseObject[@"sys"][@"sunset"] stringValue]];
                                                        weatherForecast.humidity = [responseObject[@"main"][@"humidity"] stringValue];
                                                        weatherForecast.windSpeed = [NSString stringWithFormat:@"%.1f", [responseObject[@"wind"][@"speed"] floatValue]];
                                                        weatherForecast.pressure = [responseObject[@"main"][@"pressure"] stringValue];
                                                        
                                                        int visibilityValue = [responseObject[@"visibility"] intValue];
                                                        float convertedValue = visibilityValue / 1609.344;// Result in miles;
                                                        weatherForecast.visibility = [NSString stringWithFormat:@"%.2f", convertedValue];
                                                        
                                                        if ( completionBlock != nil ) {
                                                            completionBlock(task, weatherForecast, nil);
                                                        }
                                                    }
                                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                    if ( completionBlock != nil ) {
                                                        completionBlock(task, nil, error);
                                                    }
                                                }];
    
}

+ (void) getImageWithName:(NSString *)name
               completion:(void (^)(NSURLSessionDataTask* task, NSData *data, NSError* error))completionBlock {
    
    NSString *urlString =
    [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", name];
    NSURL *url = [NSURL URLWithString:urlString];
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask =
    [[WeatherForecastSessionManager sharedInstance].defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            if ( completionBlock != nil ) {
                completionBlock(dataTask, nil, error);
            }
        } else {
            if ( completionBlock != nil ) {
                completionBlock(dataTask, data, error);
            }
        }
    }];
    [dataTask resume];
}

#pragma mark - Private Methods

+ (NSString *)getDatefromSysTime:(NSString *)timeStr {
    
    NSTimeInterval seconds = [timeStr doubleValue];
    
    // (Step 1) Create NSDate object
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    
    // (Step 2) Use NSDateFormatter to display desired date format style
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getTimefromSysTime:(NSString *)timeStr {
    
    NSTimeInterval seconds = [timeStr doubleValue];
    
    // (Step 1) Create NSDate object
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    
    // (Step 2) Use NSDateFormatter to display desired time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:date];
}

@end
