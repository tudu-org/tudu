//
//  ScheduleViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "ScheduleViewController.h"
//#import "CKDemoViewController.h"

#import "NSCalendarCategories.h"

#import "NSDate+Components.h"


@interface CKDemoViewController () <CKCalendarViewDelegate, CKCalendarViewDataSource>
@property (nonatomic, strong) NSMutableDictionary *data;
@end

@implementation CKDemoViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setDataSource:self];
        [self setDelegate:self];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSURL *myURL = [[NSURL alloc] initWithString:@"http://bootstrap-calendar.azurewebsites.net"];
    NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:myURL];
    //[self.calendarView loadRequest: myRequest];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    return [self data][date];
}

#pragma mark - CKCalendarViewDelegate

// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date
{
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{
    
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    
}
@end
