//
//  User.h
//  tuduBeta
//
//  Created by Ryan Cleary on 2/26/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * auth_token;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password_hash;
@property (nonatomic, retain) NSDate * wakeup_time;
@property (nonatomic, retain) NSDate * sleep_time;

@end
