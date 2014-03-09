//
//  UserJSON.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The purpose of this class is to store the data fields which are retrieved only in a JSON response.
 It is NOT a replacement or duplicate of the User.h class. 
 */

@interface UserJSON : NSObject
@property (nonatomic, retain) NSString * auth_token;
@property (nonatomic, retain) NSNumber * user_id;
@end
