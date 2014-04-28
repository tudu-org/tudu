//
//  RightNowViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "RightNowViewController.h"

@interface RightNowViewController ()
@end

@implementation RightNowViewController
int currentTaskIndex;
int amountFreeTime;
@synthesize rntdViewController, swipeToTheRight, swipeToTheLeft;


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
    
    [self.taskContainer addGestureRecognizer:swipeToTheRight];
    [self.taskContainer addGestureRecognizer:swipeToTheLeft];

    // border radius
    [self.taskContainer.layer setCornerRadius:30.0f];

    
    // border
    //[self.taskContainer.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //[self.taskContainer.layer setBorderWidth:1.5f];
    
    // drop shadow
    [self.shadowView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.shadowView.layer setShadowOpacity:0.8];
    [self.shadowView.layer setShadowRadius:100.0];
    [self.shadowView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    CGRect tcRect = self.taskContainer.frame;
    CGRect shadowRect = CGRectMake(tcRect.origin.x+3, tcRect.origin.y+3, tcRect.size.width, tcRect.size.height);
    
    UIView *cartoonShadow = [[UIView alloc] initWithFrame:shadowRect];
    [cartoonShadow setBackgroundColor:[UIColor darkGrayColor]];
    [cartoonShadow.layer setCornerRadius:30.0f];
    //[cartoonShadow addSubview:self.taskContainer];
    [self.view addSubview:cartoonShadow];
    [self.view sendSubviewToBack:cartoonShadow];

    
    currentTaskIndex = 0;
    
    // Set up the BackEndManager
    manager = [[BackEndManager alloc] init];
    manager.communicator = [[BackEndCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.tmDelegate = self;
    
    // Set up the filtered tasks array
    self.filteredTasksArray = [[NSMutableArray alloc] init];
    
    // Pull the latest tasks
    [HUD showUIBlockingIndicatorWithText:@"Downloading Tasks"];
    [manager getUserTasks];

    
    // Clear the label text
    self.freeTimeValueLabel.text = @"2 hours";
   
    // Set up the slider to continuously update its value label text as it changes
    [self.freeTimeSlider addTarget:self action:@selector(durationSliderChanged:) forControlEvents:UIControlEventValueChanged];

}

#pragma mark TasksManagerDelegate methods
- (void) didReceiveTasksArray:(NSArray *)tasksArray {
    // We reverse the array order because we do want tasks to be added at the TOP of the list and not the bottom
    //self.fetchedTasksArray = [[tasksArray reverseObjectEnumerator] allObjects];
    
    self.fetchedTasksArray = [NSMutableArray arrayWithArray:tasksArray];
    [self filterTasksByAmountOfFreeTime];
    
    /*if ([self.fetchedTasksArray count] == 0) {
        [self.titleLabel setText:@"You don't have any tasks!"];
        [self.durationLabel setText:@""];
        [self.deadlineLabel setText:@""];
    } else {
        [self populateView:[self.fetchedTasksArray objectAtIndex:0]];
    }*/
    
    [self.rntdViewController populateView:[self.fetchedTasksArray firstObject]];
    //[HUD hideUIBlockingIndicator];
    [HUD performSelectorOnMainThread:@selector(hideUIBlockingIndicator) withObject:nil waitUntilDone:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.rntdViewController = segue.destinationViewController;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)filterTasksByAmountOfFreeTime {
    // (1) Clear the filtered tasks array
    [self.filteredTasksArray removeAllObjects];
    
    // (2) Sort the tasks, showing the tasks with ASCENDING Duration values
    NSSortDescriptor *sortByDuration = [NSSortDescriptor sortDescriptorWithKey:@"duration" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDuration];
    self.fetchedTasksArray = [NSMutableArray arrayWithArray:[self.fetchedTasksArray sortedArrayUsingDescriptors:sortDescriptors]];

    // (3) Add in the tasks that the user has time for right now
    for (int i=0; i<self.fetchedTasksArray.count; i++) {
        Task *t = [self.fetchedTasksArray objectAtIndex:i];
        int taskDuration = [t.duration intValue];
        if (taskDuration <= amountFreeTime) {
            [self.filteredTasksArray addObject:[self.fetchedTasksArray objectAtIndex:i]];
        } else {
            break;
        }
    }
}

/* This method gets called as the Duration Slider Value changes. */
- (void)durationSliderChanged:(UISlider *)slider {
    NSString *displayString;
    NSString *suffixStr;
    int val = slider.value;
    if (val == 0) { // The minimum value is set to 15 minutes in case users want to make a very small task
        displayString = [NSString stringWithFormat:@"15 minutes"];
        return;
    }
    int hr = val / 4; // the increment value of the slider is 15 minutes (4 per hour)
    int min = val % 4; // the left over minutes
    min *= 15; // To rightly represent minutes (they are gathered from the uislider as 4 per hour)
    amountFreeTime = (hr * 3600) + (min * 60); // calculate how much free time you have in seconds
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
    
    self.freeTimeValueLabel.text = displayString;
    [self filterTasksByAmountOfFreeTime];
}

- (IBAction)swipeRightRecognized:(id)sender {
    NSLog(@"YOU SWIPED TO THE RIGHT");
    if (currentTaskIndex-1 >= 0) { // Array bounds checking
        [self.rntdViewController populateView:[self.filteredTasksArray objectAtIndex:--currentTaskIndex]];
    }
}

- (IBAction)swipeLeftRecognized:(id)sender {
    NSLog(@"YOU SWIPED TO THE LEFT");
    if (currentTaskIndex+1 < [self.filteredTasksArray count]) { // Array bounds checking
        [self.rntdViewController populateView:[self.filteredTasksArray objectAtIndex:++currentTaskIndex]];
    }
}

- (IBAction)showNextTask:(id)sender {
    if (currentTaskIndex+1 < [self.filteredTasksArray count]) { // Array bounds checking
        [self.rntdViewController populateView:[self.filteredTasksArray objectAtIndex:++currentTaskIndex]];
    }
}

- (IBAction)showPreviousTask:(id)sender {
    if (currentTaskIndex-1 >= 0) { // Array bounds checking
        [self.rntdViewController populateView:[self.filteredTasksArray objectAtIndex:--currentTaskIndex]];
    }
}
@end





