//
//  Task.h
//  tuduBeta
//
//  Created by Ryan Cleary on 2/1/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * task_id;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * task_description;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) NSNumber * duration; // in seconds

@end
