//
//  ViewController.m
//  Wiz
//
//  Created by Patrick Wilson on 10/26/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>

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

- (IBAction)login:(id)sender {
    [self firebaseLoginWithName:@"pdubslax@umich.edu" andPassword:@"swag"];
    
    
}

- (IBAction)signup:(id)sender {
    [self firebaseSignUpWithName:@"pdubslax@umich.edu" andPassword:@"swag"];
}
@end
