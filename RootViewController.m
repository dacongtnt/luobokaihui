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
        RESideMenuItem *homeItem = [[RESideMenuItem alloc] initWithTitle:@"音乐播放器" action:^(RESideMenu *menu, RESideMenuItem *item) {
            DemoViewController *viewController = [[DemoViewController alloc] init];
            viewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem *exploreItem = [[RESideMenuItem alloc] initWithTitle:@"音乐下载" action:^(RESideMenu *menu, RESideMenuItem *item) {
            SecondViewController *secondViewController = [[SecondViewController alloc] init];
            secondViewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem *activityItem = [[RESideMenuItem alloc] initWithTitle:@"录音" action:^(RESideMenu *menu, RESideMenuItem *item) {
            SecondViewController *secondViewController = [[SecondViewController alloc] init];
            secondViewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            [menu setRootViewController:navigationController];
            NSLog(@"Item %@", item);
        }];
        RESideMenuItem *profileItem = [[RESideMenuItem alloc] initWithTitle:@"关于我们" action:^(RESideMenu *menu, RESideMenuItem *item) {
            SecondViewController *secondViewController = [[SecondViewController alloc] init];
            secondViewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            [menu setRootViewController:navigationController];
            NSLog(@"Item %@", item);
        }];
//        RESideMenuItem *aroundMeItem = [[RESideMenuItem alloc] initWithTitle:@"Around Me" action:^(RESideMenu *menu, RESideMenuItem *item) {
//            [menu hide];
//            NSLog(@"Item %@", item);
//        }];
//        
//        RESideMenuItem *helpPlus1 = [[RESideMenuItem alloc] initWithTitle:@"How to use" action:^(RESideMenu *menu, RESideMenuItem *item) {
//            NSLog(@"Item %@", item);
//            [menu hide];
//        }];
//        
//        RESideMenuItem *helpPlus2 = [[RESideMenuItem alloc] initWithTitle:@"Helpdesk" action:^(RESideMenu *menu, RESideMenuItem *item) {
//            NSLog(@"Item %@", item);
//            [menu hide];
//        }];
//        
//        RESideMenuItem *helpCenterItem = [[RESideMenuItem alloc] initWithTitle:@"Help +" action:^(RESideMenu *menu, RESideMenuItem *item) {
//            NSLog(@"Item %@", item);
//        }];
//        helpCenterItem.subItems  = @[helpPlus1,helpPlus2];
//        
//        RESideMenuItem *itemWithSubItems = [[RESideMenuItem alloc] initWithTitle:@"Sub items +" action:^(RESideMenu *menu, RESideMenuItem *item) {
//            NSLog(@"Item %@", item);
//        }];
//        itemWithSubItems.subItems = @[aroundMeItem,helpCenterItem];
        
        RESideMenuItem *logOutItem = [[RESideMenuItem alloc] initWithTitle:@"注销" action:^(RESideMenu *menu, RESideMenuItem *item) {
            UIActionSheet *alertView = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView showInView:self.view];

        }];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem, logOutItem]];
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
