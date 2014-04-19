//
//  RNTaskDetailViewController.m
//  tuduBeta
//
//  Created by Ryan Cleary on 3/5/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "RNTaskDetailViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


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
   
    
    
    /* AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
     self.managedObjectContext = appDelegate.managedObjectContext;*/
    
    // Pull the latest tasks
    
    
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
            [self.view setBackgroundColor:UIColorFromRGB(0x3BDA00)];
            break;
        case 1:
            [self.view setBackgroundColor:UIColorFromRGB(0xFFCA00)];
            break;
        case 2:
            [self.view setBackgroundColor:UIColorFromRGB(0xF10026)];
            break;
            
        default:
            [self.view setBackgroundColor:[UIColor grayColor]];
            break;
    }
}



@end





