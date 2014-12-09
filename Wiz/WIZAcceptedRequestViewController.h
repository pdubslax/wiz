//
//  WIZAcceptedRequestViewController.h
//  Wiz
//
//  Created by Patrick Wilson on 11/28/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"


@interface WIZAcceptedRequestViewController : UIViewController<EDStarRatingProtocol>{


NSTimer *stopTimer;
NSDate *startDate;
bool running;
}
@property (nonatomic, strong) NSString *wizName;
@property (nonatomic, strong) NSString *username;
@property (assign) CGFloat progress;
@property (strong, nonatomic) NSString *sessionLengthString;
@property (strong, nonatomic) UIImageView *wandImageHolder;
@property (strong, nonatomic) UIView *summaryBox;
@property (weak, nonatomic) IBOutlet UILabel *summaryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryCostLabel;

@property (weak, nonatomic) IBOutlet EDStarRating *starRating;
@property (strong,nonatomic) NSArray *colors;





@end
