//
//  TasksViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "TasksViewController.h"

@interface TasksViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TasksViewController {
    bool SERVER_MODE;
}
@synthesize fetchedTasksArray, user;
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
    
    
    // Set the iPhone to be in server mode (no local storage of events & tasks)
    SERVER_MODE = true;
    
    
    // Set up the Persistence storage, for the user info
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    // Set up the BackEndManager
    manager = [[BackEndManager alloc] init];
    manager.communicator = [[BackEndCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.tmDelegate = self;
    
    
    // Show the Login View Controller if necessary
//    bool login = false; // Need to change this (use core data to establish need)
//    if (!login) {
//        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
//    }
    
   
    
    if (SERVER_MODE) {
        [HUD showUIBlockingIndicatorWithText:@"Downloading Tasks"];
        [manager getUserTasks];
    } else { // LOCAL PERSISTENCE STORAGE MODE
        // Fetching Records and saving it in "fetchedRecordsArray" object
        self.fetchedTasksArray = [[[appDelegate getAllTaskRecords] reverseObjectEnumerator] allObjects];
    }
    [self.tableView reloadData];


    
//    // Test this code for events:
//    
//    EKEventStore *eventStore = [[EKEventStore alloc] init];
//    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//        // handle access here
//    }];
//
//    // Get the appropriate calendar
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    // Create the start date components
//    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
//    oneDayAgoComponents.day = -1;
//    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
//                                                  toDate:[NSDate date]
//                                                 options:0];
//    
//    // Create the end date components
//    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
//    oneYearFromNowComponents.year = 1;
//    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
//                                                       toDate:[NSDate date]
//                                                      options:0];
//    
//    // Create the predicate from the event store's instance method
//    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:oneDayAgo
//                                                            endDate:oneYearFromNow
//                                                          calendars:nil];
//    
//    // Fetch all events that match the predicate
//    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
//    NSLog(@"CALENDAR = %@",calendar);
//    for (EKEvent *event in events) {
//        NSLog(@"---> %@ <---", event.title);
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ExamineTaskSegue"]) {
        TaskDetailViewController *tdvc = segue.destinationViewController;
        // Get the Task information from the stored Tasks array based on the index of the selected row
        Task * task = [self.fetchedTasksArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        NSLog(@"Current Table View: %@", self.tableView);
        
        [tdvc setTask:task];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"NUMTASKS: %lu",(unsigned long)[self.fetchedTasksArray count]);
    return [self.fetchedTasksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"standardIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Task * task = [self.fetchedTasksArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithString:task.name];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [tableView beginUpdates];

        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // 3
        if (SERVER_MODE) {
            // Visual Notification:
            [HUD showUIBlockingIndicatorWithText:@"Deleting Task"];
            
            // Update the Back-End with JSON call:
            [manager deleteUserTask:[self.fetchedTasksArray objectAtIndex:indexPath.row]];
            
            // Update the local (non-persistence) tableview data source array:
            [self.fetchedTasksArray removeObjectAtIndex:indexPath.row];
            
            // Update the tableview 'view' itself
            [self.tableView endUpdates];
        } else {
            [self.managedObjectContext deleteObject:[self.fetchedTasksArray objectAtIndex:indexPath.row]];
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
            // 4
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            self.fetchedTasksArray = [appDelegate getAllTaskRecords];
            
            [tableView endUpdates];
        }        
    }
}


#pragma mark TasksManagerDelegate methods
- (void) didReceiveTasksArray:(NSArray *)tasksArray {
    // We reverse the array order because we do want tasks to be added at the TOP of the list and not the bottom
    self.fetchedTasksArray = [[tasksArray reverseObjectEnumerator] allObjects];
    
    [HUD performSelectorOnMainThread:@selector(hideUIBlockingIndicator) withObject:nil waitUntilDone:NO];

    // This must be used, otherwise the tableview data does not refresh until the user touches the view:
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) didDeleteTask {
    [HUD performSelectorOnMainThread:@selector(hideUIBlockingIndicator) withObject:nil waitUntilDone:NO];
}

@end







