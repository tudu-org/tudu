//
//  EventDetailViewController.h
//  tuduBeta
//
//  Created by Ryan Cleary on 5/1/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventJSON.h"

@interface EventDetailViewController : UIViewController
@property (nonatomic, strong) EventJSON *event;
@end
