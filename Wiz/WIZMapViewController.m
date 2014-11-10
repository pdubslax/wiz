//
//  WIZMapViewController.m
//  Wiz
//
//  Created by Patrick Wilson on 10/27/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "WIZMapViewController.h"
#import "StudentWaitingViewController.h"
#import "WIZWaitingViewController.h"


@interface WIZMapViewController (){
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    GMSGeocoder *geocoder_;
    
}

@property (nonatomic,strong) UIButton *setLocationButton;
@property (nonatomic, strong) UILabel *coordinateLabel;
@property (nonatomic, strong) UIView *descriptionBox;



@end

@implementation WIZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager requestAlwaysAuthorization];

    
    //LABEL STUFF
    [self.userLabel setText:[NSString stringWithFormat:@"%@ is logged in",self.username]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.descriptionBox = [[[NSBundle mainBundle] loadNibNamed:@"TaskTwitter" owner:self options:nil] objectAtIndex:0];
    self.descriptionBox.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    self.descriptionBox.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.75].CGColor;
    self.descriptionBox.layer.borderWidth = 5;
    self.descriptionBox.layer.cornerRadius = 10;
    self.descriptionBox.userInteractionEnabled = YES;
    
    
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    
    NSLog(@"%f, %f", coordinate.latitude, coordinate.longitude);
    
    //Set Camera to myLocation
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:15];
    
    
    
    // Create the GMSMapView with the camera position.
    
    
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    //Enable location settings and set Delegate to self
    mapView_.myLocationEnabled = YES;
    mapView_.accessibilityElementsHidden = NO;
    mapView_.settings.myLocationButton = YES;
    mapView_.delegate = self;
    mapView_.userInteractionEnabled = YES;
    
    
    
    //Set observer for MyLocation
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    
    
    //Set Location Button
    self.setLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 60, 200, 30)];
    [self.setLocationButton addTarget:self action:@selector(locationIsSet:) forControlEvents:UIControlEventTouchUpInside];
    [self.setLocationButton setTitle:@"Set Meeting Location" forState:UIControlStateNormal];
    self.setLocationButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    self.setLocationButton.layer.cornerRadius = 15;
    self.setLocationButton.layer.borderWidth = 2;
    self.setLocationButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    
    
    //Pin in middle of the screen
    UIImageView *pinHolder = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 15, self.view.frame.size.height/2 - 30, 30, 30)];
    UIImage *image = [UIImage imageNamed:@"pin.png"];
    pinHolder.image = image;

    
    //Coordinate Label
    
    CGPoint superCenter = CGPointMake(CGRectGetMidX(self.view.bounds), 105);
    self.coordinateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 280, 60)];
    [self.coordinateLabel setCenter:superCenter];
    self.coordinateLabel.backgroundColor = [UIColor colorWithRed:255 green:253 blue:208 alpha:0.8];
    self.coordinateLabel.textAlignment = UITextAlignmentCenter;
    
    
    
    // Set the controller view to be the MapView.
    [self.view insertSubview:mapView_ atIndex:0];
    
    
    //Remove googles stupid gesture blocker
    [WIZMapViewController removeGMSBlockingGestureRecognizerFromMapView:mapView_];
    
    
    //Adding subviews
    [self.view insertSubview:self.coordinateLabel aboveSubview:mapView_];
    [self.view insertSubview:self.setLocationButton aboveSubview:mapView_];
    [self.view insertSubview:pinHolder aboveSubview:mapView_];
    

}


- (void)dealloc {
    [mapView_ removeObserver:self forKeyPath:@"myLocation" context:NULL];
}



//getlocation method
-(CLLocationCoordinate2D) getLocation{
    
    NSLog(@"Get Location was called");

    
    [self.locationManager startUpdatingLocation];
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

#pragma mark - KVO updates

//Method to zoom in on current location at first
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        NSLog(@"not first location update");
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:20];
    }
}

//When button is pressed to Select Meeting Location
- (void)locationIsSet:(UIButton *)button {
    NSLog(@"Location button was pressed");
    
    [self.view insertSubview:self.descriptionBox aboveSubview:mapView_];
    self.characterCount.text = [NSString stringWithFormat:@"140"];
    self.characterCount.textColor = [UIColor whiteColor];
    self.userInput.layer.borderWidth = 1;
    self.userInput.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userInput.layer.cornerRadius = 10;
    self.descriptionBox.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.99];
    [self.requestButton setEnabled:NO];
    
    
    
    
}

//Clear the map view
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    self.setLocationButton.alpha = 0;
    mapView_.settings.myLocationButton = NO;
    self.coordinateLabel.text = @"Go To Pin";
    
    [mapView clear];
}


//When Map becomes still/idle after being moved
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    
    //Make the button re apprear
    self.setLocationButton.alpha = 100;
    mapView_.settings.myLocationButton = YES;
    
    CGPoint point = mapView.center;
    CLLocationCoordinate2D coor = [mapView.projection coordinateForPoint:point];
    NSLog(@"Latitude: %f , Longitude: %f", coor.latitude, coor.longitude);
    
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(coor.latitude,coor.longitude) completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error)
     {
         NSLog( @"Error is %@", error) ;
         NSLog( @"%@" , response.firstResult.addressLine1 ) ;
         NSLog( @"%@" , response.firstResult.addressLine2 ) ;
         //         GMSMarker *marker = [[GMSMarker alloc] init];
         //         marker.position = coor;
         //         marker.title = response.firstResult.addressLine1;
         //         marker.snippet = response.firstResult.addressLine2;
         //         marker.appearAnimation = kGMSMarkerAnimationPop;
         NSArray* parts = [response.firstResult.addressLine2 componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
         
         
         self.addressString = [NSString stringWithFormat:@"%@, %@", response.firstResult.addressLine1, response.firstResult.addressLine2];
         self.coordinateLabel.text = self.addressString;
         
         //marker.map = mapView;
     } ] ;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.characterCount.text = [NSString stringWithFormat:@"%lu", 140-newString.length];
    
    return YES;
}




-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text length] > 0) {
        NSLog(@"text field length: %lu", (unsigned long)[textField.text length]);
        [self.requestButton setEnabled:YES];
    }else{
        
        [self.requestButton setEnabled:NO];
    }
    
    //self.characterCount.text = [NSString stringWithFormat:@"%lu/140", [textField.text length]];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelPressed:(id)sender {
    self.userInput.text = nil;
    [self.descriptionBox removeFromSuperview];
}

- (IBAction)requestPressed:(id)sender {
    
    [self.descriptionBox removeFromSuperview];
    StudentWaitingViewController *vc = (StudentWaitingViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"studentWaiting"];
    vc.problemDescription = self.userInput.text;
    
    vc.meetingString = [NSString stringWithString:self.addressString];
    NSLog(@"addressString: %@", self.addressString);
    vc.username = [self username];
    self.userInput.text = nil;
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
    
}
- (IBAction)switchToWizView:(id)sender {
    WIZWaitingViewController *vc = (WIZWaitingViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"wizWait"];
    vc.username = self.username;
    [self presentViewController:vc animated:NO completion:^{
        //
    }];
    
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


@end
