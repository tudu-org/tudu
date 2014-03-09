//
//  UserBuilder.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "UserBuilder.h"

@implementation UserBuilder

+ (UserJSON *) userFromJSON:(NSData *)objectNotation error:(NSError **)error {
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    // Gather the relevant User data values:
    NSNumber *user_id = [parsedObject valueForKey:@"id"];
    NSString *user_auth_token = [parsedObject objectForKey:@"auth_token"];
    
    // Create the UserJSON object and set its values
    UserJSON *user = [[UserJSON alloc] init];
    [user setUser_id:user_id];
    [user setAuth_token:user_auth_token];
    
    return user;
}

@end