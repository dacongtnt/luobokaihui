//                                
// Copyright 2011 ESCOZ Inc  - http://escoz.com
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "LoginController.h"
#import "LoginInfo.h"
#import "JSONKit.h"
#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "Login.h"
#import "DemoViewController.h"
#import "AudioView.h"

@interface LoginController ()
- (void)onLogin:(QButtonElement *)buttonElement;
- (void)onAbout;

@end

@implementation LoginController

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];

//    self.quickDialogTableView.backgroundColor = [UIColor colorWithHue:0.1174 saturation:0.7131 brightness:0.8618 alpha:1.0000];
    self.quickDialogTableView.separatorStyle=NO;
//    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.3542 green:0.3532 blue:0.2548 alpha:1.0000];
    self.quickDialogTableView.bounces = NO;
    self.quickDialogTableView.styleProvider = self;

    ((QEntryElement *)[self.root elementWithKey:@"login"]).delegate = self;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = nil;
}

//- (void)loginCompleted:(LoginInfo *)info {
//    [self loading:NO];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:[NSString stringWithFormat: @"Hi %@, you're loving QuickForms!", info.login] delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil];
//    [alert show];
//}


//- (void)onAbout {
//    QRootElement *details = [LoginController createDetailsForm];
//
//    QuickDialogController *quickform = [QuickDialogController controllerForRoot:details];
//    [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:quickform] animated:YES];
//}

-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];

    if ([element isKindOfClass:[QEntryElement class]] || [element isKindOfClass:[QButtonElement class]]){
//        cell.textLabel.textColor = [UIColor colorWithRed:0.6033 green:0.2323 blue:0.0000 alpha:1.0000];
         cell.textLabel.textColor = [UIColor blackColor];
    }
}

+ (QRootElement *)createDetailsForm {
    QRootElement *details = [[QRootElement alloc] init];
    details.title = @"Details";
    details.controllerName = @"AboutController";
    details.grouped = YES;
    QSection *section = [[QSection alloc] initWithTitle:@"Information"];
    [section addElement:[[QTextElement alloc] initWithText:@"Here's some more info about this app."]];
    [details addSection:section];
    return details;
}

+ (QRootElement *)createLoginForm {
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"LoginController";
    root.grouped = YES;
    root.title = @"Login";

    QSection *main = [[QSection alloc] init];
    main.headerImage = @"logo";

    QEntryElement *login = [[QEntryElement alloc] init];
    login.title = @"Username";
    login.key = @"login";
    login.hiddenToolbar = YES;
    login.placeholder = @"johndoe@me.com";
    [main addElement:login];

    QEntryElement *password = [[QEntryElement alloc] init];
    password.title = @"Password";
    password.key = @"password";
    password.secureTextEntry = YES;
    password.hiddenToolbar = YES;
    password.placeholder = @"your password";
    [main addElement:password];

    [root addSection:main];

    QSection *btSection = [[QSection alloc] init];
    QButtonElement *btLogin = [[QButtonElement alloc] init];
    btLogin.title = @"Login";
    btLogin.controllerAction = @"onLogin:";
    [btSection addElement:btLogin];

    [root addSection:btSection];

    btSection.footerImage = @"footer";

    return root;
}

//这里是我自己添加的方法
- (void)loginCompleted:(LoginInfo *)info {
    [self loading:NO];
    NSLog(@"%@,%@",info.login,info.password);
    if (([info.login isEqualToString:@""]||info.login==nil)||([info.password isEqualToString:@""]||info.password==nil)) {
        UIAlertView *WarnAlert=[[UIAlertView alloc] initWithTitle:@"Warn" message:@"用户名或密码为空" delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil, nil];
        [WarnAlert show];
        MCRelease(WarnAlert);
    }else if(info.login.length<4||info.login.length>16){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示：" message:@"账户名必须在4～16位之间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if(info.password.length<4||info.password.length>16){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示：" message:@"密码必须在4～16位之间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        //内网测试数据，为了保证程序的通用性，下面用假数据代替
        //        NSURL *pasUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.2.16:8023/MeetingSystemss/LoginMeeting?username=%@&password=%@",info.login,info.password]];
        //        ASIHTTPRequest *pasRequest = [ASIHTTPRequest requestWithURL:pasUrl];
        //        [pasRequest startSynchronous];
        //
        //        NSError *loginError = [pasRequest error];
        //        if(!loginError)
        //        {
        //            NSData *pasResponse = pasRequest.responseData;
        //            NSDictionary *pasDic = [NSJSONSerialization JSONObjectWithData:pasResponse options:kNilOptions error:nil];
        //            NSString *isYes = [pasDic objectForKey:@"flag"];
        //            if ([isYes isEqualToString:@"YES"])
        //            {
        //                NSURL *conferenceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.2.16:8023/MeetingSystemss/GetMeetingTitle?username=%@",info.login]];
        //                ASIHTTPRequest *conferenceRequest = [ASIHTTPRequest requestWithURL:conferenceUrl];
        //                [conferenceRequest startSynchronous];
        //                NSError *conferenceError = [conferenceRequest error];
        //                if (!conferenceError)
        //                {
        //                    NSData *conferenceResponse = conferenceRequest.responseData;
        //                    NSDictionary *conferenceDic = [NSJSONSerialization JSONObjectWithData:conferenceResponse options:kNilOptions error:nil];
        //                    NSArray *startArr = [conferenceDic objectForKey:@"start"];
        //                    NSArray *endArr = [conferenceDic objectForKey:@"end"];
        //                    NSMutableArray *startName = [[NSMutableArray alloc] initWithCapacity:0];
        //                    NSMutableArray *endName = [[NSMutableArray alloc] initWithCapacity:0];
        //                    for (int i = 0; i < startArr.count; i++) {
        //                        [startName addObject:[[startArr objectAtIndex:i] objectForKey:@"Conference_title"]];
        //                    }
        //                    for (int i = 0; i < endArr.count; i++) {
        //                        [endName addObject:[[endArr objectAtIndex:i] objectForKey:@"Conference_title"]];
        //                    }
        //                    ViewController *regist = [[ViewController alloc] init];
        //                    [self.navigationController pushViewController:regist animated:YES];
        //                }
        //                else
        //                {
        //                    NSLog(@"%@",conferenceError);
        //                }
        //            }
        
        
        
        NSString *yonghuxinxi=@"{\"mahailong\":\"sunao\",\"majian\":\"sunao\",\"zhangjian\":\"sunao\",\"zhangwei\":\"sunao\",\"liuqingxuan\":\"sunao\"}";
        NSData *data=[yonghuxinxi dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=[data objectFromJSONData];
        
        NSString *strPass=[dic objectForKey:info.login];
        NSLog(@"%@",strPass);
        NSLog(@"%@",dic);
        
        if (strPass==nil||[strPass isEqualToString:@""]) {
            UIAlertView *WarnAlertb=[[UIAlertView alloc] initWithTitle:@"Warn" message:@"用户名不存在" delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil, nil];
            [WarnAlertb show];
            MCRelease(WarnAlertb);
        }else{
            if([strPass  isEqualToString:info.password]){
                
                //            QRootElement *root=[Login createMainFrom];
                //            ViewController *view=[[ViewController alloc] initWithRoot:root];
                
                AudioView *view=[[AudioView alloc] init];
                
                [self.navigationController pushViewController:view animated:YES];
                MCRelease(view);
            }else {
                UIAlertView *WarnAlertb=[[UIAlertView alloc] initWithTitle:@"Warn" message:@"密码错误" delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil, nil];
                [WarnAlertb show];
                MCRelease(WarnAlertb);
            }
        }
    }
}

//-(void)requestFinished:(ASIHTTPRequest*)request
//{
//    NSData *pasResponse = request.responseData;
//
//    NSLog(@"sss is %@",pasResponse);
//    NSDictionary *pasDic =[pasResponse objectFromJSONData];
//    NSLog(@"sss is %@",pasDic);
//
//
//}

//这里是我自己添加的方法
- (void)onLogin:(QButtonElement *)buttonElement {
    [self loading:YES];
    LoginInfo *info = [[LoginInfo alloc] init];
    
    [self.root fetchValueIntoObject:info];
    
    [self performSelector:@selector(loginCompleted:) withObject:info afterDelay:2];
}


- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Editing changed");
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");

}


@end