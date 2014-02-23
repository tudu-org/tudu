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

@implementation TasksViewController
@synthesize fetchedRecordsArray;

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
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    // Fetching Records and saving it in "fetchedRecordsArray" object
    self.fetchedRecordsArray = [appDelegate getAllTaskRecords];
    [self.tableView reloadData];
    
    
    // Test this code for events:
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        // handle access here
    }];

    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
    NSLog(@"CALENDAR = %@",calendar);
    for (EKEvent *event in events) {
        NSLog(@"---> %@ <---", event.title);
    }
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
        Task * task = [self.fetchedRecordsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row+1]; // +1 for difference between array indexing
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
    NSLog(@"NUMTASKS: %lu",(unsigned long)[self.fetchedRecordsArray count]);
    return [self.fetchedRecordsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"standardIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Task * task = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
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
        [self.managedObjectContext deleteObject:[self.fetchedRecordsArray objectAtIndex:indexPath.row]];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        // 4
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.fetchedRecordsArray = [appDelegate getAllTaskRecords];
        // 5
        [tableView endUpdates];
    }
}

@end
