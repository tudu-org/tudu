//
//  BackEndManager.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "BackEndManager.h"

@implementation BackEndManager
@synthesize communicator;
- (void)userLogin:(NSString*)email withPass:(NSString*)password;
{
    [self.communicator userLogin:email withPass:password];
}


#pragma mark - LoginCommunicatorDelegate

- (void)successfulUserLogin:(NSData *)objectNotation
{
    NSError *error = nil;
    UserJSON *user = [UserBuilder userFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate userLoginFailedWithError:error];
        
    } else {
        [self.delegate didReceiveLoggedInUser:user];
    }
}

- (void)fetchingLoginFailedWithError:(NSError *)error
{
    [self.delegate userLoginFailedWithError:error];
}

@end
