//
//  RNTaskDetailViewController.h
//  tuduBeta
//
//  Created by Ryan Cleary on 3/5/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CreateTaskViewController.h"
#import "Task.h"

@interface RNTaskDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) Task *task;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void) populateView:(Task *)task;

@end
