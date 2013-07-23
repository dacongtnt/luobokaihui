
//************
//整个软件的APPDelegate
//***********
#define APPDELEGETE (HayateAppDelegate *)[[UIApplication sharedApplication]delegate]



//*************
//**百度的API
//*************
//请求百度音乐下载地址的API，好像不是百度官方的
#define BAIDUMUSIC_API(MUSICNAME) [[NSString stringWithFormat:@"http://box.zhangmen.baidu.com/x?op=12&count=1&title=%@$$$$$$",MUSICNAME] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]