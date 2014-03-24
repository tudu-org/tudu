//
//  TasksBuilder.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskJSON.h"

@interface TasksBuilder : NSObject

+ (NSArray *) tasksFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (Task*) taskFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (Task*) taskFromDictionary:(NSDictionary*)taskDictionary;

@end
