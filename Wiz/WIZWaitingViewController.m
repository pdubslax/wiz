//
//  WIZWaitingViewController.m
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "WIZWaitingViewController.h"
#import "WIZMapViewController.h"
#import <Firebase/Firebase.h>
#import "WIZUserDataSharedManager.h"

@interface WIZWaitingViewController ()

@end

@implementation WIZWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wizOnline];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)switchToStudent:(id)sender {
    WIZMapViewController *vc = (WIZMapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"map"];
    vc.username = self.username;
    [self presentViewController:vc animated:NO completion:^{
        [self wizOffline];
        //
    }];
}

- (void)wizOnline{
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/online",sharedManager.uid];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    [myRootRef setValue:@"1"];
}

- (void)wizOffline{
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/online",sharedManager.uid];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    [myRootRef setValue:@"0"];
}

- (IBAction)onlineSwitch:(id)sender {
    if (self.onlineSwitch.isOn){
        [self wizOnline];
    }else{
        [self wizOffline];
    }
    
}
@end
