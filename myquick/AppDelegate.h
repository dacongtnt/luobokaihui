//
//  AppDelegate.h
//  myquick
//
//  Created by 赵云 on 13-7-17.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (retain,nonatomic) QRootElement *root;

+ (NSInteger)OSVersion;

@end
