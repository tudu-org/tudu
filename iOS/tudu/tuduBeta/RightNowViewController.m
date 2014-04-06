//
//  RightNowViewController.m
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import "RightNowViewController.h"

@interface RightNowViewController ()
@end
@implementation RightNowViewController
@synthesize rntdViewController;


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
   
    // Clear the label text
    self.freeTimeValueLabel.text = @"";
   
    // Set up the slider to continuously update its value label text as it changes
    [self.freeTimeSlider addTarget:self action:@selector(durationSliderChanged:) forControlEvents:UIControlEventValueChanged];


}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.rntdViewController = segue.destinationViewController;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* This method gets called as the Duration Slider Value changes. */
- (void)durationSliderChanged:(UISlider *)slider {
    NSString *displayString;
    NSString *suffixStr;
    int val = slider.value;
    if (val == 0) { // The minimum value is set to 5 minutes in case users want to make a very small task
        displayString = [NSString stringWithFormat:@"5 minutes"];
        return;
    }
    int hr = val / 4; // the increment value of the slider is 15 minutes (4 per hour)
    int min = val % 4; // the left over minutes
    min *= 15; // To rightly represent minutes (they are gathered from the uislider as 4 per hour)
    if (hr == 0) {
        displayString = [NSString stringWithFormat:@"%i minutes", min];
    } else {
        if (hr > 1) {
            suffixStr = @"s";
        } else {
            suffixStr = @"";
        }
        if (min == 0) {
            displayString = [NSString stringWithFormat:@"%i hour%@", hr, suffixStr];
        } else {
            displayString = [NSString stringWithFormat:@"%i hour%@ and %i minutes", hr, suffixStr, min];
        }
    }
    
    self.freeTimeValueLabel.text = displayString;
}


- (IBAction)showNextTask:(id)sender {
    [self.rntdViewController showNextTask];
}

- (IBAction)showPreviousTask:(id)sender {
    [self.rntdViewController showPreviousTask];
}
@end
