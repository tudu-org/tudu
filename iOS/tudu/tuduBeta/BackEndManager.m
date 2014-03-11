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
    //[self.communicator fetchUserLogin:email withPass:password]; //ASYNCH
    [self.communicator synchFetchUserLogin:email withPass:password]; //SYNCH
}

- (void)getUserTasks:(NSNumber*)user_id withAuth:(NSString*)auth_token
{
    //[self.communicator fetchUserTasks:user_id withAuth:auth_token];
    [self.communicator synchFetchUserTasks:user_id withAuth:auth_token];
}

#pragma mark - BackEndCommunicatorDelegate
// These are the methods that are returned once the actual NSData has been received.
// This class is responsible for managing that NSData, formatting it, etc.

- (void)successfulUserLogin:(NSData *)objectNotation
{
    NSError *error = nil;
    UserJSON *user = [UserBuilder userFromJSON:objectNotation error:&error];
    
    // These methods call into the BackEndManagerDelegate, which
    // is implemented in the various ViewControllers of this app
    if (error != nil) {
        [self.bemDelegate userLoginFailedWithError:error];
        
    } else {
        [self.bemDelegate didReceiveLoggedInUser:user];
    }
}

- (void)fetchingLoginFailedWithError:(NSError *)error
{
    [self.bemDelegate userLoginFailedWithError:error];
}


- (void)successfullyFetchedUserTasks:(NSData *)objectNotation {

    NSError *error = nil;
    NSArray *tasks = [TasksBuilder tasksFromJSON:objectNotation error:&error];
    
    // These methods call into the BackEndManagerDelegate, which
    // is implemented in the various ViewControllers of this app
    if (error != nil) {
        //[self.tmDelegate userLoginFailedWithError:error];
    } else {
        [self.tmDelegate didReceiveTasksArray:tasks];
    }
}
- (void)fetchingUserTasksFailedWithError:(NSError *)error {
    
}


@end








