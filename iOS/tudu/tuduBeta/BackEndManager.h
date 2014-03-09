//
//  BackEndManager.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackEndManagerDelegate.h"
#import "LoginCommunicatorDelegate.h"
#import "LoginCommunicator.h"
#import "UserBuilder.h"

@interface BackEndManager : NSObject<LoginCommunicatorDelegate>
@property (strong, nonatomic) LoginCommunicator *communicator;
@property (weak, nonatomic) id<BackEndManagerDelegate> delegate;

- (void)userLogin:(NSString*)email withPass:(NSString*)password;

@end