//
//  LoginCommunicator.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "EventJSON.h"

@protocol BackEndCommunicatorDelegate;

@interface BackEndCommunicator : NSObject
@property (weak, nonatomic) id<BackEndCommunicatorDelegate> delegate;

- (void) fetchUserLogin:(NSString *)user_email withPass:(NSString*)password;
- (void) synchFetchUserLogin:(NSString *)user_email withPass:(NSString*)password;

- (void) fetchUserTasks:(NSNumber*)user_id withAuth:(NSString*)auth_token;
- (void) synchFetchUserTasks:(NSNumber*)user_id withAuth:(NSString*)auth_token;

- (void) synchCreateUserTask:(Task*)task withUserID:(NSNumber*)user_id withAuth:(NSString*)auth_token;
- (void) synchDeleteUserTask:(Task*)task withUserID:(NSNumber*)user_id withAuth:(NSString*)auth_token;

-(void) synchCreateUserEvent:(EventJSON*)eventJSON withUserID:(NSNumber*)user_id withAuth:(NSString*)auth_token;

@end