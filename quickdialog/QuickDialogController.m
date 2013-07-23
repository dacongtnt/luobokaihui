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
#import "LoginInfo.h"
#import "JSONKit.h"
#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "Login.h"
#import "DemoViewController.h"
#import "AudioView.h"

@interface QuickDialogController ()

+ (Class)controllerClassForRoot:(QRootElement *)root;

@end


@implementation QuickDialogController {
    BOOL _keyboardVisible;
    BOOL _viewOnScreen;
    BOOL _resizeWhenKeyboardPresented;
}

@synthesize root = _root;
@synthesize willDisappearCallback = _willDisappearCallback;
@synthesize quickDialogTableView = _quickDialogTableView;
@synthesize resizeWhenKeyboardPresented = _resizeWhenKeyboardPresented;


+ (QuickDialogController *)buildControllerWithClass:(Class)controllerClass root:(QRootElement *)root {
    controllerClass = controllerClass==nil? [QuickDialogController class] : controllerClass;
    return [((QuickDialogController *)[controllerClass alloc]) initWithRoot:root];
}

+ (QuickDialogController *)controllerForRoot:(QRootElement *)root {
    Class controllerClass = [self controllerClassForRoot:root];
    return [((QuickDialogController *)[controllerClass alloc]) initWithRoot:root];
}


+ (Class)controllerClassForRoot:(QRootElement *)root {
    Class controllerClass = nil;
    if (root.controllerName!=NULL){
        controllerClass = NSClassFromString(root.controllerName);
    } else {
        controllerClass = [self class];
    }
    return controllerClass;
}

+ (UINavigationController*)controllerWithNavigationForRoot:(QRootElement *)root {
    return [[UINavigationController alloc] initWithRootViewController:[QuickDialogController
                                                                       buildControllerWithClass:[self controllerClassForRoot:root]
                                                                       root:root]];
}

- (void)loadView {
    [super loadView];
    self.quickDialogTableView = [[QuickDialogTableView alloc] initWithController:self];
    self.view = self.quickDialogTableView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super init];
    if (self) {
        self.root = rootElement;
        self.resizeWhenKeyboardPresented =YES;
    }
    return self;
}

- (void)setRoot:(QRootElement *)root {
    _root = root;
    self.quickDialogTableView.root = root;
    self.title = _root.title;
    self.navigationItem.title = _root.title;
}

- (void)viewWillAppear:(BOOL)animated {
    _viewOnScreen = YES;
    [self.quickDialogTableView viewWillAppear];
    [super viewWillAppear:animated];
    if (_root!=nil)
        self.title = _root.title;
}

- (void)viewWillDisappear:(BOOL)animated {
    _viewOnScreen = NO;
    [super viewWillDisappear:animated];
    if (_willDisappearCallback!=nil){
        _willDisappearCallback();
    }
}

- (void)popToPreviousRootElement {
    if (self.navigationController!=nil){
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)displayViewController:(UIViewController *)newController {
    if (self.navigationController != nil ){
        [self.navigationController pushViewController:newController animated:YES];
    } else {
        [self presentModalViewController:newController animated:YES];
    }
}

- (void)displayViewControllerForRoot:(QRootElement *)root {
    QuickDialogController *newController = [self controllerForRoot: root];
    [self displayViewController:newController];
}


- (QuickDialogController *)controllerForRoot:(QRootElement *)root {
    Class controllerClass = [[self class] controllerClassForRoot:root];
    return [QuickDialogController buildControllerWithClass:controllerClass root:root];
}


- (void) resizeForKeyboard:(NSNotification*)aNotification {
    if (!_viewOnScreen)
        return;

    BOOL up = aNotification.name == UIKeyboardWillShowNotification;

    if (_keyboardVisible == up)
        return;

    _keyboardVisible = up;
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve
        animations:^{
            CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
            self.quickDialogTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0,  up ? keyboardFrame.size.height : 0, 0.0);
        }
        completion:NULL];
}

- (void)setResizeWhenKeyboardPresented:(BOOL)observesKeyboard {
  if (observesKeyboard != _resizeWhenKeyboardPresented) {
    _resizeWhenKeyboardPresented = observesKeyboard;

    if (_resizeWhenKeyboardPresented) {
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    } else {
      [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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

//这里是我自己添加的方法
- (void)onLogin:(QButtonElement *)buttonElement {
    [self loading:YES];
    LoginInfo *info = [[LoginInfo alloc] init];
    
    
    [self.root fetchValueIntoObject:info];
    
    [self performSelector:@selector(loginCompleted:) withObject:info afterDelay:2];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


@end