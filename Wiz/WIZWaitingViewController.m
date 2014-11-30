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
#import "WIZAcceptedRequestViewController.h"
#import "MultiplePulsingHaloLayer.h"
#import "PulsingHaloLayer.h"

@interface WIZWaitingViewController ()

@end

@implementation WIZWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wizOnline];
    
    
    
        PulsingHaloLayer *halo = [PulsingHaloLayer layer];
        halo.position = self.view.center;
        halo.useTimingFunction = NO;
        halo.radius = self.view.frame.size.width / 2;
        halo.animationDuration = 2;
        [self.view.layer addSublayer:halo];

    
    
    
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/jobID",sharedManager.uid];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //recived Job request
        //self.JobLabel.text = @"You are Online";
        if (![snapshot.value isEqual:@"-1"]){
            NSString *urlString2 = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/jobs/%@/description",snapshot.value];
            Firebase *jobInfo = [[Firebase alloc] initWithUrl:urlString2];
            [jobInfo observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot2) {
                
                UIAlertView *test = [[UIAlertView alloc] initWithTitle:@"New Job Alert" message:snapshot2.value delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
                [test show];
                
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
    if ((long)buttonIndex==0) {
        self.statusLabel.text = @"Awaiting Incoming Requests";
        [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                       selector: @selector(clearText) userInfo: nil repeats: NO];
        WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
        NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/",sharedManager.uid];
        Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
        [myRootRef updateChildValues:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",@"-1",@"1",@"2", nil]
                                                     forKeys:[NSArray arrayWithObjects:@"beingRequested",@"jobID",@"online",@"statusFlag", nil]]];
        [myRootRef updateChildValues:[NSDictionary dictionaryWithObject:@"0" forKey:@"statusFlag"]];
        
    }else{
        //accepted job
        //status flag to 1
        WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
        NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/",sharedManager.uid];
        Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
        [myRootRef updateChildValues:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0",@"1", nil]
                                                                 forKeys:[NSArray arrayWithObjects:@"beingRequested",@"statusFlag", nil]]];
        [self acceptedJob];
        
    }
    
}

- (void)clearText{

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

- (void)acceptedJob{
    WIZAcceptedRequestViewController *vc = (WIZAcceptedRequestViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"wizmatch"];
    vc.username = [self username];
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
}






@end
