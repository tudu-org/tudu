//
//  ScheduleBuilder.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/13/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "ScheduleBuilder.h"
#import "EventsBuilder.h"
#import "TasksBuilder.h"

@implementation ScheduleBuilder


+ (NSArray *) scheduledEventsFromScheduleJSON:(NSData *)objectNotation error:(NSError  **)error {
    NSError *localError = nil;
    NSMutableArray *eventsToReturn = [[NSMutableArray alloc] init];
    NSDictionary *parsedObjectDictionary = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSArray *arrayOfEvents = [parsedObjectDictionary objectForKey:@"events"];
    
    for (int i = 0; i < [arrayOfEvents count]; i++) {
        NSDictionary *eventDictionary = [arrayOfEvents objectAtIndex:i];
        [eventsToReturn addObject:[EventsBuilder eventFromDictionary:eventDictionary]];
    }
    
    return eventsToReturn;
}

+ (NSArray *) scheduledTasksFromScheduleJSON:(NSData *)objectNotation error:(NSError  **)error {
    NSError *localError = nil;
    NSMutableArray *tasksToReturn = [[NSMutableArray alloc] init];
    NSDictionary *parsedObjectDictionary = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSArray *arrayOfTasks = [parsedObjectDictionary objectForKey:@"tasks"];
    
    for (int i = 0; i < [arrayOfTasks count]; i++) {
        NSDictionary *taskDictionary = [arrayOfTasks objectAtIndex:i];
        [tasksToReturn addObject:[TasksBuilder taskFromDictionary:taskDictionary]];
    }
    
    return tasksToReturn;
}


@end
