//
//  WIZMapViewController.h
//  Wiz
//
//  Created by Patrick Wilson on 10/27/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIZMapViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userInput;
@property (weak, nonatomic) IBOutlet UIButton *requestButton;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)requestPressed:(id)sender;
@property (nonatomic, strong) NSString *username;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
- (IBAction)switchToWizView:(id)sender;


@end
