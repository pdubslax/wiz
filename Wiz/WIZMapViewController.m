//
//  WIZMapViewController.m
//  Wiz
//
//  Created by Patrick Wilson on 10/27/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "WIZMapViewController.h"
#import "StudentWaitingViewController.h"
#import "WIZWaitingViewController.h"


@interface WIZMapViewController ()

@property (nonatomic,strong) UIButton *setLocationButton;
@property (nonatomic, strong) UILabel *coordinateLabel;
@property (nonatomic, strong) UIView *descriptionBox;

@end

@implementation WIZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.userLabel setText:[NSString stringWithFormat:@"%@ is logged in",self.username]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.descriptionBox = [[[NSBundle mainBundle] loadNibNamed:@"TaskTwitter" owner:self options:nil] objectAtIndex:0];
    self.descriptionBox.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    self.descriptionBox.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.75].CGColor;
    self.descriptionBox.layer.borderWidth = 5;
    self.descriptionBox.layer.cornerRadius = 10;
    self.descriptionBox.userInteractionEnabled = YES;
    
    //Set Location Button
    self.setLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 60, 200, 30)];
    [self.setLocationButton addTarget:self action:@selector(locationIsSet:) forControlEvents:UIControlEventTouchUpInside];
    [self.setLocationButton setTitle:@"Set Meeting Location" forState:UIControlStateNormal];
    self.setLocationButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    self.setLocationButton.layer.cornerRadius = 15;
    self.setLocationButton.layer.borderWidth = 2;
    self.setLocationButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    
    
    //Pin in middle of the screen
    UIImageView *pinHolder = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 15, self.view.frame.size.height/2 - 30, 30, 30)];
    UIImage *image = [UIImage imageNamed:@"pin.png"];
    pinHolder.image = image;

    
    [self.view addSubview:self.setLocationButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationIsSet:(UIButton *)button {
    NSLog(@"Location button was pressed");
    
    [self.view addSubview:self.descriptionBox];
    self.characterCount.text = [NSString stringWithFormat:@"140"];
    self.characterCount.textColor = [UIColor whiteColor];
    self.userInput.layer.borderWidth = 1;
    self.userInput.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userInput.layer.cornerRadius = 10;
    self.descriptionBox.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.99];
    [self.requestButton setEnabled:NO];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.characterCount.text = [NSString stringWithFormat:@"%lu", 140-newString.length];
    
    return YES;
}




-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text length] > 0) {
        NSLog(@"text field length: %lu", (unsigned long)[textField.text length]);
        [self.requestButton setEnabled:YES];
    }else{
        
        [self.requestButton setEnabled:NO];
    }
    
    //self.characterCount.text = [NSString stringWithFormat:@"%lu/140", [textField.text length]];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelPressed:(id)sender {
    self.userInput.text = nil;
    [self.descriptionBox removeFromSuperview];
}

- (IBAction)requestPressed:(id)sender {
    
    [self.descriptionBox removeFromSuperview];
    StudentWaitingViewController *vc = (StudentWaitingViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"studentWaiting"];
    vc.problemDescription = self.userInput.text;
    vc.username = [self username];
    self.userInput.text = nil;
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
    
}
- (IBAction)switchToWizView:(id)sender {
    WIZWaitingViewController *vc = (WIZWaitingViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"wizWait"];
    vc.username = self.username;
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
    
}
@end
