//
//  Task.m
//  iScheduler
//
//  Created by Alex Young on 10/23/13.
//  Copyright (c) 2013 Alex Young. All rights reserved.
//

#import "Task.h"

@implementation Task

- (id) initWithName: (NSString *)name AndPriority: (NSInteger)priority AndDueDate: (NSDate *)dueDate AndDuration: (NSTimeInterval)duration {
    if (self = [super init]) {
        self.name = name;
        self.priority = priority; // need to check if 0, 1, 2
        self.dueDate = dueDate;
        self.duration = duration;
    }
    return self;
}

- (id) initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
        self.priority = 0;
        self.dueDate = [NSDate date];
        self.duration = NSTimeIntervalSince1970;
    }
    return self;
}

- (id) initWithName: (NSString *)name AndDueDate: (NSDate *)dueDate {
    if (self = [super init]) {
        self.name = name;
        self.priority = 0;
        self.dueDate = dueDate;
        self.duration = NSTimeIntervalSince1970;
    }
    return self;
}

- (id) initWithName: (NSString *)name AndPriority: (NSInteger)priority AndDueDate: (NSDate *)dueDate {
    if (self = [super init]) {
        self.name = name;
        self.priority = priority;
        self.dueDate = dueDate;
        self.duration = NSTimeIntervalSince1970;
    }
    return self;
}

- (void) setLowPriority {
    self.priority = 0;
}

- (void) setMediumPriority {
    self.priority = 1;
}

- (void) setHighPriority {
    self.priority = 2;
}

@end
