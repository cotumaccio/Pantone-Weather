//
//  ViewController.m
//  Pantone Weather
//
//  Created by Gianfranco Cotumaccio on 04/08/14.
//  Copyright (c) 2014 Edenco. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"lat=%f&lon=%f", _locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude];
}

- (void)updateTime {
    
    // Time and Date
    _calendar = [NSCalendar currentCalendar];
    _currentDate = [NSDate date];
    
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:_currentDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:_currentDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:_currentDate];
    
    NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc] init];
    dateFormatterTime.dateFormat = @"hh:mm a";
    dateFormatterTime.timeZone = sourceTimeZone;
    dateFormatterTime.AMSymbol = @"am";
    dateFormatterTime.PMSymbol = @"pm";
    
    _lblCurrentTime.text = [dateFormatterTime stringFromDate:destinationDate];
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
    
}

- (void)updateColor {
    
    _colors =
    @{ @"012C" : [UIColor colorWithRed:0.22 green:0.85 blue:1.0 alpha:1],
       @"013C" : [UIColor colorWithRed:0.22 green:0.35 blue:0.61 alpha:1],
       @"014C" : [UIColor colorWithRed:0.58 green:0.76 blue:0.44 alpha:1],
       @"015C" : [UIColor colorWithRed:0.71 green:0.68 blue:0.31 alpha:1]
    };
    
    NSArray *colorKey = [_colors allKeys];
    
    int randomIndex = arc4random() % (_colors.count);
    UIColor *value = [_colors objectForKey:[colorKey objectAtIndex:randomIndex]];
    NSString *key = [colorKey objectAtIndex:randomIndex];
    
    // _colorsView.backgroundColor = value;
    _colorCode.text = key;
    
    [UIView animateWithDuration:1.0f animations:^{
        _colorsView.backgroundColor = value;
    }];
    
    // Weather API
    // Location
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.headingFilter = 0.0;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;  // highest + sensor data
    _locationManager.distanceFilter = 0.1f;
    [_locationManager startUpdatingLocation];
    
    // Weather Data
    _currentWeatherString = @"http://api.openweathermap.org/data/2.5/weather?";
    _parseModeString = @"&type=accurate&mode=json&";
    _APPID = @"APPID=6c12027578f2416c504b0670afa66b1d";
    _currentWeatherURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",_currentWeatherString,[self deviceLocation],_parseModeString,_APPID]];
    NSError *jsonerror = nil;
    _currentWeatherData = [[NSData alloc] initWithContentsOfURL:_currentWeatherURL];
    
    if (_currentWeatherData == nil) {
        NSLog(@"CurrentWeatherData is nil");
    }
    
    // Dictionary
    _forecastDict = [NSJSONSerialization JSONObjectWithData:_currentWeatherData options:kNilOptions error:&jsonerror];
    
    _lblTemp.text = [NSString stringWithFormat:@"%.f", [_forecastDict[@"main"][@"temp"]floatValue] - 273.15];
    _lblLocation.text = _forecastDict[@"name"];
    _lblWeatherDescription.text = _forecastDict[@"weather"][0][@"main"];
    
    // Get the Time and Date
    _calendar = [NSCalendar currentCalendar];
    _currentDate = [NSDate date];
    // NSDateComponents *dateComponents = [_calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:_currentDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"cccc, d LLLL";
    
    _lblCurrentDate.text = [dateFormatter stringFromDate:_currentDate];
    
    [self performSelector:@selector(updateColor) withObject:self afterDelay:10.0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add swipeGestures
    _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeDown:)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[self view] addGestureRecognizer:_swipeDown];
    
    // Weather API
    // Location
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.headingFilter = 0.0;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;  // highest + sensor data
    _locationManager.distanceFilter = 0.1f;
    [_locationManager startUpdatingLocation];
    
    // Weather Data
    _currentWeatherString = @"http://api.openweathermap.org/data/2.5/weather?";
    _parseModeString = @"&type=accurate&mode=json&";
    _APPID = @"APPID=6c12027578f2416c504b0670afa66b1d";
    _currentWeatherURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",_currentWeatherString,[self deviceLocation],_parseModeString,_APPID]];
    NSError *jsonerror = nil;
    _currentWeatherData = [[NSData alloc] initWithContentsOfURL:_currentWeatherURL];

    if (_currentWeatherData == nil) {
        NSLog(@"CurrentWeatherData is nil");
    }
    
    // Dictionary
    _forecastDict = [NSJSONSerialization JSONObjectWithData:_currentWeatherData options:kNilOptions error:&jsonerror];
    
    _lblTemp.text = [NSString stringWithFormat:@"%.f", [_forecastDict[@"main"][@"temp"]floatValue] - 273.15];
    _lblLocation.text = _forecastDict[@"name"];
    _lblWeatherDescription.text = _forecastDict[@"weather"][0][@"main"];

    // Get the Time and Date
    _calendar = [NSCalendar currentCalendar];
    _currentDate = [NSDate date];
    // NSDateComponents *dateComponents = [_calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:_currentDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"cccc, d LLLL";

    _lblCurrentDate.text = [dateFormatter stringFromDate:_currentDate];
    
    
    
    // [_socialView setFrame:CGRectMake(((self.view.bounds.size.width - _socialView.bounds.size.width) / 2), 400, 100, 100)];
    
    [self updateTime];
    [self updateColor];
    
    // NSLog(@"%@", destinationDate);
    
}

- (void)oneFingerSwipeDown:(UITapGestureRecognizer *)recognizer {
    
    // animateWithDuration with Spring
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
        // Change the size of the dialogView
        [_socialView setFrame:CGRectMake(((self.view.bounds.size.width - _socialView.bounds.size.width) / 2), 150, 300, 300)];
    } completion:^(BOOL finished) { }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
