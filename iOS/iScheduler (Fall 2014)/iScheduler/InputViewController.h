//
//  ViewController.h
//  TextInput
//
//  Created by Alex Young on 3/26/13.
//  Copyright (c) 2013 Alex Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputCompletionHandler)(NSString *inputText, NSDate *date, NSInteger priority);

@interface InputViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (copy, nonatomic) InputCompletionHandler completionHandler;

@end
