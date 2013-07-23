//
//  DownloadDelegate.h
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol DownloadDelegate <NSObject>

-(void)startDownload:(ASIHTTPRequest *)request;
-(void)updateCellProgress:(ASIHTTPRequest *)request;
-(void)finishedDownload:(ASIHTTPRequest *)request;

@end
