//
//  HsData.h
//  myquick
//
//  Created by 张 伟 on 13-7-25.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HsData : UIViewController
{
    NSArray *arra;
    NSMutableArray *marra;
    NSString *tmpDir;
}

- (NSArray *)filesReturn;
@end
