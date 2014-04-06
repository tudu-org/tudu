//
//  TaskDetailViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/27/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "TaskDetailViewController.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController

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
    
    [self setTitle:self.task.name];
    
    // Duration
    [self.durationLabel setText:[NSString stringWithFormat:@"Duration: %@",self.task.duration]];
  
    // Deadline
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MMM d, h:mm a"]; // Feb 17, 7:59 PM
    NSString *deadlineString = [NSString stringWithFormat:@"Deadline: %@",[dateFormatter stringFromDate:self.task.deadline]];
    [self.deadlineLabel setText:deadlineString];

    
    int prio = [self.task.priority intValue];
    
    switch (prio) {
        case 0:
            [self.priorityLabel setText:@"Low Priority"];
            [self.priorityLabel setTextColor:[UIColor greenColor]];
            break;
        case 1:
            [self.priorityLabel setText:@"Medium Priority"];
            [self.priorityLabel setTextColor:[UIColor orangeColor]];
            break;
        case 2:
            [self.priorityLabel setText:@"High Priority"];
            [self.priorityLabel setTextColor:[UIColor redColor]];
            break;
            
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditTaskSegue"]) {
        CreateTaskViewController *ctvc = segue.destinationViewController;
        [ctvc setMode:1];
        [ctvc setTask:self.task]; // Pass along the task so that the Edit view controller can populate its fields with the correct data
    }
}


- (IBAction)unwindToTaskDetailViewController:(UIStoryboardSegue *)segue {
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
