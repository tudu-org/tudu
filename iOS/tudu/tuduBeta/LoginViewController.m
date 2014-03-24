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
@synthesize managedObjectContext, activityIndicator;
bool alreadyLoggedIn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark BackEndManagerDelegate protocol methods
- (void)didReceiveLoggedInUser:(UserJSON *)userJSON
{
    // We only want to have ONE user stored per device at a time, so we must delete all the user records before saving this one
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate deleteAllUserRecords];

    
    /* TODO: Optimize this code by placing the CoreData portion elsewhere.
     * We don't need to update every time, if it is the same login info. */
    User *_user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                               inManagedObjectContext:self.managedObjectContext];
    // Set the fields received from JSON:
    [_user setUser_id:userJSON.user_id];
    [_user setAuth_token:userJSON.auth_token];
    
    // Set the local fields (front-end entry):
    [_user setEmail:self.emailField.text];
    [_user setPassword_hash:self.passwordField.text]; /* TODO: Hash this password. */
    
    
    // Save the User to the CoreData database
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    NSLog(@"email = %@, password= %@, id=%@, auth_token=%@", _user.email, _user.password_hash, _user.user_id, _user.auth_token);
    // Hide the activity monitor spinner
    [HUD hideUIBlockingIndicator];
}

- (void)userLoginFailedWithError:(NSError *)error
{
    // Hide the activity monitor spinner
    [HUD hideUIBlockingIndicator];
    
    // Show an informative alert
    [self alertInvalidLogin]; /* TODO: show this */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // Set up the BackEndManager
    manager = [[BackEndManager alloc] init];
    manager.communicator = [[BackEndCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.bemDelegate = self;
    
    // Visuals:
    [self.activityIndicator setHidden:TRUE];

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
    }
    else if (numUsers > 1) { // This needs to be handled differently in the future (multiple accounts?)
        [appDelegate deleteAllUserRecords];

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                          message:@"Too many user accounts. Should only have 1 per device. We have deleted your other accounts now."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
    /* TODO: Get this figured out and cleared up. */
    /*if (alreadyLoggedIn == true) {
        if ([self verifyUserLogin:user.email withPassword:user.password_hash]) {
            //[self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self alertInvalidLogin];
        }
    }*/
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
    /*if (alreadyLoggedIn == false) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                       inManagedObjectContext:self.managedObjectContext];
        [user setEmail:self.emailField.text];
        [user setPassword_hash:self.passwordField.text];

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
    else {
        if ([self verifyUserLogin:self.emailField.text withPassword:self.passwordField.text]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self alertInvalidLogin];
        }
    }
    */
    
    // VERIFY USER LOGIN
    [HUD showUIBlockingIndicatorWithText:@"Verifying Login Info"];
    [manager userLogin:self.emailField.text withPass:self.passwordField.text];
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    
    //[HUD hideUIBlockingIndicator];

    // PULL USER TASKS :
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginComplete:)
//                                                 name:@"kDidReceiveLoggedInUser"
//                                               object:nil];
    
    // Show the spinning activity indicator:
    //[HUD showUIBlockingIndicatorWithText:@"Verifying Login Info"];
    
    //[manager userLogin:self.emailField.text withPass:self.passwordField.text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LoginSegue"]) {
        //[HUD showUIBlockingIndicatorWithText:@"Verifying Login Info"];
        //[manager userLogin:self.emailField.text withPass:self.passwordField.text]; // temporary for testing
        //[manager getUserTasks:[NSNumber numberWithInt:1] withAuth:@"3c24c586e316c4d4b02bab8a1925e039"];
        //[HUD hideUIBlockingIndicator];
    }
}


-(void) loginComplete:(NSNotification *)notification {
//    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

// ------------------- NO LONGER USING THIS METHOD -------------------
- (bool) verifyUserLogin:(NSString*)email withPassword:(NSString*)password {
    // OLD WAY OF DOING JSON
    //    WebBackEndManager *wbem = [[WebBackEndManager alloc] init];

    /* For now, we are only logging in using username=user1@gmail.com, pw=password. */
//    [wbem userLogin:email withPass:password];
    
    
    // NEW WAY OF DOING JSON - Using the BackEndManager
  //  [manager userLogin:email withPass:password];
    
    return true; /* TODO: Figure out how to check httpResponse error codes to see if it was a valid login. */
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













