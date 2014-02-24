//
//  DetailViewController.h
//  iScheduler
//
//  Created by Alex Young on 10/24/13.
//  Copyright (c) 2013 Alex Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface DetailViewController : UIViewController
@property (strong, nonatomic) Task *task;
@end
