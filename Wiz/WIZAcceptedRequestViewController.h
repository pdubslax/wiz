//
//  WIZAcceptedRequestViewController.h
//  Wiz
//
//  Created by Patrick Wilson on 11/28/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import <GoogleMaps/GoogleMaps.h>
#import "PulsingHaloLayer.h"


@interface WIZAcceptedRequestViewController : UIViewController<EDStarRatingProtocol>{


NSTimer *stopTimer;
NSDate *startDate;
bool running;
}

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *jobID;

@property (assign) CGFloat progress;
@property (strong, nonatomic) NSString *sessionLengthString;
@property (strong, nonatomic) UIImageView *wandImageHolder;
@property (strong, nonatomic) UIView *summaryBox;
@property (weak, nonatomic) IBOutlet UILabel *summaryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryDurationLabel;
@property (nonatomic, strong) UILabel *coordinateLabel;

@property (weak, nonatomic) IBOutlet EDStarRating *starRating;
@property (strong,nonatomic) NSArray *colors;
@property (strong, nonatomic) IBOutlet UIImageView *sessionSummaryBoxImageView;
@property (strong, nonatomic) NSString *studentPhone;

@property (assign) double jobLatitude;
@property (assign) double jobLongitude;

@property (weak, nonatomic) IBOutlet UIImageView *studentImageView;
- (IBAction)phoneButtonPressed:(id)sender;
@property (weak, nonatomic) NSString *jobDescriptionString;
@property (strong, nonatomic) UILabel *jobDescription;



@property (strong,nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) PulsingHaloLayer *halo;





@end
