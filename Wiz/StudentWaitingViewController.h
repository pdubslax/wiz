//
//  StudentWaitingViewController.h
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentWaitingViewController : UIViewController
@property (nonatomic, strong) NSString *problemDescription;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) NSString *username;
- (IBAction)cancelRequest:(id)sender;
- (IBAction)requestAccepted:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) NSString *meetingString;
@end
