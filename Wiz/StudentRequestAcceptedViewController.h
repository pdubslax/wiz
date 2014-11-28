//
//  StudentRequestAcceptedViewController.h
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentWaitingViewController.h"

@interface StudentRequestAcceptedViewController : UIViewController
@property (nonatomic, strong) NSString *wizName;
@property (nonatomic, strong) NSString *username;
@property (strong, nonatomic) IBOutlet UILabel *informationLabel;




@end
