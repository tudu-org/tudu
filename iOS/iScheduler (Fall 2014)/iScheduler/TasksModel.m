//
//  TasksModel.m
//  iScheduler
//
//  Created by Alex Young on 10/23/13.
//  Copyright (c) 2013 Alex Young. All rights reserved.
//

#import "TasksModel.h"

@implementation TasksModel

- (id) init {
    if(self = [super init]) {
        _tasks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSInteger) numberOfTasks {
    return [self.tasks count];
}

- (Task *)  taskAtIndex: (NSUInteger) index {
    return self.tasks[index];
}

- (void) removeTaskAtIndex: (NSUInteger) index {
    [self.tasks removeObjectAtIndex:index];
}

- (NSUInteger) addTask: (Task *) task {
    NSInteger index = 0;
    [self.tasks insertObject:task atIndex:index];
    return index;
}

+ (instancetype) sharedModel {
    static TasksModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

@end
