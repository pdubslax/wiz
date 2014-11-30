//
//  WIZWaitingViewController.h
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIZWaitingViewController : UIViewController
- (IBAction)switchToStudent:(id)sender;
@property (nonatomic, strong) NSString *username;
@property (strong, nonatomic) IBOutlet UILabel *awaitingLabel;
- (IBAction)onlineSwitch:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *onlineSwitch;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;



@end
