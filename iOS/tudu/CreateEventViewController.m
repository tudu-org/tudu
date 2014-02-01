//
//  CreateEventViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 2/1/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController ()

@end

@implementation CreateEventViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addEventBtnPressed:(id)sender {
    [self performSegueWithIdentifier:@"AddEventSegue" sender:sender];
    self.tabBarController.selectedIndex=SCHEDULE_TAB_INDEX;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddEventSegue"]) {
        NSLog(@"im preppin to add event");
        //        UINavigationController *navigationController = segue.destinationViewController;
        //        PlayerDetailsViewController *playerDetailsViewController = [navigationController viewControllers][0];
        //        playerDetailsViewController.delegate = self;
    }
}


@end
