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
#import <Firebase/Firebase.h>
#import "WIZUserDataSharedManager.h"

@interface StudentWaitingViewController ()

@end

@implementation StudentWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSLog(@"meeting location is: %@", self.meetingString);
    
    NSString *descriptionString = [NSString stringWithFormat:@"Description: %@", self.problemDescription];
    [self.descriptionLabel setText:descriptionString];
    
//    NSString *locationString = [NSString stringWithFormat:@"Location: %@", self.meetingString];
    [self.locationLabel setText:self.meetingString];
    [self.activityIndicator startAnimating];
    
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
    [newJob setValue:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:sharedManager.uid,@"-1",@"0",self.problemDescription, nil]
                                          forKeys:[NSArray arrayWithObjects:@"requesterID",@"wizID",@"statusFlag",@"description", nil]]];
    sharedManager.currentJob = newJob.name;
    
    
    Firebase *wizzes = [[Firebase alloc] initWithUrl: @"https://fiery-torch-962.firebaseio.com/wizzes"];
    
    // Attach a block to read the data at our posts reference
    [wizzes observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *keys= [snapshot.value allKeys];
        NSMutableArray *availableWizzes = [[NSMutableArray alloc] init];
        for (NSString *key in keys){
            if ([snapshot.value[key][@"online"]  isEqual: @"1"] && [snapshot.value[key][@"statusFlag"] isEqual: @"0"]){
                [availableWizzes addObject:key];
            }
        }
        NSLog(@"%@",availableWizzes);
        for (NSString *wizID in availableWizzes){
            NSString *tmpString2 = [NSString stringWithFormat:@"%@/jobID",wizID];
            Firebase *specificWiz2 = [wizzes childByAppendingPath:tmpString2];
            [specificWiz2 setValue:newJob.name];
            
            NSString *tmpString = [NSString stringWithFormat:@"%@/beingRequested",wizID];
            Firebase *specificWiz = [wizzes childByAppendingPath:tmpString];
            [specificWiz setValue:@"1"];
            
        }
        
        [wizzes removeAllObservers];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
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
