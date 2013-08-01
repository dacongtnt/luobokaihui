//
//  CommonHelper.m
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//

#import "CommonHelper.h"
#import "Memo.h"

@implementation CommonHelper


+(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    [ouncesDecimal release];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
+(NSString *)getFileSizeString:(NSString *)size
{
    if([size floatValue]>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        float f=[size floatValue]/1024/1024;
        NSString *sv=[self notRounding:f afterPoint:2];
        return [sv stringByAppendingString:@"MB"];
        
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        
        float k=[size floatValue]/1024;
        NSString *fk=[self notRounding:k afterPoint:2];
        return [fk stringByAppendingString:@"KB"];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        float b=[size floatValue]/1024;
        NSString *bk=[self notRounding:b afterPoint:2];
        return [bk stringByAppendingString:@"B"];
    }
}

+(float)getFileSizeNumber:(NSString *)size
{
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

+(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Songs"];
}

+(NSString *)getTargetFloderPath
{
    return [self getDocumentPath];
}

+(NSString *)getTempFolderPath
{
//    Memo *mymemo=[[Memo alloc] init];
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Temp"];
}

+(BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+(float)getProgress:(float)totalSize currentSize:(float)currentSize
{
    return currentSize/totalSize;
}
@end
