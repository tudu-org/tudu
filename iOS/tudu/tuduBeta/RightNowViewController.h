//
//  RightNowViewController.h
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNTaskDetailViewController.h"

@interface RightNowViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *taskContainer;
@property (strong, nonatomic) IBOutlet UIButton *rightArrowBtn;
@property (strong, nonatomic) IBOutlet UIButton *leftArrowBtn;
@property (strong, nonatomic) RNTaskDetailViewController *rntdViewController;
@property (strong, nonatomic) IBOutlet UISlider *freeTimeSlider;
@property (strong, nonatomic) IBOutlet UILabel *freeTimeValueLabel;

- (IBAction)showNextTask:(id)sender;
- (IBAction)showPreviousTask:(id)sender;

@end
