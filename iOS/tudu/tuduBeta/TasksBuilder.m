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
#define created_at_key @"created_at"
#define updated_at_key @"updated_at"
#define name_key @"name"
#define description_key @"description"
#define priority_key @"priority"
#define deadline_key @"deadline"
#define duration_key @"duration"


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
        [tasksArray addObject:[self taskFromDictionary:taskDictionary]];
    }

    return tasksArray;
}

+ (Task*) taskFromJSON:(NSData *)objectNotation error:(NSError **)error {
    NSError *localError = nil;
    NSDictionary *parsedObjectDictionary = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    return [self taskFromDictionary:parsedObjectDictionary];
}

+ (Task*) taskFromDictionary:(NSDictionary*)taskDictionary {
    TaskJSON *taskJSON = [[TaskJSON alloc] init];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"]; // This is correct !
    
    
    if ([taskDictionary objectForKey:start_time_key] != NULL && [taskDictionary objectForKey:start_time_key] != [NSNull null]) {
        NSString *startTimeStr = [taskDictionary objectForKey:start_time_key];
        NSDate *startTime = [df dateFromString:startTimeStr];
        [taskJSON setStart_time:startTime];
    }
    
    if ([taskDictionary objectForKey:end_time_key] != NULL && [taskDictionary objectForKey:end_time_key] != [NSNull null]) {
        NSString *endTimeStr = [taskDictionary objectForKey:end_time_key];
        NSDate *endTime = [df dateFromString:endTimeStr];
        [taskJSON setEnd_time:endTime];
    }
    
    if ([taskDictionary objectForKey:created_at_key] != NULL && [taskDictionary objectForKey:created_at_key] != [NSNull null]) {
        NSString *createdAtStr = [taskDictionary objectForKey:created_at_key];
        NSDate *createTime = [df dateFromString:createdAtStr];
        [taskJSON setCreated_at:createTime];
    }
    
    if ([taskDictionary objectForKey:updated_at_key] != NULL && [taskDictionary objectForKey:updated_at_key] != [NSNull null]) {
        NSString *updatedAtStr = [taskDictionary objectForKey:updated_at_key];
        NSDate *updateTime = [df dateFromString:updatedAtStr];
        [taskJSON setUpdated_at:updateTime];
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
    
    if ([taskDictionary objectForKey:duration_key] != NULL && [taskDictionary objectForKey:duration_key] != [NSNull null]) {
        [taskJSON setDuration:[taskDictionary objectForKey:duration_key]];
    }
    
    return [taskJSON convertToTaskObject];
}

@end







