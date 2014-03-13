//
//  EventJSON.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/13/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventJSON : NSObject
@property (nonatomic, retain) NSNumber * event_id;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * event_description;
@end
