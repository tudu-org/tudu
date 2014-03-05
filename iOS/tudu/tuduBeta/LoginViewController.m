//
//  LoginViewController.m
//  tuduBeta
//
//  Created by Ryan Cleary on 2/26/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize managedObjectContext;
bool alreadyLoggedIn;

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
    
    // CoreData Setup:
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Check to see if the user is already logged in:
    alreadyLoggedIn = false;
    
    // Fetch the user account info from core data
    NSArray *fetchedUserRecordsArray = [appDelegate getAllUserRecords];
    int numUsers = [fetchedUserRecordsArray count];
    User *user;
    if (numUsers == 1) {
        user = [fetchedUserRecordsArray firstObject];
        [self.emailField setText:user.email];
        [self.passwordField setText:user.password_hash]; /* TODO: Decrypt this. */
        alreadyLoggedIn = true;
        NSLog(@"email=%@, password=%@",user.email, user.password_hash);
    } else if (numUsers > 1) { // This needs to be handled differently in the future (multiple accounts?)
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                          message:@"Too many user accounts. Should only have 1 per device."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
    if (alreadyLoggedIn == true) {
        if ([self verifyUserLogin:user.email withPassword:user.password_hash]) {
            //[self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self alertInvalidLogin];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpBtnPressed:(id)sender {
    /* TODO: Connect this to the back-end for user creation verification. */
}

- (IBAction)loginBtnPressed:(id)sender {
    if (alreadyLoggedIn == false) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                       inManagedObjectContext:self.managedObjectContext];
        [user setEmail:self.emailField.text];
        [user setPassword_hash:self.passwordField.text]; /* TODO: Hash this password. */

        // Save the task to the CoreData database
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        if ([self verifyUserLogin:user.email withPassword:user.password_hash]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self alertInvalidLogin];
        }
    }
    else { /* TODO: Fix this- figure out how you are going to log in the user who is already logged in. */
        if ([self verifyUserLogin:self.emailField.text withPassword:self.passwordField.text]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self alertInvalidLogin];
        }
    }
    
    
}

- (bool) verifyUserLogin:(NSString*)email withPassword:(NSString*)password {
    return true; /* TODO: Connect this to the back-end for valid user login verification. */
}

-(void) alertInvalidLogin {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Login"
                                                      message:@"Invalid username or password combination."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

@end













