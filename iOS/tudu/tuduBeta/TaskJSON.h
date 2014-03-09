//
//  TaskJSON.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Task.h"

@interface TaskJSON : NSObject

@property (nonatomic, retain) NSNumber * task_id;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * task_description;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) NSNumber * duration; // in seconds

-(Task*)convertToTaskObject;

@end
