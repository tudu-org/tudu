//
//  EventJSON.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/13/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "EventJSON.h"

@implementation EventJSON
@synthesize event_id, start_time, end_time, name, event_description;

-(void)printEvent {
    NSLog(@"==========Event==========");
    NSLog(@"id=%@",event_id);
    NSLog(@"start_time=%@",start_time);
    NSLog(@"end_time=%@",end_time);
    NSLog(@"name=%@",name);
    NSLog(@"description=%@",event_description);
}

@end
