//
//  WeatherForecastAPI.h
//  WeatherForecast
//
//  An api class to retrieve weather information/Image for the city searched.
//
//  Created by Prathesh Santh Muthuramalingam on 6/6/17.
//  Copyright © 2017 Prathesh Santh Muthuramalingam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherForecast.h"

@interface WeatherForecastAPI : NSObject

/**
 * an api to get weather information for the city searched
 * @param city any city name in US
 * @param completionBlock block returning the weather forecase information
 */
+ (void) getWeatherInfoForCity:(NSString *)city
                    completion:(void (^)(NSURLSessionDataTask* task, WeatherForecast *resp, NSError* error))completionBlock;
/**
 * an api to get an image from the server by the name that is mentioned
 * @param name name of the image.
 * @param completionBlock block returning the image data
 */
+ (void) getImageWithName:(NSString *)name
               completion:(void (^)(NSURLSessionDataTask* task, NSData *data, NSError* error))completionBlock;

@end
