//
//  RootViewController.h
//  Audio
//
//  Created by 吕 布 on 13-7-20.
//  Copyright (c) 2013年 吕 布. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AudioView : RootViewController<UITableViewDelegate,UITextViewDelegate,UITableViewDataSource>
{
	NSMutableArray *fileArray;
}

@property (nonatomic, retain) NSMutableArray *fileArray;
@property(nonatomic,retain) UITableView *tableView;
@end