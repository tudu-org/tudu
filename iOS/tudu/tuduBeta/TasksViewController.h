//
//  TasksViewController.h
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "AppDelegate.h"
#import "TaskDetailViewController.h"


@interface TasksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong)NSArray* fetchedRecordsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
