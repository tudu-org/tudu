//
//  CreateEventViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 2/1/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addEventBtn;
@end

@implementation CreateEventViewController {
    bool SERVER_MODE;
}
@synthesize startTime, endTime, dateFormatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark EventsManagerDelegate methods
- (void)didCreateEvent:(EventJSON*)eventJSON {
    [HUD hideUIBlockingIndicator];
    NSLog(@"EVENT CREATED.");
    NSLog(@"event_name=%@",eventJSON.name);
    NSLog(@"event_id=%@",eventJSON.event_id);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    SERVER_MODE = true;
    
    // Set up the BackEndManager
    manager = [[BackEndManager alloc] init];
    manager.communicator = [[BackEndCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.emDelegate = self;
    
    // Set up the EventDatePicker
    NSDate * now = [[NSDate alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents * comps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate * date = [cal dateFromComponents:comps];
    [self.eventDatePicker setDate:date animated:TRUE];
    
    startTime = self.eventDatePicker.date;
    
    // Start time text label
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MMM d, h:mm a"]; // Feb 17, 7:59 PM
    self.startTimeLabel.text = [dateFormatter stringFromDate:startTime];

    // End time text label
    NSTimeInterval numSecondsInOneHour = 60 * 60;
    NSDate *oneHourAhead = [self.startTime dateByAddingTimeInterval:numSecondsInOneHour];
    endTime = oneHourAhead;
    self.endTimeLabel.text = [dateFormatter stringFromDate:endTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addEventBtnPressed:(id)sender {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        // handle access here
    }];

    EKCalendar *defaultCalendar = [eventStore defaultCalendarForNewEvents];
    
    // Create a new event... save and commit
    NSError *error = nil;
    EKEvent *myEvent = [EKEvent eventWithEventStore:eventStore];
    myEvent.allDay = NO;
    myEvent.startDate = startTime;
    myEvent.endDate = endTime;
    myEvent.title = self.eventNameField.text;
    myEvent.location = self.eventLocationField.text;
    myEvent.calendar = defaultCalendar; // Does this work ?
    [eventStore saveEvent:myEvent span:EKSpanThisEvent commit:YES error:&error];
    
    if (SERVER_MODE) {
        EventJSON *eventJSON = [[EventJSON alloc] init];
        eventJSON.start_time = startTime;
        eventJSON.end_time = endTime;
        eventJSON.name = self.eventNameField.text;
        eventJSON.event_description = self.eventLocationField.text;
        
        [HUD showUIBlockingIndicatorWithText:@"Creating Event"];
        [manager createUserEvent:eventJSON];
    }
    
    if (!error) {
        NSLog(@"the event saved and committed correctly with identifier %@", myEvent.eventIdentifier);
    } else {
        NSLog(@"there was an error saving and committing the event");
        error = nil;
    }
    
    EKEvent *savedEvent = [eventStore eventWithIdentifier:myEvent.eventIdentifier];
    NSLog(@"saved event description: %@",savedEvent);
    
    // Transition to the Schedule/Calendar view
    [self performSegueWithIdentifier:@"AddEventSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddEventSegue"]) {
        UITabBarController *tabBarController = segue.destinationViewController;
        tabBarController.selectedIndex = SCHEDULE_TAB_INDEX;
    }
}

// Called when the eventSegmentedControlBar's value changes
// i.e. the user switches from setting the beginning to setting the ending
- (IBAction)eventSegmentedControlBarValueChanged:(id)sender {
    int index = [self.eventSegmentedControlBar selectedSegmentIndex];
    switch (index) {
        case 0: { // 'BEGIN' SEGMENT
            // store the "END" time
            endTime = self.eventDatePicker.date;
            self.endTimeLabel.text = [dateFormatter stringFromDate:self.eventDatePicker.date];
            [self.eventDatePicker setDate:startTime animated:TRUE];
            break;
        }
        case 1: {// 'END' SEGMENT
            // store the "START" time
            if (startTime == NULL) {
                // First time this segment button is pressed
                startTime = self.eventDatePicker.date;
                NSTimeInterval numSecondsInOneHour = 60 * 60;
                NSDate *oneHourAhead = [self.eventDatePicker.date dateByAddingTimeInterval:numSecondsInOneHour];
                [self.eventDatePicker setDate:oneHourAhead animated:TRUE];
            } else {
                startTime = self.eventDatePicker.date;
                self.startTimeLabel.text = [dateFormatter stringFromDate:self.eventDatePicker.date];
                [self.eventDatePicker setDate:endTime animated:TRUE];
            }            
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)datePickerValueChanged:(id)sender {
    int seg = self.eventSegmentedControlBar.selectedSegmentIndex;
    switch (seg) {
        case 0:
            self.startTimeLabel.text = [dateFormatter stringFromDate:self.eventDatePicker.date];
            break;
        case 1:
            self.endTimeLabel.text = [dateFormatter stringFromDate:self.eventDatePicker.date];
            break;
            
        default:
            break;
    }
}


/* Hide the keyboard when the user taps something other than the Task name field. */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.eventNameField isFirstResponder] && [touch view] != self.eventNameField) {
        [self.eventNameField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
    if ([self.eventLocationField isFirstResponder] && [touch view] != self.eventLocationField) {
        [self.eventLocationField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


@end









