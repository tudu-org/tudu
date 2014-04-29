//
//  ScheduleBuilder.h
//  tuduBeta
//
//  Created by Ryan Cleary on 4/29/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleBuilder : NSObject

+ (NSArray *) scheduledEventsFromScheduleJSON:(NSData *)objectNotation error:(NSError  **)error;
+ (NSArray *) scheduledTasksFromScheduleJSON:(NSData *)objectNotation error:(NSError  **)error;

@end
