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
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:appHtml baseURL:baseURL];
   
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([data[@"login"] integerValue] == 1) {
            LoginViewController *a = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"a"];
            a.delegate = self;
            [self.navigationController pushViewController:a animated:YES];
        }
        
        
        responseCallback([NSString stringWithFormat:@"收到JS的消息%@",data]);
    }];
    
    
    
}

- (void)loginSuccess:(NSString *)userName password:(NSString *)password{
    
    
    //[_bridge callHandler:@"testJavascriptHandler" data:@{@"username":userName,@"password":password}];
    [_bridge callHandler:@"testJavascriptHandler" data:@{@"username":userName,@"password":password} responseCallback:^(id responseData) {
        NSLog(@"%@",[responseData description]);
    }];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
