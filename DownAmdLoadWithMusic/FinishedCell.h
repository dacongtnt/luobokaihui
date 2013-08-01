//
//  FinishedCell.h
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FileModel.h"

@interface FinishedCell : UITableViewCell {
    IBOutlet UILabel *fileNameLabel;
    IBOutlet UILabel *fileSizeLabel;
    FileModel *fileInfo;
}
@property(nonatomic,retain)IBOutlet UILabel *fileNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *fileSizeLabel;
@property(nonatomic,retain)UIImageView *img;
@property(nonatomic,retain)IBOutlet FileModel *fileInfo;
@end
