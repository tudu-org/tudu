//
//  WebBackEndManager.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "WebBackEndManager.h"

#define CREATE_USER 1
#define USER_LOGIN 2
#define GET_EVENTS 3
#define CREATE_EVENT 4
#define MODIFY_EVENT 5
#define DELETE_EVENT 6
#define CREATE_TASK 7
#define GET_TASKS 8
#define UPDATE_TASK 9
#define DELETE_TASK 10
#define SCHEDULE_TASKS 11
#define GET_SCHEDULE 12

@implementation WebBackEndManager
@synthesize _receivedData, managedObjectContext;

int operationID = 0;
-(void) userLogin:(NSString *)userEmail withPass:(NSString*)password {
    // CoreData Setup:
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    // Show the spinning activity indicator:
    [HUD showUIBlockingIndicatorWithText:@"Verifying Login Info"];
    operationID = USER_LOGIN;
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
    
    
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (con) {
        _receivedData=[NSMutableData data];
    } else {
        //something bad happened
    }
}

#pragma NSUrlConnectionDelegate Methods

-(void)connection:(NSConnection*)conn didReceiveResponse:(NSURLResponse *)response
{
    if (_receivedData == NULL) {
        _receivedData = [[NSMutableData alloc] init];
    }
    [_receivedData setLength:0];
    NSLog(@"didReceiveResponse: responseData length:(%d)", _receivedData.length);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d bytes of data",[_receivedData length]);
    
    NSString *responseText = [[NSString alloc] initWithData:_receivedData encoding: NSASCIIStringEncoding];
    NSLog(@"Response: %@", responseText);
    
    NSString *newLineStr = @"\n";
    responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];

    
    /* This is very important- we have multiple methods in this class using the same NSUrlConnectionDelegate.
     * Each method sets the 'operationID' of the class object, so here we are checking which method is being called
     * and parsing the returned data accordingly. */
    
    if (operationID == USER_LOGIN) {
        [HUD hideUIBlockingIndicator];

        // Now create a NSDictionary from the JSON data
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:_receivedData options:0 error:nil];

        NSLog(@"User's id = %@",[jsonDictionary objectForKey:@"id"]);
        NSLog(@"User's auth_token = %@",[jsonDictionary objectForKey:@"auth_token"]);
    }
}


@end



