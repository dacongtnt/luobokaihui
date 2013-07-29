//
//  AppDelegate.m
//  myquick
//
//  Created by 赵云 on 13-7-17.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface RootViewController : UIViewController<UIActionSheetDelegate>

@property (strong, readonly, nonatomic) RESideMenu *sideMenu;
@property (nonatomic, retain) NSMutableArray *fileArray;


@end
