//
//  TaskDetailViewController.h
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/27/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateTaskViewController.h"
#import "Task.h"

@interface TaskDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *priorityLabel;
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (strong, nonatomic) Task *task;

- (IBAction)unwindToTaskDetailViewController:(UIStoryboardSegue *)segue;

@end
