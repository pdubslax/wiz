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
    
    // Set the controller view to be the MapView.

    
    [WIZWaitingViewController removeGMSBlockingGestureRecognizerFromMapView:self.mapView];
    self.halo = [PulsingHaloLayer layer];
    [self.mapView.layer addSublayer:self.halo];
    

    
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/jobID",sharedManager.uid];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //recived Job request
        //self.JobLabel.text = @"You are Online";
        if (![snapshot.value isEqual:@"-1"]){
            
            NSString *jobURL = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/jobs/%@",snapshot.value];
            
            Firebase *job = [[Firebase alloc] initWithUrl:jobURL];

            self.jobID = snapshot.value;
            
            [job observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot2) {
                self.clientID = snapshot2.value[@"requesterID"];
                UIAlertView *newJobAlert = [[UIAlertView alloc] initWithTitle:@"New Job Alert" message:snapshot2.value[@"description"] delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
                self.coordinateLabel.hidden = YES;
                
                
                NSString *latitudeString = snapshot2.value[@"latitude"];
                NSString *longitudeString = snapshot2.value[@"longitude"];
                
                self.jobLatitude = [latitudeString doubleValue];
                self.jobLongitude = [longitudeString doubleValue];
                
                self.mapView.camera = [GMSCameraPosition cameraWithTarget:self.mapView.camera.target zoom:13];
                [self createMarkerWithLatitude:self.jobLatitude withLongitude:self.jobLongitude withTitle:@"new job"];
                
                
                [newJobAlert show];
                
            }];
        }
        
        
        //check if not -1, show job info
        
        
    }];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    //Remove googles stupid gesture blocker
    self.mapView.delegate = self;
    [self.mapView clear];

    
    [self.view insertSubview:self.mapView atIndex:0];
    
    self.coordinateLabel.hidden = NO;
    self.coordinateLabel.text = @"waiting for incoming requests";
    [self.view insertSubview:self.coordinateLabel aboveSubview:self.mapView];
    

    [self wizOnline];
    
    
    
}

-(void)createMarkerWithLatitude: (double)latitude withLongitude: (double)longitude withTitle: (NSString *)title{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = title;
    marker.map = self.mapView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)removeGMSBlockingGestureRecognizerFromMapView:(GMSMapView *)mapView
{
    if([mapView.settings respondsToSelector:@selector(consumesGesturesInView)]) {
        mapView.settings.consumesGesturesInView = NO;
    }
    else {
        for (id gestureRecognizer in mapView.gestureRecognizers)
        {
            if (![gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
            {
                [mapView removeGestureRecognizer:gestureRecognizer];
            }
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if ((long)buttonIndex==0) {
        
        self.coordinateLabel.hidden = NO;
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
    vc.mapView = self.mapView;
    vc.halo = self.halo;
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
