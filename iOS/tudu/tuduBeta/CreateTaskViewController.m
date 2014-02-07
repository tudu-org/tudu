//
//  CreateTaskViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "CreateTaskViewController.h"


@implementation CreateTaskViewController

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
    
    // CoreData Setup:
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Hide the Duration Slider (we only want it to appear after tapping 'Custom')
    [self.durationSlider setHidden:TRUE];
    
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
        
        case 4:
            [self.durationSlider setHidden:FALSE];
            [self.durationSegmentedControlBar setHidden:TRUE];
            //return getSecondsValueFromDurationSlider();
            break;
            
        default:
            return 0; // should never happen
            break;
    }
    return 0; // should never happen
}

- (IBAction)addBtnPressed:(id)sender {
    // Create a new Task object
    Task * newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                           inManagedObjectContext:self.managedObjectContext];
   
    // Gather data from view controller's data entry fields
    newTask.name = self.taskNameField.text;
    NSInteger durationIndex = self.durationSegmentedControlBar.selectedSegmentIndex;
    newTask.duration = [NSNumber numberWithInteger:[self getSecondsValueFromDurationSegmentedControlBar:durationIndex]];
    newTask.deadline = self.deadlineDatePicker.date;
    
    // Save the task to the CoreData database
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Clear the data entry fields
    self.taskNameField.text = @"";
    
    // Exit editing mode (Dismiss Keyboard)
    [self.view endEditing:YES];
    
    // Perform the segue to the TasksViewController
    [self performSegueWithIdentifier:@"AddTaskSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddTaskSegue"]) {
        NSLog(@"Preparing to add a task.");
        UITabBarController *tabBarController = segue.destinationViewController;
        tabBarController.selectedIndex = TASKS_TAB_INDEX;
    }
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







