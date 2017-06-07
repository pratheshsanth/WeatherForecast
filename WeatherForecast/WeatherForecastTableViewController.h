//
//  WeatherForecastTableViewController.h
//  WeatherForecast
//
//  A list view to display weather forecast information. Also you can search for a city to know its weather information
//
//  Created by Prathesh Santh Muthuramalingam on 6/6/17.
//  Copyright © 2017 Prathesh Santh Muthuramalingam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherForecastTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end
