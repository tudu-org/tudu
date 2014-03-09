//
//  TasksBuilder.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "TasksBuilder.h"

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
        [taskJSON setTask_id:[taskDictionary objectForKey:@"id"]];
        [taskJSON setStart_time:[taskDictionary objectForKey:@"start_time"]];
        [taskJSON setEnd_time:[taskDictionary objectForKey:@"end_time"]];
        [taskJSON setName:[taskDictionary objectForKey:@"name"]];
        [taskJSON setTask_description:[taskDictionary objectForKey:@"description"]];
        [taskJSON setPriority:[taskDictionary objectForKey:@"priority"]];
        //[taskJSON setDeadline:[taskDictionary objectForKey:@"deadline"]]; /* TODO: Currently this isn't in the JSON response. */
        
        [tasksArray addObject:taskJSON];
    }

    return tasksArray;
}

@end
