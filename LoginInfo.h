//
//  AppDelegate.h
//  myquick
//
//  Created by 赵云 on 13-7-17.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfo : NSObject {

@private
    NSString *_password;
    NSString *_login;
}

@property(strong) NSString *login;
@property(strong) NSString *password;

@end