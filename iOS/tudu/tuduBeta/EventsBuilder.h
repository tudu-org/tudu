//
//  EventsBuilder.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/13/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventJSON.h"

@interface EventsBuilder : NSObject

+ (EventJSON*) eventFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (EventJSON*) eventFromDictionary:(NSDictionary*)eventDictionary;

@end
