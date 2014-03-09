//
//  LoginCommunicator.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "BackEndCommunicator.h"
#import "BackEndCommunicatorDelegate.h"
#import "HUD.h"

#define SERVER_STRING @"http://localhost:3000"
#define USER_LOGIN_PATH @"/login.json"

@implementation BackEndCommunicator


/* 
 USER LOG IN:
 POST /login.json
 
 {
 "email": "foo@bar.com",
 "password": "mysupersecretpassword"
 }
*/
- (void) fetchUserLogin:(NSString *)userEmail withPass:(NSString*)password {
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:SERVER_STRING];
    [queryString appendString:USER_LOGIN_PATH];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     queryString]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    userEmail, @"email",
                                    password, @"password",
                                    nil];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // should check for and handle errors here but we aren't
    [theRequest setHTTPBody:jsonData];
    
    // We do not want to block the UI, so we send an ASYNCHRONOUS request
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // We send the data to the delegate for future processing:
        if (error) {
            [self.delegate fetchingLoginFailedWithError:error];
        } else {
            [self.delegate successfulUserLogin:data];
        }
    }];
}


/*
 INDEX USER TASKS:
 GET /users/$(userid)/tasks.json?auth_token=$(auth_token)
 */
- (void)fetchUserTasks:(NSNumber*)user_id withAuth:(NSString*)auth_token {
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:SERVER_STRING];
    [queryString appendString:[NSString stringWithFormat:@"/users/%@/tasks.json?auth_token=%@",user_id,auth_token]];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     queryString]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    [theRequest setHTTPMethod:@"GET"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // We do not want to block the UI, so we send an ASYNCHRONOUS request
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // We send the data to the delegate for future processing:
        if (error) {
            [self.delegate fetchingUserTasksFailedWithError:error];
        } else {
            [self.delegate successfullyFetchedUserTasks:data];
        }
    }];
    
}


@end



















