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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (strong, nonatomic) IBOutlet UITextField *taskNameField;
@property (strong, nonatomic) IBOutlet UIDatePicker *deadlineDatePicker;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControlBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *durationSegmentedControlBar;
@property (strong, nonatomic) IBOutlet UISlider *durationSlider;

@end
