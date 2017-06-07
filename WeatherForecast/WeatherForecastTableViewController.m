//
//  WeatherForecastTableViewController.m
//  WeatherForecast
//
//  Created by Prathesh Santh Muthuramalingam on 6/6/17.
//  Copyright © 2017 Prathesh Santh Muthuramalingam. All rights reserved.
//

#import "WeatherForecastTableViewController.h"
#import "WeatherForecastAPI.h"

#define STATUS_BAR_HEIGHT 20

@interface WeatherForecastTableViewController ()

@property (nonatomic, weak) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) IBOutlet UILabel *cloundInfoLabel;
@property (nonatomic, weak) IBOutlet UIImageView *weatherImageView;
@property (nonatomic, weak) IBOutlet UILabel *currentTempLabel;
@property (nonatomic, weak) IBOutlet UILabel *hiTempLabel;
@property (nonatomic, weak) IBOutlet UILabel *lowTempLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentDateLabel;

@property (nonatomic, weak) IBOutlet UILabel *sunriseValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *sunsetValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *humidityValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *windValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *pressureValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *visibilityValueLabel;

@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

/**
 * a function triggered on clicking the search bar and does a search for the city entered.
 * @param searchBar a searchbar argument.
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;

@end

@implementation WeatherForecastTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 0, 0, 0);
    self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height - STATUS_BAR_HEIGHT);
    
    self.overlayView =
    [[UIView alloc] initWithFrame:CGRectMake(0,
                                             self.searchBar.frame.origin.y + self.searchBar.frame.size.height,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height - (self.searchBar.frame.origin.y + self.searchBar.frame.size.height))];
    [self.overlayView setBackgroundColor:[UIColor blackColor]];
    
    self.activityIndicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicatorView setFrame:CGRectMake(self.overlayView.frame.size.width/2 - self.activityIndicatorView.frame.size.width/2,
                                                    self.overlayView.frame.size.height/2 - self.activityIndicatorView.frame.size.height/2,
                                                    self.activityIndicatorView.frame.size.width,
                                                    self.activityIndicatorView.frame.size.height)];
    [self.overlayView addSubview:self.activityIndicatorView];
    
    [self.view addSubview:self.overlayView];
    
    self.searchBar.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLastVisitedCity"];
    if ([self.searchBar.text length] > 0) {
        [self searchBarSearchButtonClicked:self.searchBar];
    }
}

#pragma mark - Memory Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.activityIndicatorView startAnimating];
    
    WeatherForecastTableViewController __weak *weakSelf = self;
    [WeatherForecastAPI getWeatherInfoForCity:searchBar.text
                                   completion:^(NSURLSessionDataTask *task, WeatherForecast *wf, NSError *error) {
                                       if (error != nil) {
                                           NSLog(@"Error Object %@", error);
                                       } else {
                                           if (wf != nil
                                               && [wf.city length] > 0) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   [[NSUserDefaults standardUserDefaults] setObject:searchBar.text forKey:@"kLastVisitedCity"];
                                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                                   
                                                   [weakSelf.cityLabel setText:[NSString stringWithFormat:@"%@, %@",wf.city,wf.country]];
                                                   [weakSelf.cloundInfoLabel setText:wf.cloudInfo];
                                                   [weakSelf.currentTempLabel setText:[NSString stringWithFormat:@"%@ °C",wf.currentTemp]];
                                                   [weakSelf.hiTempLabel setText:[NSString stringWithFormat:@"↑ %@ °C",wf.highTemp]];
                                                   [weakSelf.lowTempLabel setText:[NSString stringWithFormat:@"↓ %@ °C",wf.lowTemp]];
                                                   [weakSelf.currentDateLabel setText:wf.currentDate];
                                                   
                                                   [weakSelf.sunriseValueLabel setText:wf.sunrise];
                                                   [weakSelf.sunsetValueLabel setText:wf.sunset];
                                                   [weakSelf.humidityValueLabel setText:[NSString stringWithFormat:@"%@ %%", wf.humidity]];
                                                   [weakSelf.windValueLabel setText:[NSString stringWithFormat:@"%@ m/s",wf.windSpeed]];
                                                   [weakSelf.pressureValueLabel setText:[NSString stringWithFormat:@"%@ hpa",wf.pressure]];
                                                   [weakSelf.visibilityValueLabel setText:[NSString stringWithFormat:@"%@ m",wf.visibility]];
                                                   
                                                   [weakSelf.activityIndicatorView stopAnimating];
                                                   [weakSelf.overlayView setHidden:YES];
                                                   [weakSelf.searchBar resignFirstResponder];
                                                   
                                                   [WeatherForecastAPI getImageWithName:wf.iconName
                                                                             completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                                     UIImage *image = [UIImage imageWithData:responseObject];
                                                                                     [weakSelf.weatherImageView setImage:image];
                                                                                 });
                                                                             }];
                                               });
                                           } else {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self.activityIndicatorView stopAnimating];
                                                   
                                                   UIAlertController *alertVC =
                                                   [UIAlertController alertControllerWithTitle:NSLocalizedString(@"NoCityMatchAlertTitle", nil)
                                                                                       message:NSLocalizedString(@"NoCityMatchAlertMessage", nil)
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                                   UIAlertAction *ok =
                                                   [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:nil];
                                                   [alertVC addAction:ok];
                                                   [self presentViewController:alertVC animated:YES completion:nil];
                                               });
                                           }
                                       }
                                   }];
}
@end
