//
//  ViewController.m
//  TextInput
//
//  Created by Alex Young on 3/26/13.
//  Copyright (c) 2013 Alex Young. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityPicker;
@end

@implementation InputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setScrollEnabled:YES];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    [self.inputField becomeFirstResponder];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    if (self.completionHandler) {
        self.completionHandler(nil, nil, nil);
    }
}
- (IBAction)saveButtonTapped:(id)sender
{
    if (self.completionHandler) {
        NSMutableString* message = [NSMutableString stringWithString: self.inputField.text];
        [message appendString: @" will be scheduled for "];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/YY"];
        [message appendString: [dateFormatter stringFromDate:self.datePicker.date]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:message delegate:self cancelButtonTitle:@"Reschedule" otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // Reschedule
            
            break;
        default:
            self.completionHandler(self.inputField.text, self.datePicker.date, self.priorityPicker.selectedSegmentIndex);
            break;
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (self.completionHandler) {
        self.completionHandler(self.inputField.text, self.datePicker.date, self.priorityPicker.selectedSegmentIndex);
    }
    return YES;
}

- (BOOL) textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *changedString = [textField.text
                               stringByReplacingCharactersInRange:range withString:string];
    [self validateSaveButtonForText:changedString];
    // Do not actually replace the text field's text!
    // Return YES and let UIKit do it
    return YES;
}
- (void) validateSaveButtonForText:(NSString *)text
{
    self.saveButton.enabled = ([text length] > 0);
}

@end
