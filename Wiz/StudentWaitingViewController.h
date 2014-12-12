//
//  StudentWaitingViewController.h
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface StudentWaitingViewController : UIViewController
@property (nonatomic, strong) NSString *problemDescription;

@property (strong, nonatomic) UILabel *descriptionLabel;

@property (strong, nonatomic) NSString *username;
- (IBAction)cancelRequest:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) NSString *meetingString;

@property (strong, nonatomic) GMSMapView *mapView;
@property (nonatomic, strong) UILabel *coordinateLabel;
@property (assign) double jobLatitude;
@property (assign) double jobLongitude;



@end
