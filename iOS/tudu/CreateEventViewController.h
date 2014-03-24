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
#import "EventsManagerDelegate.h"
#import "BackEndManager.h"
#import "HUD.h"
#import "EventJSON.h"

@interface CreateEventViewController : UIViewController <EventsManagerDelegate> {
    BackEndManager *manager;
}

@property (strong, nonatomic) IBOutlet UITextField *eventNameField;
@property (strong, nonatomic) IBOutlet UITextField *eventLocationField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *eventSegmentedControlBar;
@property (strong, nonatomic) IBOutlet UIDatePicker *eventDatePicker;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (IBAction)eventSegmentedControlBarValueChanged:(id)sender;
- (IBAction)datePickerValueChanged:(id)sender;

@end
