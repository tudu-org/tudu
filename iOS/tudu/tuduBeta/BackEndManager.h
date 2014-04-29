//
//  BackEndManager.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "BackEndManagerDelegate.h"
#import "TasksManagerDelegate.h"
#import "EventsManagerDelegate.h"
#import "BackEndCommunicatorDelegate.h"
#import "BackEndCommunicator.h"
#import "UserBuilder.h"
#import "TasksBuilder.h"
#import "EventsBuilder.h"
#import "ScheduleBuilder.h"
#import "User.h"

@interface BackEndManager : NSObject<BackEndCommunicatorDelegate> {
    NSNumber *userID;
    NSString *userAuthToken;
}
@property (strong, nonatomic) BackEndCommunicator *communicator;
@property (weak, nonatomic) id<BackEndManagerDelegate> bemDelegate;
@property (weak, nonatomic) id<TasksManagerDelegate> tmDelegate;
@property (weak, nonatomic) id<EventsManagerDelegate> emDelegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


- (void)userLogin:(NSString*)email withPass:(NSString*)password;
- (void)getUserTasks;
- (void)createUserTask:(Task*)task;
- (void)deleteUserTask:(Task*)task;
- (void)updateUserTask:(Task*)task;
- (void)createUserEvent:(EventJSON*)eventJSON;
- (void)getUserEvents;
- (void)scheduleTasks;

@end