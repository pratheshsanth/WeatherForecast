//
//  WeatherForecastSessionManager.m
//  WeatherForecast
//
//  Created by Prathesh Santh Muthuramalingam on 6/6/17.
//  Copyright © 2017 Prathesh Santh Muthuramalingam. All rights reserved.
//

#import "WeatherForecastSessionManager.h"

@interface WeatherForecastSessionManager ()

@property (nonatomic, strong) NSURLSession *defaultSession;

@end

@implementation WeatherForecastSessionManager

#pragma mark - Initializers

- (id)init {
    
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.defaultSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

+ (instancetype) sharedInstance {
    
    static WeatherForecastSessionManager *sharedInstance = nil;
    
    //Using dispatch_once from GCD. This method is thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - URLSession Utility Methods

- (void) GET:(NSString *)URLString
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure {
    
    NSURL *url = [NSURL URLWithString:URLString];
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask =
    [self.defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                NSError *error = nil;
                id responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                success(dataTask, responseObject);
            }
        }
    }];
    
    [dataTask resume];
}

@end
