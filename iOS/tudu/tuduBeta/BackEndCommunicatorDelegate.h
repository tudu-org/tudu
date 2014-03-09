//
//  BackEndCommunicatorDelegate.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BackEndCommunicatorDelegate <NSObject>
- (void)successfulUserLogin:(NSData *)objectNotation;
- (void)fetchingLoginFailedWithError:(NSError *)error;

- (void)successfullyFetchedUserTasks:(NSData *)objectNotation;
- (void)fetchingUserTasksFailedWithError:(NSError *)error;
@end
