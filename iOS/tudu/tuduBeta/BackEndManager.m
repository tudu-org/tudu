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


/* 
 We override the init function so that we do not have to pass in a user ID and auth token
 for every single call to the back-end.  
 */
- (id)init {
    self = [super init];
    if (self) {
        // CoreData Setup:
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
        
        // Fetch the user account info from core data
        NSArray *fetchedUserRecordsArray = [appDelegate getAllUserRecords];
        User *user = [fetchedUserRecordsArray firstObject];
        userID = user.user_id;
        userAuthToken = user.auth_token;
    }
    return self;
}



/**************************************************************************************
 *********************************   IOS INTERFACE   **********************************
 *************************   BASIC CALLS TO THE JSON BACK-END   ***********************
 **************************************************************************************/

- (void)userLogin:(NSString*)email withPass:(NSString*)password;
{
    //[self.communicator fetchUserLogin:email withPass:password]; //ASYNCH
    [self.communicator synchFetchUserLogin:email withPass:password]; //SYNCH
}

- (void)getUserTasks
{
    //[self.communicator fetchUserTasks:user_id withAuth:auth_token];
    [self.communicator synchFetchUserTasks:userID withAuth:userAuthToken];
}

- (void)createUserTask:(Task*)task
{
    [self.communicator synchCreateUserTask:task withUserID:userID withAuth:userAuthToken];
}

- (void)deleteUserTask:(Task*)task
{
    [self.communicator synchDeleteUserTask:task withUserID:userID withAuth:userAuthToken];
}

- (void)createUserEvent:(EventJSON*)eventJSON {
    [self.communicator synchCreateUserEvent:eventJSON withUserID:userID withAuth:userAuthToken];
}

- (void)getUserEvents
{
    [self.communicator synchFetchUserEvents:userID withAuth:userAuthToken];
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
    /* TODO: implement later.*/
}

- (void)successfullyCreatedTask:(NSData *)objectNotation {
    NSError *error = nil;
    [self.tmDelegate didCreateTask:[TasksBuilder taskFromJSON:objectNotation error:&error]];
}

- (void)createTaskFailedWithError:(NSError *)error {
    
}

- (void)successfullyDeletedUserTasks:(NSData *)objectNotation {
    [self.tmDelegate didDeleteTask];
}

- (void)successfullyCreatedEvent:(NSData *)objectNotation {
    NSError *error = nil;
    [self.emDelegate didCreateEvent:[EventsBuilder eventFromJSON:objectNotation error:&error]];
}

- (void)createEventFailedWithError:(NSError *)error {
    /* TODO: implement later. */
}

- (void) fetchingUserEventsFailedWithError:(NSError *)error {
    /* TODO: implement later.*/
}

- (void)successfullyFetchedUserEvents:(NSData *)objectNotation {
    
    NSError *error = nil;
    NSArray *events = [EventsBuilder eventsFromJSON:objectNotation error:&error];
    
    // These methods call into the BackEndManagerDelegate, which
    // is implemented in the various ViewControllers of this app
    if (error != nil) {
        /* TODO: implement later. */
        //[self.tmDelegate userLoginFailedWithError:error];
    } else {
        [self.emDelegate didReceiveEventsArray:events];
    }
}



@end








