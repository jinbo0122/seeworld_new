
#import "WebViewController.h"
#import "SWHUD.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =  @"用户协议";
    
    [self setupWebView];
    [SWHUD showWaiting];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SWHUD hideWaiting];
    [_webView stopLoading];
}

- (void)setupWebView
{
    UIWebView *sybView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    sybView.delegate = self;
    [self.view addSubview:sybView];
    self.webView = sybView;
    self.webView.height -= 64;
}

- (void)loadWebView
{
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SWHUD hideWaiting];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   [SWHUD hideWaiting];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

/**
 *  重写父类方法 如果网页能canGoBack则GoBack不能则弹出当前控制器
 */
- (void)onNavigationLeftButtonClicked:(UIButton *)sender
{
    [SWHUD hideWaiting];
    
    if (self.webView.canGoBack) { // 如果可以返回则返回
        [self.webView goBack];
    } else {
        [self popViewController];
    }
    
}

@end
