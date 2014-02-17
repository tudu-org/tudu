//
//  ScheduleViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "ScheduleViewController.h"
#import "CalendarKit/CalendarKit.h"

@interface ScheduleViewController ()

@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *dayView;
@property (weak, nonatomic) IBOutlet UIButton *weekView;
@property (weak, nonatomic) IBOutlet UIButton *monthView;

@end

@implementation ScheduleViewController

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
    
    [self.dayView addTarget:self
                 action:@selector(btnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.weekView addTarget:self
                     action:@selector(btnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.monthView addTarget:self
                     action:@selector(btnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    
    // 1. Instantiate a CKCalendarView
    self.calendar = [[CKCalendarView alloc] init];
    // 2. Optionally, set up the datasource and delegates
    [self.calendar setDelegate:self];
    [self.calendar setDataSource:self];
    self.calendar.displayMode = 2;
    
    // 3. Present the calendar
    [[self calendarView] addSubview:self.calendar];

}

//-(void)addEvent:(EKEvent*)event{
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnClicked:(id)sender{
    NSLog(@"Button pressed: %@", [sender currentTitle]);
    
    if([[sender currentTitle] isEqual: @"Month"]){
        self.calendar.displayMode = 0;
    }
    
    if([[sender currentTitle] isEqual: @"Week"]){
        self.calendar.displayMode = 1;
    }
    
    if([[sender currentTitle] isEqual: @"Day"]){
        self.calendar.displayMode = 2;
    }
    
}

@end
