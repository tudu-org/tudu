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

- (IBAction)durationValueChanged:(id)sender;
- (NSInteger) getSecondsValueFromDurationSegmentedControlBar: (NSInteger) selectedIndex;

@property (strong, nonatomic) Task *task;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (strong, nonatomic) IBOutlet UITextField *taskNameField;
@property (strong, nonatomic) IBOutlet UIDatePicker *deadlineDatePicker;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControlBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *durationSegmentedControlBar;
@property (strong, nonatomic) IBOutlet UISlider *durationSlider;
@property (strong, nonatomic) IBOutlet UILabel *durationValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationMaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationMinLabel;
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;

@end
