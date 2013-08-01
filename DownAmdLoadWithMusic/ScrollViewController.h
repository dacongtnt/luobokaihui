//
//  ScrollViewController.h
//  myquick
//
//  Created by 张翼德 on 13-7-26.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAAutoTextView.h"
#import "RootViewController.h"
@interface ScrollViewController :RootViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet DAAutoTextView *textView;

@end
