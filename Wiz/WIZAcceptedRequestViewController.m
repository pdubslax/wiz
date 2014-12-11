//
//  WIZAcceptedRequestViewController.m
//  Wiz
//
//  Created by Patrick Wilson on 11/28/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "WIZAcceptedRequestViewController.h"
#import "FBShimmeringView.h"
#import "WIZWaitingViewController.h"
#import <Firebase/Firebase.h>


@interface WIZAcceptedRequestViewController ()



@end

@implementation WIZAcceptedRequestViewController
{
    UIImageView *_wallpaperView;
    FBShimmeringView *_shimmeringView;
    UIView *_contentView;
    UILabel *_logoLabel;
    
    
    
    CGFloat _panStartValue;
    BOOL _panVertical;
    
    BOOL startedSession;
    BOOL endedSession;
    
    
}
@synthesize starRating=_starRating;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    startedSession = false;
    endedSession = false;
    
    
    _wallpaperView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _wallpaperView.image = [UIImage imageNamed:@"starBackground.jpg"];
    _wallpaperView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_wallpaperView];
    
    
    _shimmeringView = [[FBShimmeringView alloc] init];
    _shimmeringView.shimmering = YES;
    _shimmeringView.shimmeringBeginFadeDuration = 0.3;
    _shimmeringView.shimmeringOpacity = 0.3;
    [self.view addSubview:_shimmeringView];
    
    _logoLabel = [[UILabel alloc] initWithFrame:_shimmeringView.bounds];
    _logoLabel.text = @"swipe to begin session";
    _logoLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32.0];
    _logoLabel.textColor = [UIColor whiteColor];
    _logoLabel.textAlignment = NSTextAlignmentCenter;
    _logoLabel.backgroundColor = [UIColor clearColor];
    _shimmeringView.contentView = _logoLabel;
    
    
    
    self.wandImageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(40, 200, 150, 128)];
    UIImage *image = [UIImage imageNamed:@"yellowWand.png"];
    self.wandImageHolder.image = image;
    self.wandImageHolder.transform = CGAffineTransformMakeRotation((30.0f * M_PI) / 180.0f);
    self.wandImageHolder.center = self.view.center;
    self.wandImageHolder.alpha = 0.0f;
    [self.view addSubview:self.wandImageHolder];
    
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panned:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    
    //set up summary box
    self.summaryBox = [[[NSBundle mainBundle] loadNibNamed:@"sessionSummary" owner:self options:nil] objectAtIndex:0];
    self.summaryBox.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    self.summaryBox.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.75].CGColor;
    self.summaryBox.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.99];
    self.summaryBox.layer.borderWidth = 5;
    self.summaryBox.layer.cornerRadius = 10;
    
    [self setUpRatingView];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect shimmeringFrame = self.view.bounds;
    shimmeringFrame.origin.y = shimmeringFrame.size.height * 0.68;
    shimmeringFrame.size.height = shimmeringFrame.size.height * 0.32;
    _shimmeringView.frame = shimmeringFrame;
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
    self.sessionLengthString = timeString;
}

- (void)startSession{
    //find job id and change the status flag to 2
    Firebase *job = [[Firebase alloc] initWithUrl: @"https://fiery-torch-962.firebaseio.com/jobs/"];
    Firebase * newRoot = [job childByAppendingPath:self.jobID];
    [newRoot updateChildValues:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"2", nil]
                                                           forKeys:[NSArray arrayWithObjects:@"statusFlag", nil]]];
    
}

- (void)endSession{
    //find job id and change the status flag to 3
    
    //session is over, reset the wiz and student info on the db
    // force ratings , update job status
    
    Firebase *job = [[Firebase alloc] initWithUrl: @"https://fiery-torch-962.firebaseio.com/jobs/"];
    Firebase * newRoot = [job childByAppendingPath:self.jobID];
    [newRoot updateChildValues:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"3", nil]
                                                           forKeys:[NSArray arrayWithObjects:@"statusFlag", nil]]];
    
    Firebase *job2 = [[Firebase alloc] initWithUrl: @"https://fiery-torch-962.firebaseio.com/wizzes/"];
    Firebase * newRoot2 = [job2 childByAppendingPath:self.username];
    [newRoot2 updateChildValues:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-1",@"1",@"0", nil]
                                                           forKeys:[NSArray arrayWithObjects:@"jobID",@"online",@"statusFlag", nil]]];
}

#pragma mark - Shimmer Slider

- (void)_panned:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint translation = [panRecognizer translationInView:self.view];
    CGPoint velocity = [panRecognizer velocityInView:self.view];
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        _panVertical = (fabsf(velocity.y) > fabsf(velocity.x));
        
        if (_panVertical) {

        } else {
            _panStartValue = 0;
        }
        
    } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat directional = (_panVertical ? translation.y : translation.x);
        CGFloat possible = (_panVertical ? self.view.bounds.size.height : self.view.bounds.size.width);
        
            self.progress = (directional / possible);
        

        
            
    } else if (panRecognizer.state == UIGestureRecognizerStateEnded ||
               panRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        if (self.progress > .4) {
           //start timer for session
            [self startSession];
            if (startedSession == false) {
                //session Starts here
                
                
                startedSession = true;
                startDate = [NSDate date];
                running = TRUE;
                if (stopTimer == nil) {
                    stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                 target:self
                                                               selector:@selector(updateTimer)
                                                               userInfo:nil
                                                                repeats:YES];
                    
                //change label of shimmer label
                _logoLabel.text = @"swipe to end session";
 
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1.0f];
                    [UIView setAnimationDelegate:self];
                    
                    self.wandImageHolder.transform = CGAffineTransformMakeRotation((305.0f * M_PI) / 180.0f);
                    self.wandImageHolder.center = self.view.center;
                    self.wandImageHolder.alpha = 100.0f;
                    
                    [UIView commitAnimations];
                    [self rotateLeft];
                }
            }else{
                [self endSession];
                
                endedSession = true;
                running = FALSE;
                [stopTimer invalidate];
                stopTimer = nil;
                
                NSLog(@"Session length: %@", self.sessionLengthString );
                
                //self.username isn't the name of the student. need to find this
                Firebase *clientInfo = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/users/%@/name",self.clientID]];
                [clientInfo observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    // do some stuff once
                    self.summaryNameLabel.text = [NSString stringWithFormat:@"Rating for %@?", snapshot.value];
                    self.summaryDurationLabel.text = [NSString stringWithFormat:@"Duration: %@", self.sessionLengthString];
                    
                    [self.view addSubview:self.summaryBox];
                    
                }];
                
                
                
            }
            
        }

    }
}

-(void)rotateLeft{
    
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationCurveLinear animations:^{
        self.wandImageHolder.transform = CGAffineTransformMakeRotation((290.0f * M_PI) / 180.0f);
    } completion:^(BOOL finished){
        [self rotateRight];
    }];
}

-(void)rotateRight{
    
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationCurveLinear animations:^{
        self.wandImageHolder.transform = CGAffineTransformMakeRotation((320.0f * M_PI) / 180.0f);
    } completion:^(BOOL finished){
        [self rotateLeft];
    }];
}

#pragma mark - Star Rating

-(void)setUpRatingView{
    
        self.colors = @[ [UIColor colorWithRed:0.11f green:0.38f blue:0.94f alpha:1.0f], [UIColor colorWithRed:1.0f green:0.22f blue:0.22f alpha:1.0f], [UIColor colorWithRed:0.27f green:0.85f blue:0.46f alpha:1.0f], [UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]];
    _starRating.backgroundColor  = [UIColor whiteColor];
    _starRating.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.maxRating = 5.0;
    _starRating.delegate = self;
    _starRating.horizontalMargin = 15.0;
    _starRating.editable=YES;
    _starRating.rating= 0;
    _starRating.displayMode=EDStarRatingDisplayFull;
    [_starRating  setNeedsDisplay];
    _starRating.tintColor = self.colors[0];
    [self starsSelectionChanged:_starRating rating:0];
    
    Firebase *clientInfo = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/users/%@/photoID",self.clientID]];
    [clientInfo observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.sessionSummaryBoxImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:snapshot.value]]];
    }];

}
-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
    //DO Something once rating is selected
    
    NSLog(@"Rated the Wiz a %f", rating);
    if (rating > 0) {
    
        //change wiz to Online again
    [self dismissViewControllerAnimated:NO completion:nil];
    }
}


@end
