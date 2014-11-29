//
//  WIZAcceptedRequestViewController.m
//  Wiz
//
//  Created by Patrick Wilson on 11/28/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "WIZAcceptedRequestViewController.h"

@interface WIZAcceptedRequestViewController ()



@end

@implementation WIZAcceptedRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timerLabel.text = @"00.00.00";
    self.timerLabel.hidden = YES;
    running = FALSE;
    
    self.endSession.hidden = YES;
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

-(void)updateTimer{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.timerLabel.text = timeString;
    
}
- (IBAction)startSessionPressed:(id)sender {
    self.startSession.hidden = YES;
    self.endSession.hidden = NO;
    self.timerLabel.hidden = NO;
    
    startDate = [NSDate date];
        running = TRUE;
        if (stopTimer == nil) {
            stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(updateTimer)
                                                       userInfo:nil
                                                        repeats:YES];
        }

    
}
- (IBAction)endSessionPressed:(id)sender {

        running = FALSE;
        [stopTimer invalidate];
        stopTimer = nil;
    
    
    
}
@end
