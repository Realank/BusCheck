//
//  ViewController.h
//  RealankBusCheck
//
//  Created by Realank on 14/6/29.
//  Copyright (c) 2014年 刘彦博 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <sqlite3.h>

@interface ViewController : UIViewController
<MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) NSString *dataBasePath;
@property (nonatomic) sqlite3 *sheduleDB;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locMgr;
- (IBAction)locateMe:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *locateBnt;

@end

