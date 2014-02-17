//
//  CreateEventViewController.h
//  tuduBeta
//
//  Created by Jonathan Rusnak on 2/1/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "Constants.h"

@interface CreateEventViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *eventNameField;
@property (strong, nonatomic) IBOutlet UITextField *eventLocationField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *eventSegmentedControlBar;
@property (strong, nonatomic) IBOutlet UIDatePicker *eventDatePicker;

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;

- (IBAction)eventSegmentedControlBarValueChanged:(id)sender;

@end
