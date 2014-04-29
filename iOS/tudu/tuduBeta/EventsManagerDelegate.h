//
//  EventsManagerDelegate.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/12/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventJSON.h"

@protocol EventsManagerDelegate <NSObject>
- (void)didReceiveEventsArray:(NSArray *)eventsArray;
- (void)didCreateEvent:(EventJSON*)eventJSON;
- (void)didDeleteEvent;
- (void)didReceiveScheduledEvents:(NSArray *)eventsArray andScheduledTasks:(NSArray*)tasksArray;

@end
