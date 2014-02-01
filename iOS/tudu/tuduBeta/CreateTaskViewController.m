//
//  CreateTaskViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "CreateTaskViewController.h"

@interface CreateTaskViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBtn;

@end

@implementation CreateTaskViewController

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
- (IBAction)addBtnPressed:(id)sender {
    NSLog(@"YAAY");
    [self performSegueWithIdentifier:@"AddTaskSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddTaskSegue"]) {
        NSLog(@"Preparing to add a task.");
        UITabBarController *tabBarController = segue.destinationViewController;
        tabBarController.selectedIndex = TASKS_TAB_INDEX;
//        UINavigationController *navigationController = segue.destinationViewController;
//        PlayerDetailsViewController *playerDetailsViewController = [navigationController viewControllers][0];
//        playerDetailsViewController.delegate = self;
    }
}

@end
