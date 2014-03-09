//
//  LoginCommunicator.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BackEndCommunicatorDelegate;

@interface BackEndCommunicator : NSObject
@property (weak, nonatomic) id<BackEndCommunicatorDelegate> delegate;

- (void) fetchUserLogin:(NSString *)userEmail withPass:(NSString*)password;
- (void) fetchUserTasks:(NSNumber*)user_id withAuth:(NSString*)auth_token;

@end