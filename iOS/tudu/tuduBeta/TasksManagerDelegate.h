//
//  TasksManagerDelegate.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@protocol TasksManagerDelegate <NSObject>
- (void)didReceiveTasksArray:(NSArray *)tasksArray;
- (void)pushTask:(Task*)task;
@end
