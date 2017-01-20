//
//  OauthViewController.m
//  项目之微博
//
//  Created by 肖晨 on 15/8/1.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "OauthViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "AccountTool.h"


@interface OauthViewController() <UIWebViewDelegate>


@end

@implementation OauthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.frame;
    webView.delegate = self;
    
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=3511881839&redirect_uri=http://www.weibo.com"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载..."];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        int fromIndex = (int)(range.location + range.length);
        NSString *code = [url substringFromIndex:fromIndex];
        
        [self accessTokenWithCode:code];
        
        // 不加载回调地址
        return NO;
        
    }
    return  YES;
}

/**
 *  利用code（授权成功后的request token）换取一个accessToken
 */
- (void)accessTokenWithCode:(NSString *)code
{
    // 1. 请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    // 2. 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"3511881839";
    params[@"client_secret"] = @"f6917e427a87143f84c90abbd34d05d7";
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = @"http://www.weibo.com";
    
    // 3. 发送请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD hideHUD];
        
        Account *account =[Account initWithDict:responseObject];
        [AccountTool saveAccount:account];
//        [responseObject writeToFile:account atomically:YES];  // 字典写入沙盒
        
        // 切换窗口的根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        
        [MBProgressHUD hideHUD];
    }];

}

@end
