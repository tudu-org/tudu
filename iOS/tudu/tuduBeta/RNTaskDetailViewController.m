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

-(void) viewDidAppear:(BOOL)animated {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Fetching Records and saving it in "fetchedRecordsArray" object
    self.fetchedRecordsArray = [appDelegate getAllTaskRecords];
    if ([self.fetchedRecordsArray count] == 0) {
        [self.titleLabel setText:@"You don't have any tasks!"];
        [self.durationLabel setText:@""];
        [self.deadlineLabel setText:@""];
    } else {
        [self populateView:[self.fetchedRecordsArray objectAtIndex:0]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) populateView:(Task *)task {
    [self.titleLabel setText:task.name];
    [self.durationLabel setText:[NSString stringWithFormat:@"Duration: %@",task.duration]];
    [self.deadlineLabel setText:[NSString stringWithFormat:@"%@",task.deadline]];
    int prio = [task.priority intValue];
    switch (prio) {
            /* TODO: Make these Constants and store them in Constants.h */
        case 0:
            [self.view setBackgroundColor:[UIColor greenColor]];
            break;
        case 1:
            [self.view setBackgroundColor:[UIColor yellowColor]];
            break;
        case 2:
            [self.view setBackgroundColor:[UIColor redColor]];
            break;
            
        default:
            [self.view setBackgroundColor:[UIColor orangeColor]];
            break;
    }
}

-(void) showNextTask {
    if (currentTaskIndex+1 < [self.fetchedRecordsArray count]) { // Array bounds checking
        [self populateView:[self.fetchedRecordsArray objectAtIndex:++currentTaskIndex]];
    }
}

-(void) showPreviousTask {
    if (currentTaskIndex-1 >= 0) { // Array bounds checking
        [self populateView:[self.fetchedRecordsArray objectAtIndex:--currentTaskIndex]];
    }
}


@end





