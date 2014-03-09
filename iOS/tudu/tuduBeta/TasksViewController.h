//
//  TasksViewController.h
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "Task.h"
#import "AppDelegate.h"
#import "TaskDetailViewController.h"
#import "BackEndManager.h"
#import "User.h"

@interface TasksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TasksManagerDelegate> {
    BackEndManager *manager;
}

@property (nonatomic,strong)NSArray* fetchedTasksArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
