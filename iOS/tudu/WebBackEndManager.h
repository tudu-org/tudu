//
//  WebBackEndManager.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/8/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebBackEndManager : NSObject <NSURLConnectionDelegate>
@property (strong,nonatomic) NSMutableData* _receivedData;
-(void) userLogin:(NSString *)userEmail withPass:(NSString*)password;

@end
