//
//  Login.h
//  myquick
//
//  Created by 赵云 on 13-7-19.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

@class QRootElement;

@interface Login : QuickDialogController<QuickDialogEntryElementDelegate>

+ (QRootElement *)create;
+ (QRootElement *)createMainFrom;
@end
