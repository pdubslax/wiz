//
//  StudentWaitingViewController.m
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "StudentWaitingViewController.h"
#import "WIZMapViewController.h"
#import "StudentRequestAcceptedViewController.h"

@interface StudentWaitingViewController ()

@end

@implementation StudentWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    NSString *descriptionString = [NSString stringWithFormat:@"Description: %@", self.problemDescription];
    [self.descriptionLabel setText:descriptionString];
    
    [self.activityIndicator startAnimating];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelRequest:(id)sender {
    WIZMapViewController *vc = (WIZMapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"map"];
    vc.username = [self username];
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
    
}

- (IBAction)requestAccepted:(id)sender {
    StudentRequestAcceptedViewController *vc = (StudentRequestAcceptedViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"accepted"];
    vc.username = [self username];
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
}



@end
