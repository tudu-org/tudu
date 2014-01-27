//
//  Task.h
//  iScheduler
//
//  Created by Alex Young on 10/23/13.
//  Copyright (c) 2013 Alex Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property NSInteger priority; // 0 = Low, 1 = Medium, 2 = High
@property NSDate *dueDate;
@property NSTimeInterval duration; // How long the task will take to complete
@property NSString *name;

/** Importance - A
* Due date - A
* Length - A (tie breaker)
* Name
- time frame
- type of reminder
- recurrence
- location
- category / tags*/

- (id) initWithName: (NSString *)name AndPriority: (NSInteger)priority AndDueDate: (NSDate *)dueDate AndDuration: (NSTimeInterval)duration;
- (id) initWithName: (NSString *)name AndPriority: (NSInteger)priority AndDueDate: (NSDate *)dueDate;
- (id) initWithName: (NSString *)name AndDueDate: (NSDate *)dueDate;
- (id) initWithName: (NSString *)name;

- (void) setLowPriority;
- (void) setMediumPriority;
- (void) setHighPriority;

@end
