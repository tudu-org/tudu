//
//  UserBuilder.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserJSON.h"

@interface UserBuilder : NSObject

+ (UserJSON *) userFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
