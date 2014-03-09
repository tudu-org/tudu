//
//  LoginCommunicator.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginCommunicatorDelegate;

@interface LoginCommunicator : NSObject
@property (weak, nonatomic) id<LoginCommunicatorDelegate> delegate;

-(void) userLogin:(NSString *)userEmail withPass:(NSString*)password;

@end