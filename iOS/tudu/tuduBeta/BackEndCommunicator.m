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

#define SERVER_STRING @"http://afternoon-cove-9264.herokuapp.com"
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
- (void) fetchUserLogin:(NSString *)user_email withPass:(NSString*)password {
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:SERVER_STRING];
    [queryString appendString:USER_LOGIN_PATH];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     queryString]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    user_email, @"email",
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
        
        // We send the data to the delegate for further processing:
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
        // We send the data to the delegate for further processing:
        if (error) {
            [self.delegate fetchingUserTasksFailedWithError:error];
        } else {
            [self.delegate successfullyFetchedUserTasks:data];
        }
    }];
}


/*  SYNCHRONOUS GET USER TASKS:

    GET /users/$(userid)/tasks.json?auth_token=$(auth_token)
 */
- (void)synchFetchUserTasks:(NSNumber*)user_id withAuth:(NSString*)auth_token {
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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:theRequest
                                                     returningResponse:&response
                                                                 error:&error];
        
        // We send the data to the delegate for further processing:
        if (error) {
            [self.delegate fetchingUserTasksFailedWithError:error];
        } else {
            [self.delegate successfullyFetchedUserTasks:receivedData];
        }
    });
}


/*  SYNCHRONOUS USER LOG IN
 
    POST /login.json
    {
        "email": "foo@bar.com",
        "password": "mysupersecretpassword"
    }
*/
- (void) synchFetchUserLogin:(NSString *)user_email withPass:(NSString*)password {
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:SERVER_STRING];
    [queryString appendString:USER_LOGIN_PATH];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     queryString]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    user_email, @"email",
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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:theRequest
                                                     returningResponse:&response
                                                                 error:&error];
        
        if (error) {
            [self.delegate fetchingLoginFailedWithError:error];
        } else {
            [self.delegate successfulUserLogin:receivedData];
        }
    });
}



/*  SYNCHRONOUS CREATE TASK
 
    POST /users/$(userid)/tasks.json
    {
        "auth_token": "2b770a48ef008c185ea20cd6237fcfab",
        "task":{
        "name":"Cool New Task!",
        "description":"It even has a description, wow!",
        "priority":8,
        "deadline":"2014-03-27T10:18:00.000Z"
        }
    }
*/
- (void) synchCreateUserTask:(Task*)task withUserID:(NSNumber*)user_id withAuth:(NSString*)auth_token {
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:SERVER_STRING];
    [queryString appendString:[NSString stringWithFormat:@"/users/%@/tasks.json",user_id]];
     NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                      requestWithURL:[NSURL URLWithString:
                                                      queryString]
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                      timeoutInterval:60.0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yyyy-MM-ddEEEEEhh:mm:SSSSS"];   //2014-03-10T18:29:00.000Z     is this correct?
    
     NSDictionary *taskDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     task.name, @"name",
                                     task.description, @"description",
                                     task.priority, @"priority",
                                     [dateFormatter stringFromDate:task.deadline], @"deadline", // Is it necessary to cast to a string?
                                     nil];
     NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     auth_token, @"auth_token",
                                     taskDictionary, @"task", // Nest the task inside this dictionary
                                     nil];
     NSError *error;
     NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                        options:NSJSONWritingPrettyPrinted error:&error];
     [theRequest setHTTPMethod:@"POST"];
     [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // should check for and handle errors here but we aren't
    [theRequest setHTTPBody:jsonData];
    // We do not want to block the UI, so we send an ASYNCHRONOUS request
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:theRequest
                                                     returningResponse:&response
                                                                 error:&error];

        if (error) {
            [self.delegate createTaskFailedWithError:error];
        } else {
            [self.delegate successfullyCreatedTask:receivedData];
        }
    });
}


/*  SYNCHRONOUSLY DELETE TASK
    DELETE /users/$(userid)/tasks/$(taskid).json?auth_token=2b770a48ef008c185ea20cd6237fcfab
*/
- (void) synchDeleteUserTask:(Task*)task withUserID:(NSNumber*)user_id withAuth:(NSString*)auth_token {
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:SERVER_STRING];
    [queryString appendString:[NSString stringWithFormat:@"/users/%@/tasks/%@.json?auth_token=%@",user_id,task.task_id,auth_token]];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     queryString]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    [theRequest setHTTPMethod:@"DELETE"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // We do not want to block the UI, so we send an ASYNCHRONOUS request
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:theRequest
                                                     returningResponse:&response
                                                                 error:&error];
        
        // We send the data to the delegate for further processing:
        if (error) {
            /* TODO: Implement error-checking. */
            //[self.delegate fetchingUserTasksFailedWithError:error];
        } else {
            [self.delegate successfullyDeletedUserTasks:receivedData];
        }
    });
}



/*  SYCHRONOUSLY CREATE EVENT
    POST /users/$(userid)/events.json

    {
        "auth_token": "2b770a48ef008c185ea20cd6237fcfab",
        "event": {
            "start_time": "2014-02-09T00:53:43.793Z",
            "end_time": "2014-02-09T02:53:55.500Z",
            "name": "my event",
            "description": "Event description.\nThis can even have newlines in it"
        }
    }
 */
-(void) synchCreateUserEvent:(EventJSON*)eventJSON withUserID:(NSNumber*)user_id withAuth:(NSString*)auth_token {
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:SERVER_STRING];
    [queryString appendString:[NSString stringWithFormat:@"/users/%@/events.json",user_id]];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     queryString]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yyyy-MM-ddEEEEEhh:mm:SSSSS"];   //2014-03-10T18:29:00.000Z     is this correct?
    
    NSDictionary *eventDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [dateFormatter stringFromDate:eventJSON.start_time], @"start_time",
                                    [dateFormatter stringFromDate:eventJSON.end_time], @"end_time",
                                    eventJSON.name, @"name",
                                    eventJSON.event_description, @"description",
                                    nil];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    auth_token, @"auth_token",
                                    eventDictionary, @"event", // Nest the event inside this dictionary
                                    nil];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // should check for and handle errors here but we aren't
    [theRequest setHTTPBody:jsonData];
    // We do not want to block the UI, so we send an ASYNCHRONOUS request
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:theRequest
                                                     returningResponse:&response
                                                                 error:&error];
        
        if (error) {
            [self.delegate createEventFailedWithError:error];
        } else {
            [self.delegate successfullyCreatedEvent:receivedData];
        }
    });
}



/*  SYNCHRONOUSLY GET USER'S EVENTS
    GET /users/$(userid)/events.json?auth_token=$(auth_token)
    [
        {
            "id":6,
            "start_time":"2014-02-09T00:53:43.793Z",
            "end_time":"2014-02-09T02:53:55.500Z",
            "name":"my event",
            "description":null
        }, {...}, {...} 
    ]
 */
- (void)synchFetchUserEvents:(NSNumber*)user_id withAuth:(NSString*)auth_token {
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:SERVER_STRING];
    [queryString appendString:[NSString stringWithFormat:@"/users/%@/events.json?auth_token=%@",user_id,auth_token]];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     queryString]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    [theRequest setHTTPMethod:@"GET"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // We do not want to block the UI, so we send an ASYNCHRONOUS request
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:theRequest
                                                     returningResponse:&response
                                                                 error:&error];
        
        // We send the data to the delegate for further processing:
        if (error) {
            [self.delegate fetchingUserEventsFailedWithError:error];
        } else {
            [self.delegate successfullyFetchedUserEvents:receivedData];
        }
    });
}
 


@end



















