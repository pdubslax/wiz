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

@property (nonatomic) BOOL shown;

@property (nonatomic,strong) NSString* jobID;
@end


@implementation WIZWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.halo = [PulsingHaloLayer layer];
    [self.view.layer addSublayer:self.halo];
    [self wizOnline];
    


    
    
    
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/jobID",sharedManager.uid];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //recived Job request
        //self.JobLabel.text = @"You are Online";
        if (![snapshot.value isEqual:@"-1"]){
            NSString *urlString2 = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/jobs/%@/description",snapshot.value];
            NSString *urlString3 = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/jobs/%@/requesterID",snapshot.value];
            self.jobID = snapshot.value;
            Firebase *jobInfo = [[Firebase alloc] initWithUrl:urlString2];
            Firebase *client = [[Firebase alloc] initWithUrl:urlString3];
            [jobInfo observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot2) {
                [client observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot3) {
                    self.clientID = snapshot3.value;
                    UIAlertView *test = [[UIAlertView alloc] initWithTitle:@"New Job Alert" message:snapshot2.value delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
                    [test show];
                }];
                
                
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
        [self acceptedJobWithJobID:self.jobID];
        
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
    
    //start radar
    [self startRadar];
    
}

- (void)wizOffline{
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/online",sharedManager.uid];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    [myRootRef setValue:@"0"];
    
    [self stopRadar];

    
}

- (IBAction)onlineSwitch:(id)sender {
    if (self.onlineSwitch.isOn){
        [self wizOnline];
    }else{
        
        UILabel *waitingLabel = (UILabel *)[self.view viewWithTag:17];
        [self.view insertSubview:waitingLabel aboveSubview:self.view];
        [self wizOffline];
    }
    
}

- (void)acceptedJobWithJobID:(NSString*)jobID{
    WIZAcceptedRequestViewController *vc = (WIZAcceptedRequestViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"wizmatch"];
    vc.username = [self username];
    vc.jobID = jobID;
    vc.clientID = self.clientID;
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
}


#pragma mark - Radar Animations
- (void)startRadar{
    //start pusling the radar
    self.halo.position = self.view.center;
    self.halo.useTimingFunction = NO;
    self.halo.radius = self.view.frame.size.width / 2;
    self.halo.animationDuration = 2;
    self.halo.name = @"halo";
    self.halo.repeatCount = INFINITY;
    
    
    UIColor *color = [UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1];
    self.halo.backgroundColor = color.CGColor;
    

    
}

- (void)stopRadar{

    
    self.halo.backgroundColor = CFBridgingRetain([UIColor whiteColor]);
    
    
}






@end
