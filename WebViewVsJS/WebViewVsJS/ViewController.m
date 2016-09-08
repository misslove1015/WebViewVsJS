//
//  ViewController.m
//  WebViewVsJS
//
//  Created by miss on 16/1/18.
//  Copyright © 2016年 mukr. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "WebViewJavascriptBridge.h"
@interface ViewController ()<LoginViewControllerDelegate>
@property WebViewJavascriptBridge* bridge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载HTML
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:appHtml baseURL:baseURL];
   
    //打开调试开关
    [WebViewJavascriptBridge enableLogging];
    //建立WebView和H5的连接
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    //设置代理
    [_bridge setWebViewDelegate:self];
    
    //注册以接收数据
    [_bridge registerHandler:@"needLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"JS发来的消息：%@",data);
        if ([data[@"login"] integerValue] == 1) {
            LoginViewController *a = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"a"];
            a.delegate = self;
            [self.navigationController pushViewController:a animated:YES];
        }
        responseCallback([NSString stringWithFormat:@"收到JS的消息%@",data]);
    }];
    
}

- (void)loginSuccess:(NSString *)userName password:(NSString *)password{
    
    [_bridge callHandler:@"loginSuccess" data:@{@"username":userName,@"password":password} responseCallback:^(id responseData) {
        NSLog(@"%@",responseData);
    }];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
