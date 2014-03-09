//
//  LoginCommunicator.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "LoginCommunicator.h"
#import "LoginCommunicatorDelegate.h"
#import "HUD.h"

@implementation LoginCommunicator

-(void) userLogin:(NSString *)userEmail withPass:(NSString*)password {
    NSString *queryString = @"http://localhost:3000/login.json";
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

@end
