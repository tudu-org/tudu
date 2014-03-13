//
//  CreateTaskViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "CreateTaskViewController.h"


@implementation CreateTaskViewController {
    bool SERVER_MODE;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark TaskManagerDelegate methods
- (void)didCreateTask:(Task*)task
{
    /* TODO: Do this optimization in the future. */
    // Since we have the task, we can save time by simply INSERTING
    // the new task into the tableview instead of RELOADING it entirely
    // e.g. tableView beginUpdates, tableView insertRowsAtIndexPaths, tableView endUpdates
    [HUD hideUIBlockingIndicator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set up iphone to only store tasks & events on the back-end (no local storage)
    SERVER_MODE = TRUE;
    
    
    // Set up the BackEndManager
    manager = [[BackEndManager alloc] init];
    manager.communicator = [[BackEndCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.tmDelegate = self;
 
    
    // CoreData Setup:
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
   
    // Hide the Duration Slider items (we only want them to appear after tapping 'Custom')
    [self.durationSlider setHidden:TRUE];
    [self.durationValueLabel setHidden:TRUE];
    [self.durationMinLabel setHidden:TRUE];
    [self.durationMaxLabel setHidden:TRUE];
    
    // Set up the slider to continuously update its value label text as it changes
    [self.durationSlider addTarget:self action:@selector(durationSliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Hide the deadline label to begin with
    [self.deadlineLabel setHidden:TRUE];
    
    // Set the deadline picker to continuously update its value label as it changes
    [self.deadlineDatePicker addTarget:self action:@selector(deadlinePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    if (self.mode == 1) {
        // EDITING TASK MODE
        self.addBtn.title = @"Done"; // No longer "Add" but "Done", as in 'Done Editing'
        [self.taskNameField setText:self.task.name];
        [self.durationValueLabel setText:[NSString stringWithFormat:@"%@",self.task.duration]];
        //convert to integer
        int selectedSegmentedIndex = [self.task.priority intValue];
        [self.prioritySegmentedControlBar setSelectedSegmentIndex:selectedSegmentedIndex];
        [self.deadlineDatePicker setDate:self.task.deadline];
        self.navigationItem.title = @"Edit Task";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) getSecondsValueFromDurationSegmentedControlBar: (NSInteger) selectedIndex {

    switch (selectedIndex) {
        case 0:
            return 60*15; // 15 minutes
            break;
        case 1:
            return 60*30; // 30 minutes
            break;
        case 2:
            return 60*60; // 1 hour
            break;
        case 3:
            return 60*120; // 2 hours
            break;
        
//        case 4:
            //return getSecondsValueFromDurationSlider();
  //          break;
            
        default:
            return 0; // should never happen
            break;
    }
    return 0; // should never happen
}

- (IBAction)addBtnPressed:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(self.mode ==0){
        // Create a new Task object
        Task * newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                       inManagedObjectContext:self.managedObjectContext];
        
        // Gather data from view controller's data entry fields
        newTask.name = self.taskNameField.text;
        NSInteger durationIndex = self.durationSegmentedControlBar.selectedSegmentIndex;
        if ([self.durationSegmentedControlBar isHidden]) {
            // We are taking the duration value from the duration slider
            int durVal = self.durationSlider.value;
            if (durVal == 0) {
                newTask.duration = [NSNumber numberWithInt:(5*60)]; // 5 minutes, converted to seconds
            } else {
                newTask.duration = [NSNumber numberWithInt:(durVal * 15 * 60)]; // stores increments of 15 minutes, convert to seconds
            }
        } else {
            // We are taking the duration value from the duration segmented control
            newTask.duration = [NSNumber numberWithInteger:[self getSecondsValueFromDurationSegmentedControlBar:durationIndex]];
        }
        
        //newTask.priority = self.prioritySegmentedControlBar.selectedSegmentIndex;
        
        switch(self.prioritySegmentedControlBar.selectedSegmentIndex){
            case 0:
                newTask.priority = [[NSNumber alloc]initWithInt:0];
                break;
            case 1:
                newTask.priority = [[NSNumber alloc]initWithInt:1];
                break;
            case 2:
                newTask.priority = [[NSNumber alloc]initWithInt:2];
                break;
                
            default:
                newTask.priority = [[NSNumber alloc]initWithInt:-1];//SHOULD NEVER HAPPEN
                break;
                
        }
        
        newTask.deadline = self.deadlineDatePicker.date;
        
        // Clear the data entry fields
        self.taskNameField.text = @"";
        
        // Exit editing mode (Dismiss Keyboard)
        [self.view endEditing:YES];
    
        if (SERVER_MODE) {
            // Do any additional setup after loading the view.
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            NSArray *fetchedUserRecordsArray = [appDelegate getAllUserRecords];
            User *user = [fetchedUserRecordsArray objectAtIndex:0];
            
            [HUD showUIBlockingIndicatorWithText:@"Creating Task"];
            [manager createUserTask:newTask withUserID:user.user_id withAuth:user.auth_token];
        }
    }
    if(self.mode ==1){
        NSInteger durationIndex = self.durationSegmentedControlBar.selectedSegmentIndex;
        if ([self.durationSegmentedControlBar isHidden]) {
            // We are taking the duration value from the duration slider
            int durVal = self.durationSlider.value;
            if (durVal == 0) {
                self.task.duration = [NSNumber numberWithInt:(5*60)]; // 5 minutes, converted to seconds
            } else {
                self.task.duration = [NSNumber numberWithInt:(durVal * 15 * 60)]; // stores increments of 15 minutes, convert to seconds
            }
        } else {
            // We are taking the duration value from the duration segmented control
            self.task.duration = [NSNumber numberWithInteger:[self getSecondsValueFromDurationSegmentedControlBar:durationIndex]];
        }
        self.task.name = self.taskNameField.text;
                
        self.task.priority = [NSNumber numberWithInteger:self.prioritySegmentedControlBar.selectedSegmentIndex];
        
        self.task.deadline = self.deadlineDatePicker.date;
        
    }
    
    
    // Save the task to the CoreData database
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    
    // Perform the segue to the TasksViewController
    [self performSegueWithIdentifier:@"AddTaskSegue" sender:sender];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddTaskSegue"]) {
        UITabBarController *tabBarController = segue.destinationViewController;
        tabBarController.selectedIndex = TASKS_TAB_INDEX;
    }
}

/* This method gets called when the duration segmented control bar changes. */
- (IBAction)durationValueChanged:(id)sender {
    int index = [self.durationSegmentedControlBar selectedSegmentIndex];
    switch (index) {
        case 0: // "15 min"
            //[self.durationValueLabel setText:@"15 minutes"];
            break;
        case 1: // "30 min"
            //[self.durationValueLabel setText:@"30 minutes"];
            break;
        case 2: // "1 hr"
            //[self.durationValueLabel setText:@"1 hour"];
            break;
        case 3: // "2 hrs"
            //[self.durationValueLabel setText:@"2 hours"];
            break;
        case 4: // "Custom"
            [self.durationSlider setHidden:FALSE];
            [self.durationMinLabel setHidden:FALSE];
            [self.durationMaxLabel setHidden:FALSE];
            [self.durationValueLabel setHidden:FALSE];
            [self.durationSegmentedControlBar setHidden:TRUE];
            break;
            
        default:
            break;
    }
}


/* This method gets called as the Duration Slider Value changes. */
- (void)durationSliderChanged:(UISlider *)slider {
    NSString *displayString;
    NSString *suffixStr;
    int val = slider.value;
    if (val == 0) { // The minimum value is set to 5 minutes in case users want to make a very small task
        displayString = [NSString stringWithFormat:@"5 minutes"];
        return;
    }
    int hr = val / 4; // the increment value of the slider is 15 minutes (4 per hour)
    int min = val % 4; // the left over minutes
    min *= 15; // To rightly represent minutes (they are gathered from the uislider as 4 per hour)
    if (hr == 0) {
        displayString = [NSString stringWithFormat:@"%i minutes", min];
    } else {
        if (hr > 1) {
            suffixStr = @"s";
        } else {
            suffixStr = @"";
        }
        if (min == 0) {
            displayString = [NSString stringWithFormat:@"%i hour%@", hr, suffixStr];
        } else {
            displayString = [NSString stringWithFormat:@"%i hour%@ and %i minutes", hr, suffixStr, min];
        }
    }
    
    self.durationValueLabel.text = displayString;
}

/* This method gets called as the Deadline Date Picker changes. */
- (void)deadlinePickerDateChanged:(UIDatePicker *)datePicker {
    [self.deadlineLabel setHidden:FALSE];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MMM d, h:mm a"]; // Feb 17, 7:59 PM
    NSString *deadlineString = [dateFormatter stringFromDate:self.deadlineDatePicker.date];

    [self.deadlineLabel setText:deadlineString];
}


/* Hide the keyboard when the user taps something other than the Task name field. */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.taskNameField isFirstResponder] && [touch view] != self.taskNameField) {
        [self.taskNameField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


@end







