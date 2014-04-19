//
//  TaskDetailViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/27/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "TaskDetailViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
    NSLog(@"DEETS_created_at = %@",self.task.created_at);
    NSLog(@"DEETS_updated_at = %@",self.task.updated_at);
    // Task Title
    [self setTitle:self.task.name];
    
    // Task Duration
    NSString *durationDisplayString;
    NSString *suffixStr;
    int val = [self.task.duration intValue];
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
    [self.durationLabel setText:[NSString stringWithFormat:@"Duration: %@",durationDisplayString]];
  
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
            [self.priorityLabel setTextColor:UIColorFromRGB(0x3BDA00)];
            break;
        case 1:
            [self.priorityLabel setText:@"Medium Priority"];
            [self.priorityLabel setTextColor:UIColorFromRGB(0xFFCA00)];
            break;
        case 2:
            [self.priorityLabel setText:@"High Priority"];
            [self.priorityLabel setTextColor:UIColorFromRGB(0xF10026)];
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
