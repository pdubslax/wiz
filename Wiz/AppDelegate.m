//
//  AppDelegate.m
//  Wiz
//
//  Created by Patrick Wilson on 10/26/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "AppDelegate.h"
#import <Firebase/Firebase.h>
#import "WIZUserDataSharedManager.h"
#import <GoogleMaps/GoogleMaps.h>
#import "WIZMapViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Add in your API key here:
    [GMSServices provideAPIKey:@"AIzaSyDyeIUUfpbwGJ7bkSWK4H2fZiW9wbgzi5g"];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/users/%@/statusFlag",sharedManager.uid];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    [myRootRef setValue:@"0"];
    
    NSString *urlString2 = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/online",sharedManager.uid];
    Firebase *myRootRef2 = [[Firebase alloc] initWithUrl:urlString2];
    [myRootRef2 setValue:@"0"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
//    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/users/%@/statusFlag",sharedManager.uid];
//    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
//    [myRootRef setValue:@"1"];
//    
//    NSString *urlString2 = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/online",sharedManager.uid];
//    Firebase *myRootRef2 = [[Firebase alloc] initWithUrl:urlString2];
//    [myRootRef2 setValue:@"1"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    WIZUserDataSharedManager *sharedManager = [WIZUserDataSharedManager sharedManager];
    NSString *urlString = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/users/%@/statusFlag",sharedManager.uid];
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:urlString];
    [myRootRef setValue:@"0"];
    
    NSString *urlString2 = [NSString stringWithFormat:@"https://fiery-torch-962.firebaseio.com/wizzes/%@/online",sharedManager.uid];
    Firebase *myRootRef2 = [[Firebase alloc] initWithUrl:urlString2];
    [myRootRef2 setValue:@"0"];
    
}

@end
