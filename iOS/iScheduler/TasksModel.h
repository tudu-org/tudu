//
//  TasksModel.h
//  iScheduler
//
//  Created by Alex Young on 10/23/13.
//  Copyright (c) 2013 Alex Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface TasksModel : NSObject

@property (strong, nonatomic) NSMutableArray *tasks;
//@property (strong, nonatomic) NSString *filepath;
//@property (strong, nonatomic) NSMutableDictionary *plist;

- (NSInteger) numberOfTasks;
- (Task *)  taskAtIndex: (NSUInteger) index;
- (void) removeTaskAtIndex: (NSUInteger) index;
- (NSUInteger) addTask: (Task *) task;
//- (void) save;

+ (instancetype)sharedModel;

@end
