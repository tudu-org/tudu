//
//  TaskJSON.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "TaskJSON.h"


@implementation TaskJSON

@synthesize task_id;
@synthesize start_time;
@synthesize end_time;
@synthesize name;
@synthesize task_description;
@synthesize priority;
@synthesize deadline;
@synthesize duration; // in seconds

-(Task *)convertToTaskObject {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                inManagedObjectContext:managedObjectContext];
    if (task_id != NULL) {
        [task setTask_id:task_id];
    }
    
    if (start_time != NULL) {
        [task setStart_time:start_time];
    } else {
        [task setStart_time:NULL];
    }
    if (end_time != NULL) {
        [task setEnd_time:end_time];
    } else {
        [task setEnd_time:NULL];
    }

    if (name != NULL) {
        [task setName:name];
    }
    if (task_description != NULL  && start_time != nil) {
        [task setTask_description:task_description];
    }
    if (priority != NULL) {
        [task setPriority:priority];
    }
    if (deadline != NULL) {
        [task setDeadline:deadline];
    }
    if (duration != NULL  && start_time != nil) {
        [task setDuration:duration];
    }
    
    return task;
}

@end
