//
//  ViewController.h
//  Pantone Weather
//
//  Created by Gianfranco Cotumaccio on 04/08/14.
//  Copyright (c) 2014 Edenco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ViewController : UIViewController

// UI
@property (strong, nonatomic) IBOutlet UIView *colorsView;
@property (strong, nonatomic) IBOutlet UILabel *colorCode;
@property (strong, nonatomic) IBOutlet UILabel *lblTemp;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblWeatherDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentDate;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentTime;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeDown;
@property (strong, nonatomic) IBOutlet UIView *socialView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic) CGFloat posY;

// Gesture
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;

// Method Update Time
- (void)updateTime;
- (void)updateColor;

// Date, Date Formatter, TimeZone, Calendar
@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSCalendar *calendar;

// Location Manager
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) CLLocation *currentLocation;

// Weather API
@property (strong, nonatomic) NSString *currentWeatherString;
@property (strong, nonatomic) NSURL *currentWeatherURL;
@property (strong, nonatomic) NSData *currentWeatherData;
@property (strong, nonatomic) NSString *parseModeString;
@property (strong, nonatomic) NSString *APPID;

// Dictionary
@property (strong, nonatomic) NSDictionary *colors;
@property (strong, nonatomic) NSMutableDictionary *forecastDict;

@end

