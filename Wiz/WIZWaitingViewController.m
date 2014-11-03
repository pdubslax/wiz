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
    
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/jobID",sharedManager.uid];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //recived Job request
        NSLog(@"%@",snapshot.value);
        self.JobLabel.text = snapshot.value;
        if (![snapshot.value isEqual:@"-1"]){
            NSString *urlString2 = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/jobs/%@/description",snapshot.value];
            Firebase *jobInfo = [[Firebase alloc] initWithUrl:urlString2];
            [jobInfo observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                if (![snapshot.value  isEqual: @"-1"]){
                    UIAlertView *test = [[UIAlertView alloc] initWithTitle:@"New Job Alert" message:snapshot.value delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
                    [test show];
                }
            }];
        }
        
        
        //check if not -1, show job info
        
        
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    //0 is reject
    //1 is accept
    
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
