
//
//  WIZUserDataSharedManager.m
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import "WIZUserDataSharedManager.h"

@implementation WIZUserDataSharedManager

@synthesize uid,currentJob;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static WIZUserDataSharedManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        uid = @"";
        currentJob = @"";
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
