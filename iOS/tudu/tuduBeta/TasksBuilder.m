//
//  TasksBuilder.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "TasksBuilder.h"

#define id_key @"id"
#define start_time_key @"start_time"
#define end_time_key @"end_time"
#define name_key @"name"
#define description_key @"description"
#define priority_key @"priority"
#define deadline_key @"deadline"

@implementation TasksBuilder

+ (NSArray *) tasksFromJSON:(NSData *)objectNotation error:(NSError **)error {
    NSError *localError = nil;
    NSMutableArray *tasksArray = [[NSMutableArray alloc] init];
    NSArray *parsedObjectArray = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    
    
    for (int i = 0; i < [parsedObjectArray count]; i++) {
        NSDictionary *taskDictionary = [parsedObjectArray objectAtIndex:i];
        TaskJSON *taskJSON = [[TaskJSON alloc] init];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-ddEEEEEhh:mm:SSSSS"];   //2014-03-10T18:29:00.000Z     is this correct?
      
        
        if ([taskDictionary objectForKey:start_time_key] != NULL && [taskDictionary objectForKey:start_time_key] != [NSNull null]) {
            [taskJSON setStart_time:[df dateFromString:[taskDictionary objectForKey:start_time_key]]];
        }
        
        if ([taskDictionary objectForKey:end_time_key] != NULL && [taskDictionary objectForKey:end_time_key] != [NSNull null]) {
            [taskJSON setEnd_time:[df dateFromString:[taskDictionary objectForKey:end_time_key]]];
        }
        
        if ([taskDictionary objectForKey:id_key] != NULL && [taskDictionary objectForKey:id_key] != [NSNull null]) {
            [taskJSON setTask_id:[taskDictionary objectForKey:id_key]];
        }
        
        if ([taskDictionary objectForKey:name_key] != NULL && [taskDictionary objectForKey:name_key] != [NSNull null]) {
            [taskJSON setName:[taskDictionary objectForKey:name_key]];
        }
        
        if ([taskDictionary objectForKey:description_key] != NULL && [taskDictionary objectForKey:description_key] != [NSNull null]) {
            [taskJSON setTask_description:[taskDictionary objectForKey:description_key]];
        }
            
        if ([taskDictionary objectForKey:priority_key] != NULL && [taskDictionary objectForKey:priority_key] != [NSNull null]) {
            [taskJSON setPriority:[taskDictionary objectForKey:priority_key]];
        }
        
        if ([taskDictionary objectForKey:deadline_key] != NULL && [taskDictionary objectForKey:deadline_key] != [NSNull null]) {
            [taskJSON setDeadline:[df dateFromString:[taskDictionary objectForKey:deadline_key]]];
        }
    
        
        [tasksArray addObject:taskJSON];
    }

    return tasksArray;
}

@end
