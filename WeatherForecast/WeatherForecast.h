//
//  WeatherForecast.h
//  WeatherForecast
//
//  A model class to hold weather forecast information.
//
//  Created by Prathesh Santh Muthuramalingam on 6/6/17.
//  Copyright © 2017 Prathesh Santh Muthuramalingam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherForecast : NSObject

@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *cloudInfo;
@property (nonatomic,strong) NSString *currentTemp;
@property (nonatomic,strong) NSString *highTemp;
@property (nonatomic,strong) NSString *lowTemp;
@property (nonatomic,strong) NSString *currentDate;
@property (nonatomic,strong) NSString *sunrise;
@property (nonatomic,strong) NSString *sunset;
@property (nonatomic,strong) NSString *humidity;
@property (nonatomic,strong) NSString *windSpeed;
@property (nonatomic,strong) NSString *pressure;
@property (nonatomic,strong) NSString *visibility;
@property (nonatomic,strong) NSString *iconName;

@end
