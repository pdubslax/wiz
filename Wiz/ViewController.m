//
//  ViewController.m
//  Wiz
//
//  Created by Patrick Wilson on 10/26/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
#import "WIZMapViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firebaseLoginWithName:(NSString*)username andPassword:(NSString*)password{
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://fiery-torch-962.firebaseio.com"];
    [ref authUser:username password:password
    withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        // There was an error logging in to this account
    } else {
        // We are now logged in
    }
    }];
}

- (void)firebaseSignUpWithName:(NSString*)username andPassword:(NSString*)password{
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://fiery-torch-962.firebaseio.com"];
    [ref createUser:username password:password
    withCompletionBlock:^(NSError *error) {
    if (error) {
        // There was an error creating the account
    } else {
        // We created a new user account
    }
    }];
}

- (IBAction)user1:(id)sender {
    [self firebaseSignUpWithName:@"user1@wiz.com" andPassword:@"password1"];
    [self firebaseLoginWithName:@"user1@wiz.com" andPassword:@"password1"];
    WIZMapViewController *vc = (WIZMapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"map"];
    [self presentViewController:vc animated:YES completion:^{
        //
    }];
}

- (IBAction)user2:(id)sender {
    [self firebaseSignUpWithName:@"user2@wiz.com" andPassword:@"password2"];
    [self firebaseLoginWithName:@"user2@wiz.com" andPassword:@"password2"];
    WIZMapViewController *vc = (WIZMapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"map"];
    [self presentViewController:vc animated:YES completion:^{
        //
    }];
}

- (IBAction)user3:(id)sender {
    [self firebaseSignUpWithName:@"user3@wiz.com" andPassword:@"password3"];
    [self firebaseLoginWithName:@"user3@wiz.com" andPassword:@"password3"];
    WIZMapViewController *vc = (WIZMapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"map"];
    [self presentViewController:vc animated:YES completion:^{
        //
    }];
}
@end
