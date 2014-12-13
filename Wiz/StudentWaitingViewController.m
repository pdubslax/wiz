//
//  StudentWaitingViewController.m
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "StudentWaitingViewController.h"
#import "WIZMapViewController.h"
#import "StudentRequestNoMatchViewController.h"
#import <Firebase/Firebase.h>
#import "WIZUserDataSharedManager.h"

@interface StudentWaitingViewController ()
@property (nonatomic,strong) NSMutableArray *availableWizzes;
@end

@implementation StudentWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mapView clear];
    
    self.progressView.progress = 0.0;
    [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
    
    [self.view insertSubview:self.mapView atIndex:0];
    
    
    
    
    [self.view insertSubview:self.coordinateLabel aboveSubview:self.mapView];
    
    NSString *descriptionString = [NSString stringWithFormat:@"%@", self.problemDescription];
    
    CGPoint superCenter = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 375, 280, 120)];
    [self.descriptionLabel setCenter:superCenter];
    self.descriptionLabel.backgroundColor = [UIColor colorWithRed:255 green:253 blue:208 alpha:1];
    self.descriptionLabel.textAlignment = UITextAlignmentCenter;
    self.descriptionLabel.numberOfLines = 0;
    [self.descriptionLabel setText:descriptionString];
    self.descriptionLabel.layer.borderWidth = 5;
    self.descriptionLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.descriptionLabel.layer.cornerRadius = 10;
    self.descriptionLabel.clipsToBounds = YES;

    
    
    [self.view insertSubview:self.descriptionLabel aboveSubview:self.mapView];
    
    
    [self makeRequest];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeRequest {
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/jobs/"];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    Firebase *newJob = [myRootRef childByAutoId];
    
    NSString *latitudeString = [NSString stringWithFormat:@"%f", self.jobLatitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%f", self.jobLongitude];
    
    [newJob setValue:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:sharedManager.uid,@"-1",@"0",self.problemDescription,latitudeString, longitudeString, self.coordinateLabel.text, nil] forKeys:[NSArray arrayWithObjects:@"requesterID",@"wizID",@"statusFlag",@"description", @"latitude", @"longitude",@"addressString", nil]]];
    
    sharedManager.currentJob = newJob.name;
    
    
    Firebase *wizzes = [[Firebase alloc] initWithUrl: @"https://fiery-torch-962.firebaseio.com/wizzes"];
    
    // Attach a block to read the data at our posts reference
    [wizzes observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *keys= [snapshot.value allKeys];
        self.availableWizzes = [[NSMutableArray alloc] init];
        for (NSString *key in keys){
            if ([snapshot.value[key][@"online"]  isEqual: @"1"] && [snapshot.value[key][@"statusFlag"] isEqual: @"0"]){
                [self.availableWizzes addObject:key];
            }
        }
        NSLog(@"%@",self.availableWizzes);
        if ([self.availableWizzes count]>0){
            [self requestManager:self.availableWizzes withJobName:newJob.name];
        }else{
            [self noMatch];
        }
        [wizzes removeAllObservers];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    
    
}

- (void)requestManager:(NSArray*)availableWizzes withJobName:(NSString*)newJobName{
    Firebase *wizzes = [[Firebase alloc] initWithUrl: @"https://fiery-torch-962.firebaseio.com/wizzes"];
    NSString *wizID = [self.availableWizzes firstObject];
    NSString *tmpString2 = [NSString stringWithFormat:@"%@/",wizID];
    Firebase *specificWiz2 = [wizzes childByAppendingPath:tmpString2];
    
    [specificWiz2 updateChildValues:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",newJobName, nil]
                                                                forKeys:[NSArray arrayWithObjects:@"beingRequested",@"jobID", nil]]];
    Firebase *test = [specificWiz2 childByAppendingPath:@"statusFlag"];
    [test observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value isEqual:@"1"]){
            //they have accepted the job
            [test removeAllObservers];
            [self requestAccepted:[self.availableWizzes firstObject] withJobID:newJobName];
        }
        else if ([snapshot.value isEqual:@"2"]){
            //they have denied the job
            [test removeAllObservers];
            [self.availableWizzes removeObject:wizID];
            if ([self.availableWizzes count]>0){
                [self requestManager:self.availableWizzes withJobName:newJobName];
            }
        }
        if ([self.availableWizzes count]==0){
            //sorry no one accepted your job
            NSLog(@"No one can field your request");
            [test removeAllObservers];
            [self noMatch];
        }
    }];
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
    //TODO handle the canceling of wizzes here
    
    WIZMapViewController *vc = (WIZMapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"map"];
    vc.username = [self username];
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
    
}

- (void)noMatch{
    StudentRequestNoMatchViewController *vc = (StudentRequestNoMatchViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"nomatch"];
    vc.username = [self username];
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
}

- (void)requestAccepted:(NSString*)userID withJobID:(NSString *)jobID{
    //TODO Update wizid for job on backend here
    //manage the status flag on the job
    
    Firebase *job = [[Firebase alloc] initWithUrl: @"https://fiery-torch-962.firebaseio.com/jobs/"];
    Firebase * newRoot = [job childByAppendingPath:jobID];
    [newRoot updateChildValues:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:userID,@"1", nil]
                                                          forKeys:[NSArray arrayWithObjects:@"wizID",@"statusFlag", nil]]];
    WIZMapViewController *vc = (WIZMapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"map"];
    vc.username = self.username;
    vc.wizName = userID;
    vc.inSession = true;
    vc.jobID = jobID;
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
}

#pragma mark - Progress Bar Animation
- (void)makeMyProgressBarMoving {
    
    float actual = [self.progressView progress];
    if (actual < 1) {
        self.progressView.progress = actual + 0.01;
        [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
    }
    else{
        self.progressView.progress = 0;
        [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
        
        
    }
    
}



@end
