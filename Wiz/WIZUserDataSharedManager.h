//
//  WIZUserDataSharedManager.h
//  Wiz
//
//  Created by Patrick Wilson on 11/2/14.
//  Copyright (c) 2014 Patrick Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIZUserDataSharedManager : NSObject{
    NSString *uid;
    NSString *currentJob;
}

@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *currentJob;

+ (id)sharedManager;

@end

