//
//  ScheduleViewController.h
//  tuduBeta
//
//  Created by Jonathan Rusnak on 1/25/14.
//  Copyright (c) 2014 Jonathan Rusnak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKit/EventKit.h>
#import "CKCalendarView.h"
#import "BackEndManager.h"
#import "HUD.h"

@interface ScheduleViewController : UIViewController<EventsManagerDelegate, CKCalendarViewDelegate, CKCalendarViewDataSource> {
    BackEndManager *manager;
}
@property (strong, nonatomic) CKCalendarView *calendar;
@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;


@end
