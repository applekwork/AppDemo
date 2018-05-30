    //
    //  XNWebVC.m
    //  XNManager
    //
    //  Created by Carlson Lee on 2017/5/9.
    //  Copyright © 2017年 Carlson Lee. All rights reserved.
    //

#import "XNWebVC.h"
#import "UIWebView+Bridge.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface XNWebVC ()<UIWebViewDelegate, NSURLConnectionDelegate>{
    NSString* _baseUrl;
    NSDate* _fDate;
    BOOL _authenticated;//是否ATS认证
    NSURLRequest *_originRequest;
    
    void(^_block)(NSTimeInterval t);
}

@property(nonatomic, strong) UIWebView* webView;

@property(nonatomic,assign) BOOL needLoadJSPOST;
    //返回按钮
@property (nonatomic) UIBarButtonItem* customBackBarItem;
    //关闭按钮
@property (nonatomic) UIBarButtonItem* closeButtonItem;

@property (nonatomic, copy) NSString* loadJs;

@end

@implementation XNWebVC


- (instancetype)initWithUrl:(NSString* )urlStr
{
    if(self = [super init]){
        _urlStr = urlStr;
        _tStr = @"";
    }
    return self;
}

- (instancetype)initWithUrl:(NSString* )urlStr title:(NSString* )title
{
    if(self = [super init]){
        _urlStr = urlStr;
        _tStr = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    if(_tStr){
        self.title = _tStr;
    }
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _baseUrl = _urlStr;
    
#ifndef __IPHONE_10_1
    if([_urlStr containsString:@"xnsudai.com"] && [_urlStr hasPrefix:@"https"]){
        _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    }
#endif
//    //所有链接添加accountId
//    if([_urlStr containsString:@"xnsudai.com"]){
//        if(![_urlStr containsString:@"accountId"]){
//            if([_urlStr containsString:@"?"]){
//                _urlStr = [_urlStr stringByAppendingFormat:@"&accountId=%@", _CustomerInfo.accountId];
//            }else{
//                _urlStr = [_urlStr stringByAppendingFormat:@"?accountId=%@", _CustomerInfo.accountId];
//            }
//        }
//        if(_activityId && ![_urlStr containsString:@"activityId"]){
//            _urlStr = [_urlStr stringByAppendingFormat:@"&activityId=%@", _activityId];
//        }
//    }
//
//    NSString* encodedString = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
//    [self.webView loadRequest:request];
//}
//
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if(_CustomerInfo.token && ![_CustomerInfo.token isEqualToString:@""]){
//        if(_activityId){//针对活动
//            _urlStr = [NSString stringWithFormat:@"%@?accountId=%@&activityId=%@", _baseUrl, _CustomerInfo.accountId, _activityId];
//
//            [self refresh];
//        }
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)injectionJS:(NSString* )js
{
    _loadJs = js;
}


#pragma mark----------webViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    _originRequest = request;
    NSURL* url = request.URL;
//    NSString *schema = [[url scheme] lowercaseString];
    if([url.absoluteString hasSuffix:@"apk"]){
        return NO;
    }
    /*
    if([schema isEqualToString:@"https"]){
        if(!_authenticated){
            _originRequest = request;
            [[[NSURLConnection alloc] initWithRequest:request delegate:self] start];
            return NO;
        }
    }
    */
    return [webView dispatchURL:request.URL] == NO;;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateNavigationItems];
    [self showLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self cancelLoad];
    
    if(self.title.length == 0){
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    if(_loadJs){
        [self.webView stringByEvaluatingJavaScriptFromString:_loadJs];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	 [self cancelLoad];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{

     NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
     if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
         SecTrustRef trust = challenge.protectionSpace.serverTrust;
         SecTrustResultType result;
         OSStatus err = SecTrustEvaluate(trust, &result);
         if(err == errSecSuccess && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)){
             NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
             [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
         }else{//ATS认证失败
             NSString *fpath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
             NSData * cerData = [NSData dataWithContentsOfFile:fpath];
             SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
             SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)@[CFBridgingRelease(certificate)]);
             err = SecTrustEvaluate(trust, &result);
                 if(err == errSecSuccess && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)){
                     NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
                     [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
                 }else{
                     [challenge.sender cancelAuthenticationChallenge:challenge];
                 }
         }
         }else{
             [challenge.sender cancelAuthenticationChallenge:challenge];
     }
     [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)pResponse
{
    _authenticated = YES;
    [connection cancel];
    [self.webView loadRequest:_originRequest];
}

-(void)customBackItemClicked{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        if(_block)_block([[NSDate date] timeIntervalSinceDate:_fDate]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)closeItemClicked
{
    if(_block)_block([[NSDate date] timeIntervalSinceDate:_fDate]);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateNavigationItems
{
    if (self.webView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem] animated:NO];
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
    }
}

- (UIWebView *)webView
{
    if(!_webView){
        _webView = [[UIWebView alloc]init];
        [self.view addSubview:_webView];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

-(UIBarButtonItem*)customBackBarItem
{
    if (!_customBackBarItem) {
        UIImage* backItemImage = [UIImage imageNamed:@"user_back"];
        
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [backButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton sizeToFit];
        [backButton setAdjustsImageWhenHighlighted:NO];
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}

-(UIBarButtonItem*)closeButtonItem
{
    if (!_closeButtonItem) {
        UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [closeButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [closeButton sizeToFit];
        [closeButton addTarget:self action:@selector(closeItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _closeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    }
    return _closeButtonItem;
}

- (void)countTimeWithblock:(void(^)(NSTimeInterval t))block
{
    _fDate = [NSDate date];
    _block = block;
}

- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
}

- (void)setTStr:(NSString *)tStr
{
    _tStr = tStr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新
- (void)refresh
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

