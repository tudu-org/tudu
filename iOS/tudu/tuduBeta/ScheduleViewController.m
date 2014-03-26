//
//  ScheduleViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "ScheduleViewController.h"
#import "CalendarKit/CalendarKit.h"
#import "NSDate+Description.h"
#import "NSDate+Components.h"

@interface ScheduleViewController ()
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *dayView;
@property (weak, nonatomic) IBOutlet UIButton *weekView;
@property (weak, nonatomic) IBOutlet UIButton *monthView;
@property(strong, nonatomic) EKCalendar *defaultCalendar;
@property (nonatomic, strong) NSMutableDictionary *data;
@property (strong, nonatomic) NSMutableDictionary *eventsDict;
@property (strong, nonatomic) EventJSON *eventJSON;

@end

@implementation ScheduleViewController
@synthesize eventsDict = _eventsDict;


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
    
    // Set up the BackEndManager
    manager = [[BackEndManager alloc] init];
    manager.communicator = [[BackEndCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.emDelegate = self;

    // Pull the events from the JSON back-end
    [self helpMePullEvents];

    
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
    //[self addEventsToCalendar:self.defaultCalendar];
    
    [[self calendar] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] animated:NO];
    [[self calendar] setDisplayMode:CKCalendarViewModeMonth animated:NO];
    
    //sample events
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    // NSMutableDictionary* eventsDict = [[NSMutableDictionary alloc] init];
    _eventsDict = [[NSMutableDictionary alloc] init];
//    NSMutableArray* eventsArray = [[NSMutableArray alloc] init];
    
//    CKCalendarEvent* aCKCalendarEvent = [[CKCalendarEvent alloc] init];
//    aCKCalendarEvent.date = [dateformatter dateFromString: @"05/04/2014 07:15"];
//    aCKCalendarEvent.title = @"iOS Meeting";
//    [eventsArray addObject: aCKCalendarEvent];
//    [_eventsDict setObject: eventsArray forKey: [NSDate dateWithDay:04 month:05 year:2014]];
//    
//    eventsArray = [[NSMutableArray alloc] init];
//    aCKCalendarEvent = [[CKCalendarEvent alloc] init];
//    aCKCalendarEvent.date = [dateformatter dateFromString: @"05/05/2014 12:00"];
//    aCKCalendarEvent.title = @"iOS Meeting";
//    [eventsArray addObject: aCKCalendarEvent];
//    [_eventsDict setObject: eventsArray forKey: [NSDate dateWithDay:05 month:05 year:2014]];
//    
//    aCKCalendarEvent = [[CKCalendarEvent alloc] init];
//    aCKCalendarEvent.date = [dateformatter dateFromString: @"05/05/2014 13:00"];
//    aCKCalendarEvent.title = @"Part 2";
//    [eventsArray addObject: aCKCalendarEvent];
//    [_eventsDict setObject: eventsArray forKey: [NSDate dateWithDay:05 month:05 year:2014]];
//    
//    eventsArray = [[NSMutableArray alloc] init];
//    aCKCalendarEvent = [[CKCalendarEvent alloc] init];
//    aCKCalendarEvent.date = [NSDate dateWithDay:06 month:05 year: 2014];
//    aCKCalendarEvent.title = @"iOS Meeting";
//    [eventsArray addObject: aCKCalendarEvent];
//    [_eventsDict setObject:eventsArray forKey:aCKCalendarEvent.date];

}

-(void)viewDidAppear:(BOOL)animated{
    [self helpMePullEvents];   
}

/* This doesnot need to be a separate function, I am just doing this 
    so it can be used more easily by you, Johnny, later. */
-(void)helpMePullEvents {
    [HUD showUIBlockingIndicatorWithText:@"Downloading Events"];
    [manager getUserEvents];
}


#pragma mark - EventsManagerDelegate methods

-(void) didReceiveEventsArray:(NSArray *)eventsArray {
    NSLog(@"------RECEIVED EVENTS-------");
    for (int i=0;i<[eventsArray count]; i++) {
        self.eventJSON = [eventsArray objectAtIndex:i];
        //clear temporary eventsArray2/CalendarEvent/dateformatter
        NSMutableArray* eventsArray2 = [[NSMutableArray alloc] init];
        CKCalendarEvent* aCKCalendarEvent = [[CKCalendarEvent alloc] init];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.eventJSON.start_time];

        
        //define the calendar event and place into the temp array
        //aCKCalendarEvent.date = self.eventJSON.start_time;
        aCKCalendarEvent.date = [NSDate dateWithDay:[components day] month:[components month] year:[components year]];
        aCKCalendarEvent.title = self.eventJSON.name;
        [eventsArray2 addObject: aCKCalendarEvent];
        
        //add temp array to the self.eventsDict
        [_eventsDict setObject:eventsArray2 forKey:aCKCalendarEvent.date];
        [self.eventJSON printEvent];
    }
//    [self convertJSONtoCKEvent];
    [HUD hideUIBlockingIndicator];
}


#pragma mark - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    //return [self data][date];
    return _eventsDict[date];

}

#pragma mark - Toolbar Items

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

#pragma mark - CKCalendarViewDelegate

// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)calendarView willSelectDate:(NSDate *)date
{
    if ([self isEqual:[self delegate]]) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)]) {
        [[self delegate] calendarView:calendarView willSelectDate:date];
    }
}

- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    if ([self isEqual:[self delegate]]) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [[self delegate] calendarView:calendarView didSelectDate:date];
    }
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)calendarView didSelectEvent:(CKCalendarEvent *)event
{
    if ([self isEqual:[self delegate]]) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectEvent:)]) {
        [[self delegate] calendarView:calendarView didSelectEvent:event];
    }
}

#pragma mark - Calendar View
//
//- (CKCalendarView *)calendarView
//{
//    return self.calendar;
//}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
