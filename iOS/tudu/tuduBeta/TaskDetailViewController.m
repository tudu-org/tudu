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
    
    [self.durationLabel setText:[NSString stringWithFormat:@"Duration: %@",self.task.duration]];
    [self.priorityLabel setText:[NSString stringWithFormat:@"Priority: %@",self.task.priority]];
    [self.deadlineLabel setText:[NSString stringWithFormat:@"Deadline: %@",self.task.deadline]];
    [self setTitle:self.task.name];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditTaskSegue"]) {
        CreateTaskViewController *ctvc = segue.destinationViewController;
        [ctvc setTask:self.task]; // Pass along the task so that the Edit view controller can populate its fields with the correct data
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
