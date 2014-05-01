//
//  ScheduleViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "ScheduleViewController.h"
#import "CalendarKit/CalendarKit.h"
#import "EventDetailViewController.h"
#import "NSDate+Description.h"
#import "NSDate+Components.h"
#import "EventsBuilder.h"

@interface ScheduleViewController ()
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *dayView;
@property (weak, nonatomic) IBOutlet UIButton *weekView;
@property (weak, nonatomic) IBOutlet UIButton *monthView;
@property(strong, nonatomic) EKCalendar *defaultCalendar;
@property (nonatomic, strong) NSMutableDictionary *data;
@property (strong, nonatomic) NSMutableDictionary *eventsDict;
@property (strong, nonatomic) NSArray *sortedArrayByDate;
@property (strong, nonatomic) EventJSON *eventJSON;
@property (strong, nonatomic) NSMutableArray *calendarEvents;
@property (strong, nonatomic) NSDate *selectedDate;
@property int runOnce;
@property int runOnceTasks;
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
    manager.tmDelegate = self;

    // Pull the events from the JSON back-end
    [self helpMePullEvents];
    [self sortEventsArrayByDate];

    
    [self.dayView addTarget:self action:@selector(viewTypeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.weekView addTarget:self action:@selector(viewTypeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.monthView addTarget:self action:@selector(viewTypeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    //Fetch Event Data for Calendar
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    self.defaultCalendar = [eventStore defaultCalendarForNewEvents];
    
    //Instatiate the calendar event
    self.calendarEvents = [[NSMutableArray alloc] init];
    
    
    // 1. Instantiate a CKCalendarView
    self.calendar = [CKCalendarView new];
    
    // 2. Optionally, set up the datasource and delegates
    [self.calendar setDelegate:self];
    [self.calendar setDataSource:self];
    
    // 3. Set as Day View
    self.calendar.displayMode = 1;//2 = Day View 0 = Month View 1 = Week View

    // 4. Present the calendar
    [[self calendarView] addSubview:self.calendar];
    
    [[self calendar] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] animated:NO];
    [[self calendar] setDisplayMode:CKCalendarViewModeWeek animated:NO];
    
    //sample events
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    _eventsDict = [[NSMutableDictionary alloc] init];
    _runOnce = 0;
    _runOnceTasks = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [manager scheduleTasks]; 
    [self helpMePullEvents];
    [self sortEventsArrayByDate];

}

/*sorts the array by Date*/
-(void)sortEventsArrayByDate{
    self.sortedArrayByDate = [[_eventsDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

/* This doesnot need to be a separate function, I am just doing this
    so it can be used more easily by you, Johnny, later. */
-(void)helpMePullEvents {
    [manager getUserEvents];
    [manager getUserTasks];
    [manager scheduleTasks];
    [manager getUserSchedule];
}

#pragma mark TasksManagerDelegate methods
- (void) didReceiveTasksArray:(NSArray *)tasksArray {}
//    /*TODO: Johnny, this is where you should implement code similar to didReceiveEventsArray: */
//    /*TODO: I guess it would be best if you got them all at once... I will work on implementing that call now. */
//    NSLog(@"TASKS HERE!!: %@", tasksArray);
//    //[HUD performSelectorOnMainThread:@selector(hideUIBlockingIndicator) withObject:nil waitUntilDone:NO];
//    if(_runOnceTasks == 0){
//        _runOnceTasks=1;
//        NSLog(@"------RECEIVED TASKS-------");
//        NSMutableArray* tempTasksArray = [[NSMutableArray alloc] init];
//        CKCalendarEvent* aCKCalendarTask = [[CKCalendarEvent alloc] init];
//        
//        for (int i=0;i<[tasksArray count]; i++) {
//            self.taskJSON = [tasksArray objectAtIndex:i];
//            
//            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.taskJSON.start_time];
//            
//            //define the calendar event
//            aCKCalendarTask.date = [NSDate dateWithDay:[components day] month:[components month] year:[components year]];
//            
//            if(aCKCalendarTask.date!=nil){
//                tempTasksArray = [[NSMutableArray alloc]init];
//                [tempTasksArray addObjectsFromArray:[_eventsDict objectForKey:aCKCalendarTask.date]];
//                aCKCalendarTask = [[CKCalendarEvent alloc]init];
//                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.taskJSON.start_time];
//                
//                //define the calendar event
//                aCKCalendarTask.date = [NSDate dateWithDay:[components day] month:[components month] year:[components year]];
//                aCKCalendarTask.title = self.taskJSON.name;
//                [tempTasksArray addObject:aCKCalendarTask];
//                [_eventsDict setObject:tempTasksArray forKey:aCKCalendarTask.date];
//            }
//        }
//        NSLog(@"Calendar Task/Events Array: %@", _eventsDict);
//    }
//
//}
//
//
//#pragma mark - EventsManagerDelegate methods
//
-(void) didReceiveEventsArray:(NSArray *)eventsArray {}
//    
//    if(_runOnce == 0){
//        _runOnce=1;
//        NSLog(@"------RECEIVED EVENTS-------");
//        NSMutableArray* tempEventsArray = [[NSMutableArray alloc] init];
//        CKCalendarEvent* aCKCalendarEvent = [[CKCalendarEvent alloc] init];
//    
//        for (int i=0;i<[eventsArray count]; i++) {
//            self.eventJSON = [eventsArray objectAtIndex:i];
//
//            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.eventJSON.start_time];
//
//            //define the calendar event
//            aCKCalendarEvent.date = [NSDate dateWithDay:[components day] month:[components month] year:[components year]];
//        
//            if(aCKCalendarEvent.date!=nil){
//                    tempEventsArray = [[NSMutableArray alloc]init];
//                    [tempEventsArray addObjectsFromArray:[_eventsDict objectForKey:aCKCalendarEvent.date]];
//                    aCKCalendarEvent = [[CKCalendarEvent alloc]init];
//                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.eventJSON.start_time];
//                
//                    //define the calendar event
//                    aCKCalendarEvent.date = [NSDate dateWithDay:[components day] month:[components month] year:[components year]];
//                    aCKCalendarEvent.title = self.eventJSON.name;
//                    [tempEventsArray addObject:aCKCalendarEvent];
//                    [_eventsDict setObject:tempEventsArray forKey:aCKCalendarEvent.date];
//                }
//            }
//            [self.eventJSON printEvent];
//            NSLog(@"Calendar Events Array: %@", _eventsDict);
//        }
//}


-(void) didReceiveScheduledEvents:(NSArray *)eventsArray andScheduledTasks:(NSArray *)tasksArray{
    
    /*TODO: Great work so far Johnny. I have added the code to do the combined JSON request call.  
            I have reproduced the code you wrote for the events below.  All you have to do now is to add
            the tasks into the mix. And we are still waiting on the back-end guys to make it so we can 
            actually test it though.  The code that Mike wrote cannot be uploaded to the Heroku server
            without breaking the front-end code. */
    
    NSMutableSet *set = [NSMutableSet setWithArray:eventsArray];
    [set addObjectsFromArray:tasksArray];

    NSArray *allTasksAndEvents = [set allObjects];
    
    NSLog(@"All Tasks and Events: %@", allTasksAndEvents);
    
//    NSString *dateString = @"01-May-14";
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"dd-MMM-yy";
//    NSDate *date = [dateFormatter dateFromString:dateString];
//
//    [[tasksArray objectAtIndex:0] setStart_time:date];
    
    
    for (int i = 0; i < [tasksArray count]; i++)
    {
        TaskJSON *task = [tasksArray objectAtIndex:i];
        NSLog(@"S_TASK NAME = %@",task.name);
        NSLog(@"S_TASK START_TIME = %@",task.start_time);
        NSLog(@"S_TASK END_TIME = %@",task.end_time);
    }
    if(_runOnce == 0){
        _runOnce=1;
        NSLog(@"------RECEIVED EVENTS AND TASKS-------");
        NSMutableArray* tempEventsArray = [[NSMutableArray alloc] init];
        CKCalendarEvent* aCKCalendarEvent = [[CKCalendarEvent alloc] init];
        
        for (int i=0;i<[allTasksAndEvents count]; i++) {
            self.eventJSON = [allTasksAndEvents objectAtIndex:i];
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.eventJSON.start_time];
            
            //define the calendar event
            aCKCalendarEvent.date = [NSDate dateWithDay:[components day] month:[components month] year:[components year]];
            
            if(aCKCalendarEvent.date!=nil){
                tempEventsArray = [[NSMutableArray alloc]init];
                [tempEventsArray addObjectsFromArray:[_eventsDict objectForKey:aCKCalendarEvent.date]];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |NSCalendarUnitMonth | NSCalendarUnitYear fromDate:aCKCalendarEvent.date];

                //define the calendar event
                aCKCalendarEvent.date = [NSDate dateWithDay:[components day] month:[components month] year:[components year]];
                aCKCalendarEvent.title = self.eventJSON.name;
                [tempEventsArray addObject:aCKCalendarEvent];
                [_eventsDict setObject:tempEventsArray forKey:aCKCalendarEvent.date];
                aCKCalendarEvent = [[CKCalendarEvent alloc]init];

            }
        }
        //[self.eventJSON printEvent];
        NSLog(@"Calendar Events Array: %@", _eventsDict);
    }
}


#pragma mark - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{

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
    self.selectedDate = date;
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
    // Push the detail view controller here
    [self performSegueWithIdentifier:@"ExamineEventSegue" sender:self];
}

#pragma mark - Calendar View
//
//- (CKCalendarView *)calendarView
//{
//    return self.calendar;
//}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ExamineEventSegue"]) {
        EventDetailViewController *edvc = segue.destinationViewController;
        NSArray *dailyScheduledEvents = [_eventsDict objectForKey:self.selectedDate];
        CKCalendarEvent *ckEvent = [dailyScheduledEvents objectAtIndex:[self.calendar.table indexPathForSelectedRow].row];
        EventJSON *event = [[EventJSON alloc] init];
        [event setName:ckEvent.title];
        [event setStart_time:ckEvent.date]; // START TIME
        
        [edvc setEvent:event];
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
