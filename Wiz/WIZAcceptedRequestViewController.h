//
//  WIZAcceptedRequestViewController.h
//  Wiz
//
//  Created by Patrick Wilson on 11/28/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIZAcceptedRequestViewController : UIViewController{


NSTimer *stopTimer;
NSDate *startDate;
bool running;
}
@property (nonatomic, strong) NSString *wizName;
@property (nonatomic, strong) NSString *username;
@property (weak, nonatomic) IBOutlet UIButton *startSession;
- (IBAction)startSessionPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *endSession;
- (IBAction)endSessionPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;


@end
