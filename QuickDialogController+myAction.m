//
//  QuickDialogController+myAction.m
//  myquick
//
//  Created by 赵云 on 13-7-19.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import "QuickDialogController+myAction.h"
#import "ViewController.h"
#import "LoginInfo.h"
#import "Login.h"
#import "AppDelegate.h"

@implementation QuickDialogController (myAction)




-(void)exampleAction:(QBooleanElement *)element{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey!" message:@"This is the exampleAction method in the ExampleViewController" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    
    ViewController *view=[[ViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

@end
