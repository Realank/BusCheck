//
//  ViewController.m
//  RealankBusCheck
//
//  Created by Realank on 14/6/29.
//  Copyright (c) 2014年 刘彦博 . All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    //show my location dot
    _locMgr=[[CLLocationManager alloc]init];
    if ([_locMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locMgr requestAlwaysAuthorization];
    }
    //[_locMgr startUpdatingLocation];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    //remove previous pin
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.1351,117.2078);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 5000, 5000);
    [_mapView setRegion:region animated:YES];
    [_mapView removeAnnotations:[_mapView annotations]];

    
    NSString * srcDBPath = [[NSBundle mainBundle] pathForResource:@"realankDb.db" ofType:nil];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    _dataBasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"realankDb.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    [filemgr copyItemAtPath:srcDBPath toPath:_dataBasePath error:nil];
    //NSLog(@"srcDBpath%@ docsDir%@",srcDBPath,_dataBasePath);
    if ([filemgr fileExistsAtPath:_dataBasePath] == NO) {
        NSLog(@"数据库不存在%@",_dataBasePath);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"数据库不存在" message:@"请导入班车时刻数据库" delegate:self cancelButtonTitle:@"好的吧" otherButtonTitles:nil, nil];
        [alertView show];

    }
    else{
        sqlite3_stmt *statement;
        const char *dbpath = [_dataBasePath UTF8String];
        if (sqlite3_open(dbpath, &_sheduleDB) == SQLITE_OK) {
            
            NSMutableArray *annotations = [[NSMutableArray alloc]init];
            int i = 1;
            while (i) {
                
                NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM schedule WHERE id = \"%d\" ",i++];
                const char *query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(_sheduleDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_ROW) {
                        NSString *addr = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                        NSString *lineType = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                        double latitude = sqlite3_column_double(statement, 3);
                        double longitude = sqlite3_column_double(statement, 4);
                        NSString *time1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                        NSString *time2 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                        NSString *time3 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                        NSString *time4 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                        NSString *time5 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                        NSString *time6 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                        NSString *time7 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                        
                        //NSLog(@"%@ %@ %f %f %@ %@ %@ %@ %@",addr,lineType,latitude,longitude,time1,time2,time3,time4,time5);
                        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                        annotation.title    = [[NSString alloc]initWithFormat:@"%@ - %@",addr,lineType];
                        annotation.subtitle = [[NSString alloc]initWithFormat:@"%@ %@ %@ %@ %@ %@ %@",time1,time2,time3,time4,time5,time6,time7];
                        [annotations addObject:annotation];
                        
                    }
                    else{
                        i=0;
                    }
                    sqlite3_finalize(statement);
                }
                else{
                    NSLog(@"prepare failed");
                }
            }
            [_mapView addAnnotations:annotations];
            sqlite3_close(_sheduleDB);
        }
        else{
           // _string2.text=@"open db failed";
            
        }
    }
    /*
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc]init];
    annotation1.coordinate = CLLocationCoordinate2DMake(39.126, 117.157);
    annotation1.title    = @"realank location";
    annotation1.subtitle = @"Hello World";
    [annotations addObject:annotation1];
    
    MKPointAnnotation *annotation2 = [[MKPointAnnotation alloc]init];
    annotation2.coordinate = CLLocationCoordinate2DMake(39.092, 117.232);
    annotation2.title    = @"科艺里";
    annotation2.subtitle = @"7:00 12:32 18:32";
    [annotations addObject:annotation2];

    [_mapView addAnnotations:annotations];
    */

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locateMe:(id)sender {
    NSLog(@"realank loc");
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 2000, 2000);
    [_mapView setRegion:region animated:YES];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //_mapView.centerCoordinate = userLocation.location.coordinate;
}

@end
