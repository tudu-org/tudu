//
//  EventDetailViewController.m
//  tuduBeta
//
//  Created by Ryan Cleary on 5/1/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;

@end

@implementation EventDetailViewController
@synthesize event;
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
    
    self.title = event.name;
    
    // Start Time:
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MMM d, h:mm a"]; // e.g. Feb 17, 7:59 PM
    NSString *startTimeStr = [NSString stringWithFormat:@"Start Time: %@",[dateFormatter stringFromDate:self.event.start_time]];
    [self.startTimeLabel setText:startTimeStr];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
