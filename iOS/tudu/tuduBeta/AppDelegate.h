//
//  AppDelegate.h
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/22/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarKit/CalendarKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CKCalendarViewController *viewController;


@end
