//
//  ScheduleViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "ScheduleViewController.h"
#import "CalendarKit/CalendarKit.h"

@interface ScheduleViewController ()
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *dayView;
@property (weak, nonatomic) IBOutlet UIButton *weekView;
@property (weak, nonatomic) IBOutlet UIButton *monthView;
@property(strong, nonatomic) EKCalendar *defaultCalendar;

@end

@implementation ScheduleViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Set up buttons
    
    [self.dayView addTarget:self action:@selector(viewTypeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.weekView addTarget:self action:@selector(viewTypeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.monthView addTarget:self action:@selector(viewTypeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    //Fetch Event Data for Calendar
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    self.defaultCalendar = [eventStore defaultCalendarForNewEvents];
    
    
    
    // 1. Instantiate a CKCalendarView
    self.calendar = [CKCalendarView new];
    
    // 2. Optionally, set up the datasource and delegates
    [self.calendar setDelegate:self];
    [self.calendar setDataSource:self];
    
    // 3. Set as Day View
    self.calendar.displayMode = 2;//2 = Day View 0 = Month View 1 = Week View

    // 4. Present the calendar
    [[self calendarView] addSubview:self.calendar];
    
    //Add events to calendar
    [self addEventsToCalendar:self.defaultCalendar];

}

-(void)addEventsToCalendar:(EKCalendar*)cal{
    //SAMPLE CALENDAR VIEW
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:22];
    [comps setMonth:2];
    [comps setYear:2014];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];

    [[self dataSource] calendarView:self.calendar eventsForDate:date];
    

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewTypeButtonPushed:(id)sender
{
    if([[sender currentTitle] isEqual:@"Month"]){
        self.calendar.displayMode = 0;
    }
    
    if([[sender currentTitle] isEqual:@"Week"]){
        self.calendar.displayMode = 1;
    }
    
    if([[sender currentTitle] isEqual:@"Day"]){
        self.calendar.displayMode = 2;
    }
    
}

@end
