//
//  AViewController.h
//  WebViewVsJS
//
//  Created by miss on 16/1/18.
//  Copyright © 2016年 mukr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (nonatomic, assign) id delegate;

@end

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginSuccess:(NSString *)userName password:(NSString *)password;

@end