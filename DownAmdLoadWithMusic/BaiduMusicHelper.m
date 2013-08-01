//
//  BaiduMusicHelper.m
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//
#import "BaiduMusicHelper.h"


@implementation BaiduMusicHelper

+(NSData *)getDataByMusicName:(NSString *)musicName
{
    NSString *requestUrl=BAIDUMUSIC_API(musicName);
    ASIHTTPRequest *theRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [theRequest addRequestHeader:@"Content-Type" value:@"text/xml"];
    [theRequest setRequestMethod:@"GET"];//ASIHttpRequest默认是GET
    [theRequest startSynchronous];
    NSError *error=[theRequest error];
    if(error!=nil)
    {
        NSLog(@"BaiduMusicHelper百度请求错误：%@",error);
    }
    return [theRequest responseData];
}
@end

