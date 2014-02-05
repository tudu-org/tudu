//
//  CreateTaskViewController.h
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Task.h"
#import "AppDelegate.h"

@interface CreateTaskViewController : UIViewController
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSInteger) getSecondsValueFromDurationSegmentedControlBar: (NSInteger) selectedIndex;
//- (NSInteger) getSecondsValueFromDurationSlider;

@end
