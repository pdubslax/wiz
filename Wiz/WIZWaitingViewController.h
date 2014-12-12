//
//  WIZWaitingViewController.h
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulsingHaloLayer.h"
#import <GoogleMaps/GoogleMaps.h>

@interface WIZWaitingViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>
- (IBAction)switchToStudent:(id)sender;
@property (nonatomic, strong) NSString *username;
- (IBAction)onlineSwitch:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *onlineSwitch;

@property (strong, nonatomic) PulsingHaloLayer *halo;
@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *jobDescriptionString;
@property (strong, nonatomic) GMSMapView *mapView;
@property (nonatomic, strong) UILabel *coordinateLabel;
@property (assign) double jobLatitude;
@property (assign) double jobLongitude;
@property (strong, nonatomic) IBOutlet UIView *jobAlert;
@property (weak, nonatomic) IBOutlet UIImageView *studentImageView;
@property (weak, nonatomic) IBOutlet UILabel *studentName;
@property (weak, nonatomic) IBOutlet UITextView *studentJobDescription;

- (IBAction)jobAccepted:(id)sender;
- (IBAction)jobRejected:(id)sender;




@end
