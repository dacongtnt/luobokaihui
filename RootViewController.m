//
//  AppDelegate.m
//  myquick
//
//  Created by 赵云 on 13-7-17.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import "RootViewController.h"
#import "DemoViewController.h"
#import "SecondViewController.h"
#import "Login.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "AViewController.h"
#import "AudioView.h"
#import "DownloadViewController.h"
#import "BaiduMusicViewController.h"
#import <dispatch/dispatch.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
}

#pragma mark -
#pragma mark Button actions

- (void)showMenu
{
    if (!_sideMenu) {
        
        dispatch_queue_t myQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t mainQueue=dispatch_get_main_queue();
        NSMutableArray *myArray=[[NSMutableArray alloc] init];
        
        dispatch_async(myQueue, ^{
            __block  AudioView *viewController = nil;
            __block  RESideMenuItem *homeItem=nil;
            dispatch_sync(myQueue, ^{
                viewController = [[AudioView alloc] init];
                homeItem = [[RESideMenuItem alloc] initWithTitle:@"音乐播放器" action:^(RESideMenu *menu, RESideMenuItem *item) {
                    viewController.title = item.title;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                    [menu setRootViewController:navigationController];
                }];
            });
            dispatch_sync(mainQueue, ^{
                [myArray addObject:homeItem];
            });
        });
        
        dispatch_async(myQueue, ^{
            __block  BaiduMusicViewController *secondViewController = nil;
            __block  RESideMenuItem *exploreItem=nil;
            dispatch_sync(myQueue, ^{
                secondViewController = [[BaiduMusicViewController alloc] init];
                exploreItem = [[RESideMenuItem alloc] initWithTitle:@"音乐下载" action:^(RESideMenu *menu, RESideMenuItem *item) {
                    secondViewController.title = item.title;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
                    [menu setRootViewController:navigationController];
                }];
            });
            dispatch_sync(mainQueue, ^{
                [myArray addObject:exploreItem];
            });
        });
        
        dispatch_async(myQueue, ^{
            __block  DownloadViewController *secondViewController = nil;
            __block  RESideMenuItem *exploreItem=nil;
            dispatch_sync(myQueue, ^{
                secondViewController = [[DownloadViewController alloc] init];
                exploreItem = [[RESideMenuItem alloc] initWithTitle:@"正在下载的音乐" action:^(RESideMenu *menu, RESideMenuItem *item) {
                    secondViewController.title = item.title;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
                    [menu setRootViewController:navigationController];
                }];
            });
            dispatch_sync(mainQueue, ^{
                [myArray addObject:exploreItem];
            });
        });
        
        dispatch_async(myQueue, ^{
            __block  AViewController *secondViewController = nil;
            __block  RESideMenuItem *activityItem=nil;
            dispatch_sync(myQueue, ^{
                secondViewController = [[AViewController alloc] init];
                activityItem = [[RESideMenuItem alloc] initWithTitle:@"录音" action:^(RESideMenu *menu, RESideMenuItem *item) {
                    secondViewController.title = item.title;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
                    [menu setRootViewController:navigationController];
                }];
            });
            dispatch_sync(mainQueue, ^{
                [myArray addObject:activityItem];
            });
        });
        
        dispatch_async(myQueue, ^{
            __block  SecondViewController *secondViewController = nil;
            __block  RESideMenuItem *profileItem=nil;
            dispatch_sync(myQueue, ^{
                secondViewController = [[SecondViewController alloc] init];
                profileItem = [[RESideMenuItem alloc] initWithTitle:@"关于我们" action:^(RESideMenu *menu, RESideMenuItem *item) {
                    secondViewController.title = item.title;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
                    [menu setRootViewController:navigationController];
                }];
            });
            dispatch_sync(mainQueue, ^{
                [myArray addObject:profileItem];
            });
        });
        
        dispatch_async(myQueue, ^{
            __block  SecondViewController *secondViewController = nil;
            __block  RESideMenuItem *logOutItem=nil;
            dispatch_sync(myQueue, ^{
                secondViewController = [[SecondViewController alloc] init];
                logOutItem = [[RESideMenuItem alloc] initWithTitle:@"注销" action:^(RESideMenu *menu, RESideMenuItem *item) {
                    UIActionSheet *alertView = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView showInView:self.view];                }];
            });
            dispatch_sync(mainQueue, ^{
                [myArray addObject:logOutItem];
            });
        });
        
        _sideMenu = [[RESideMenu alloc] initWithItems:myArray];
        //        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        //        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    }
    
    [_sideMenu show];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        QRootElement *root=[Login create];
        UINavigationController *nav=[QuickDialogController controllerWithNavigationForRoot:root];
        [self.sideMenu setRootViewController:nav];
    }
    
    
}



@end
