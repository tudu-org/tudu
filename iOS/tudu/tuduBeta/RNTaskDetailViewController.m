//
//  RNTaskDetailViewController.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/5/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "RNTaskDetailViewController.h"

@interface RNTaskDetailViewController ()

@end

@implementation RNTaskDetailViewController
int currentTaskIndex = 0;

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

}

#pragma mark TasksManagerDelegate methods
- (void) didReceiveTasksArray:(NSArray *)tasksArray {
    // We reverse the array order because we do want tasks to be added at the TOP of the list and not the bottom
    //self.fetchedTasksArray = [[tasksArray reverseObjectEnumerator] allObjects];

    // Sort the tasks, showing the tasks with ASCENDING Duration values
    NSSortDescriptor *sortByDuration = [NSSortDescriptor sortDescriptorWithKey:@"duration"
                                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDuration];
    self.fetchedTasksArray = [NSMutableArray arrayWithArray:[self.fetchedTasksArray sortedArrayUsingDescriptors:sortDescriptors]];
    
    if ([self.fetchedTasksArray count] == 0) {
        [self.titleLabel setText:@"You don't have any tasks!"];
        [self.durationLabel setText:@""];
        [self.deadlineLabel setText:@""];
    } else {
        [self populateView:[self.fetchedTasksArray objectAtIndex:0]];
    }

    [HUD performSelectorOnMainThread:@selector(hideUIBlockingIndicator) withObject:nil waitUntilDone:NO];
}

-(void) viewDidAppear:(BOOL)animated {
   
    
    // Set up the BackEndManager
    manager = [[BackEndManager alloc] init];
    manager.communicator = [[BackEndCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.tmDelegate = self;
    
    /* AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
     self.managedObjectContext = appDelegate.managedObjectContext;*/
    
    // Pull the latest tasks
    
    [HUD showUIBlockingIndicatorWithText:@"Downloading Tasks"];
    [manager getUserTasks];
    
    // Fetching Records and saving it in "fetchedRecordsArray" object
    //self.fetchedRecordsArray = [appDelegate getAllTaskRecords];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) populateView:(Task *)task {
    
    // Task Title
    [self.titleLabel setText:task.name];
    
    
    // Task Duration
    NSString *durationDisplayString;
    NSString *suffixStr;
    int val = [task.duration intValue];
    int hr = val / 3600; // 3600 seconds in an hour
    int min = (val - (hr*3600)) / 60; // 60 seconds in a minute
    if (hr == 0) {
        durationDisplayString = [NSString stringWithFormat:@"%i minutes", min];
    } else {
        if (hr > 1) {
            suffixStr = @"s";
        } else {
            suffixStr = @"";
        }
        if (min == 0) {
            durationDisplayString = [NSString stringWithFormat:@"%i hour%@", hr, suffixStr];
        } else {
            durationDisplayString = [NSString stringWithFormat:@"%i hour%@ and %i min", hr, suffixStr, min];
        }
    }
    [self.durationLabel setText:durationDisplayString];
    
    
    // Task Deadline
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MMM d, h:mm a"]; // Feb 17, 7:59 PM
    NSString *deadlineString = [dateFormatter stringFromDate:task.deadline];
    [self.deadlineLabel setText:deadlineString];
    
    
    // Task Background Coloring
    int prio = [task.priority intValue];
    switch (prio) {
            /* TODO: Make these Constants and store them in Constants.h */
        case 0:
            [self.view setBackgroundColor:[UIColor greenColor]];
            break;
        case 1:
            [self.view setBackgroundColor:[UIColor orangeColor]];
            break;
        case 2:
            [self.view setBackgroundColor:[UIColor redColor]];
            break;
            
        default:
            [self.view setBackgroundColor:[UIColor grayColor]];
            break;
    }
}

-(void) showNextTask {
    if (currentTaskIndex+1 < [self.fetchedTasksArray count]) { // Array bounds checking
        [self populateView:[self.fetchedTasksArray objectAtIndex:++currentTaskIndex]];
    }
}

-(void) showPreviousTask {
    if (currentTaskIndex-1 >= 0) { // Array bounds checking
        [self populateView:[self.fetchedTasksArray objectAtIndex:--currentTaskIndex]];
    }
}


@end





