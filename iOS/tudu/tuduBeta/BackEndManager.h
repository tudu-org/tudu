//
//  BackEndManager.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackEndManagerDelegate.h"
#import "TasksManagerDelegate.h"
#import "BackEndCommunicatorDelegate.h"
#import "BackEndCommunicator.h"
#import "UserBuilder.h"
#import "TasksBuilder.h"

@interface BackEndManager : NSObject<BackEndCommunicatorDelegate>
@property (strong, nonatomic) BackEndCommunicator *communicator;
@property (weak, nonatomic) id<BackEndManagerDelegate> bemDelegate;
@property (weak, nonatomic) id<TasksManagerDelegate> tmDelegate;

- (void)userLogin:(NSString*)email withPass:(NSString*)password;
- (void)getUserTasks:(NSNumber*)user_id withAuth:(NSString *)auth_token;
- (void)createUserTask:(Task*)task withUserID:(NSNumber*)user_id withAuth:(NSString*)auth_token;
- (void)deleteUserTask:(Task*)task withUserID:(NSNumber*)user_id withAuth:(NSString*)auth_token;

@end