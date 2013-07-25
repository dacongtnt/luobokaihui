//
//  Login.m
//  myquick
//
//  Created by 赵云 on 13-7-19.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import "Login.h"
#import "LoginInfo.h"
#import "QuickDialogController+myAction.h"
#import "Memo.h"

@implementation Login

+ (QRootElement *)create
{
    
    
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"LoginController";
//    root.grouped = YES;
    root.title = @"登陆";
    
    QSection *main = [[QSection alloc] init];
    main.headerImage = @"logo";
    
    for (int i=0; i<3; i++) {
        QLabelElement *label=[[QLabelElement alloc] init];
        [main addElement:label];
    }
    
    QEntryElement *login = [[QEntryElement alloc] init];
    login.title = @"      用户名：";
    login.key = @"login";
    login.hiddenToolbar = YES;
    login.placeholder = @"User Name";
    [main addElement:login];
    
    QEntryElement *password = [[QEntryElement alloc] init];
    password.title = @"        密码：";
    password.key = @"password";
    password.secureTextEntry = YES;
    password.hiddenToolbar = YES;
    password.placeholder = @"Password";
    [main addElement:password];
    
    [root addSection:main];
    
    QSection *btSection = [[QSection alloc] init];
    
    QLabelElement *labelb=[[QLabelElement alloc] init];
    [btSection addElement:labelb];

    
    QButtonElement *btLogin = [[QButtonElement alloc] init];
    btLogin.title = @"登陆";
    btLogin.controllerAction = @"onLogin:";
    [btSection addElement:btLogin];
    [btLogin setImage:[UIImage imageNamed:@""]];
    
    [root addSection:btSection];
    
    btSection.footerImage = @"footer";
    
    MCRelease(root);
    MCRelease(main);
    MCRelease(login);
    MCRelease(password);
    MCRelease(btLogin);
    MCRelease(btSection);
    
    return root;

}

+ (QRootElement *)createMainFrom
{
    Memo *memo=[[Memo alloc] init];
    [memo addNewFile:@"NO1.txt" contents:@"acafa"];
    [memo addNewFile:@"NO2.txt" contents:@"acafa"];
    [memo addNewFile:@"NO3.txt" contents:@"acafa"];
    [memo addNewFile:@"NO4.txt" contents:@"acafa"];
    
//    NSString *str=[[memo loadOldFile] objectAtIndex:0];
//    NSData *reades=[NSData dataWithContentsOfFile:[memo.filePath stringByAppendingPathComponent:str]];
//    NSString *strs=[[NSString alloc] initWithData:[reades subdataWithRange:NSMakeRange(0, reades.length)] encoding:NSUTF8StringEncoding];
    
    


    
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped=YES;
    QSection *sec=[[QSection alloc] init];
    
    NSLog(@"%@",[[memo loadOldFile] objectAtIndex:0]);
    
    NSArray *array=[NSArray arrayWithArray:[memo loadOldFile]];
    NSLog(@"%@",array);
    
//    for (int i=0; i<[array count]; i++) {
//        QLabelElement *label=[[QLabelElement alloc] initWithTitle:[array objectAtIndex:i] Value:nil];
//        [sec addElement:label];
//    }
    
    QAutoEntryElement *autoElement = [[QAutoEntryElement alloc] initWithTitle:@"AutoComplete" value:nil placeholder:@"type letter M"];
    autoElement.autoCompleteValues = array;
    autoElement.autoCompleteColor = [UIColor orangeColor];
//	autoElement.key = @"entry2";
    
    [sec addElement:autoElement];

//    QLabelElement *label=[[QLabelElement alloc] initWithTitle:@"fadfaf" Value:nil];
//    
//    QBadgeElement *badge3 = [[QBadgeElement alloc] initWithTitle:@"With some action" Value:@"123"];
//    badge3.badgeColor = [UIColor purpleColor];
//    QSection *secss = [[QSection alloc] initWithTitle:@"Jazzin.."];
//    [secss addElement:label];
//    [badge3 addSection:secss];
//    [badge3 addSection:sec];
//    [sec addElement:badge3];
    
    [root addSection:sec];

    return root;
}

@end
