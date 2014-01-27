//
//  DetailViewController.m
//  iScheduler
//
//  Created by Alex Young on 10/24/13.
//  Copyright (c) 2013 Alex Young. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()



@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityLabel;

@end

@implementation DetailViewController

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
    
    self.nameLabel.text = [self.task name];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YY"];
    self.dateLabel.text = [dateFormatter stringFromDate:[self.task dueDate]];
    self.priorityLabel.selectedSegmentIndex = [self.task priority];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
