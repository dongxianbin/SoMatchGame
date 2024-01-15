/****************************************************************************
 Copyright (c) 2014-2016 Chukong Technologies Inc.
 Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import <WebKit/WebKit.h>
#include "platform/CCPlatformConfig.h"

// Webview not available on tvOS
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) && !defined(CC_TARGET_OS_TVOS)

#include "ui/UIWebViewImpl-ios.h"
#include "renderer/CCRenderer.h"
#include "base/CCDirector.h"
#include "platform/CCGLView.h"
#include "platform/ios/CCEAGLView-ios.h"
#include "platform/CCFileUtils.h"
#include "ui/UIWebView.h"

static std::string getFixedBaseUrl(const std::string& baseUrl)
{
    std::string fixedBaseUrl;
    if (baseUrl.empty() || baseUrl.at(0) != '/') {
        fixedBaseUrl = [[[NSBundle mainBundle] resourcePath] UTF8String];
        fixedBaseUrl += "/";
        fixedBaseUrl += baseUrl;
    }
    else {
        fixedBaseUrl = baseUrl;
    }
    
    size_t pos = 0;
    while ((pos = fixedBaseUrl.find(" ")) != std::string::npos) {
        fixedBaseUrl.replace(pos, 1, "%20");
    }
    
    if (fixedBaseUrl.at(fixedBaseUrl.length() - 1) != '/') {
        fixedBaseUrl += "/";
    }
    
    return fixedBaseUrl;
}

@interface UIWebViewWrapper : NSObject
@property (nonatomic) std::function<bool(std::string url)> shouldStartLoading;
@property (nonatomic) std::function<void(std::string url)> didFinishLoading;
@property (nonatomic) std::function<void(std::string url)> didFailLoading;
@property (nonatomic) std::function<void(std::string url)> onJsCallback;
@property (nonatomic) std::function<void(std::string url)> getJSCallback;

@property(nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
@property(nonatomic, readonly, getter=canGoForward) BOOL canGoForward;

+ (instancetype)newWebViewWrapper;

- (void)setVisible:(bool)visible;

- (void)setBounces:(bool)bounces;

- (void)setOpacityWebView:(float)opacity;

- (float)getOpacityWebView;

- (void)setBackgroundTransparent;

- (void)setFrameWithX:(float)x y:(float)y width:(float)width height:(float)height;

- (void)setJavascriptInterfaceScheme:(const std::string &)scheme;

- (void)setJavascripMethodName:(const std::string &)name;

- (void)loadData:(const std::string &)data MIMEType:(const std::string &)MIMEType textEncodingName:(const std::string &)encodingName baseURL:(const std::string &)baseURL;

- (void)loadHTMLString:(const std::string &)string baseURL:(const std::string &)baseURL;

- (void)loadUrl:(const std::string &)urlString cleanCachedData:(BOOL) needCleanCachedData;

- (void)loadFile:(const std::string &)filePath;

- (void)stopLoading;

- (void)reload;

- (void)evaluateJS:(const std::string &)js;

- (void)goBack;

- (void)goForward;

- (void)setScalesPageToFit:(const bool)scalesPageToFit;
@end


@interface UIWebViewWrapper () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property(nonatomic, retain) WKWebView *wkWebView;
@property(nonatomic, copy) NSString *jsScheme;
@property(nonatomic, copy) NSString *jsName;
@end

@implementation UIWebViewWrapper {
    
}

+ (instancetype) newWebViewWrapper {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.wkWebView = nil;
        self.wkWebView.UIDelegate = nil;
        self.wkWebView.navigationDelegate = nil;
        self.shouldStartLoading = nullptr;
        self.didFinishLoading = nullptr;
        self.didFailLoading = nullptr;
    }
    return self;
}

- (void)dealloc {
    self.wkWebView.UIDelegate = nil;
    self.wkWebView.navigationDelegate = nil;
    [self.wkWebView removeFromSuperview];
    [self.wkWebView release];
    self.wkWebView = nil;
    self.jsScheme = nil;
    [super dealloc];
}

- (void)setupWebView {
    if (!self.wkWebView) {
        self.wkWebView = [[WKWebView alloc] init];
        self.wkWebView.UIDelegate = self;
        self.wkWebView.navigationDelegate = self;
        
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        WKUserContentController *userContent = [[WKUserContentController alloc] init];
//        NSString *jsCode = [NSString stringWithFormat:@"window.jsBridge = {\n    postMessage: function(name, data) {\n        window.webkit.messageHandlers.Post.postMessage({name, data})\n    }\n};\n"];
//        WKUserScript *zuowan = [[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//        [userContent addUserScript:zuowan];
//        [userContent addScriptMessageHandler:self name:@"Post"];
//        config.userContentController = userContent;
//
//        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:config];
//        self.wkWebView.navigationDelegate = self;
//        self.wkWebView.UIDelegate = self;

        if (@available(iOS 11.0, *)) {
            // 适配iOS 11及以上版本
            self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); // 底部空白区域的高度根据实际情况进行调
        }
    }
    if (!self.wkWebView.superview) {
        auto view = cocos2d::Director::getInstance()->getOpenGLView();
        auto eaglview = (CCEAGLView *) view->getEAGLView();
        [eaglview addSubview:self.wkWebView];
    }
}

- (void)setVisible:(bool)visible {
    if (!self.wkWebView) {[self setupWebView];}
    self.wkWebView.hidden = !visible;
}

- (void)setBounces:(bool)bounces {
  self.wkWebView.scrollView.bounces = bounces;
}

- (void)setOpacityWebView:(float)opacity {
    if (!self.wkWebView) {[self setupWebView];}
    self.wkWebView.alpha=opacity;
    [self.wkWebView setOpaque:NO];
}

-(float) getOpacityWebView{
    return self.wkWebView.alpha;
}

-(void) setBackgroundTransparent{
    if (!self.wkWebView) {[self setupWebView];}
    [self.wkWebView setOpaque:NO];
    [self.wkWebView setBackgroundColor:[UIColor clearColor]];
}

- (void)setFrameWithX:(float)x y:(float)y width:(float)width height:(float)height {
    if (!self.wkWebView) {[self setupWebView];}
    CGRect newFrame = CGRectMake(x, y, width, height);
    if (!CGRectEqualToRect(self.wkWebView.frame, newFrame)) {
        self.wkWebView.frame = CGRectMake(x, y, width, height);
    }
}

- (void)setJavascripMethodName:(const std::string &)name {
    self.jsName = @(name.c_str());
    [self.wkWebView release];
    self.wkWebView = nil;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContent = [[WKUserContentController alloc] init];
    NSString *jsCode = [NSString stringWithFormat:@"window.jsBridge = {\n    postMessage: function(name, data) {\n        window.webkit.messageHandlers.%@.postMessage({name, data})\n    }\n};\n", self.jsName];
    WKUserScript *zuowan = [[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContent addUserScript:zuowan];
    [userContent addScriptMessageHandler:self name:self.jsName];
    config.userContentController = userContent;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:config];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    
    if (@available(iOS 11.0, *)) {
        // 适配iOS 11及以上版本
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); // 底部空白区域的高度根据实际情况进行调
    }
    
    auto view = cocos2d::Director::getInstance()->getOpenGLView();
    auto eaglview = (CCEAGLView *) view->getEAGLView();
    [eaglview addSubview:self.wkWebView];
}

- (void)setJavascriptInterfaceScheme:(const std::string &)scheme {
    self.jsScheme = @(scheme.c_str());
}

- (void)loadData:(const std::string &)data MIMEType:(const std::string &)MIMEType textEncodingName:(const std::string &)encodingName baseURL:(const std::string &)baseURL {
    [self.wkWebView loadData:[NSData dataWithBytes:data.c_str() length:data.length()]
                    MIMEType:@(MIMEType.c_str())
            characterEncodingName:@(encodingName.c_str())
                     baseURL:[NSURL URLWithString:@(getFixedBaseUrl(baseURL).c_str())]];
}

- (void)loadHTMLString:(const std::string &)string baseURL:(const std::string &)baseURL {
    if (!self.wkWebView) {[self setupWebView];}
    [self.wkWebView loadHTMLString:@(string.c_str()) baseURL:[NSURL URLWithString:@(getFixedBaseUrl(baseURL).c_str())]];
}

- (void)loadUrl:(const std::string &)urlString cleanCachedData:(BOOL) needCleanCachedData {
    if (!self.wkWebView) {[self setupWebView];}
    NSURL *url = [NSURL URLWithString:@(urlString.c_str())];

    NSURLRequest *request = nil;
    if (needCleanCachedData)
        request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    else
        request = [NSURLRequest requestWithURL:url];

    [self.wkWebView loadRequest:request];
}



- (void)loadFile:(const std::string &)filePath {
    if (!self.wkWebView) {[self setupWebView];}
    NSURL *url = [NSURL fileURLWithPath:@(filePath.c_str())];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
}

- (void)stopLoading {
    [self.wkWebView stopLoading];
}

- (void)reload {
    [self.wkWebView reload];
}

- (BOOL)canGoForward {
    return self.wkWebView.canGoForward;
}

- (BOOL)canGoBack {
    return self.wkWebView.canGoBack;
}

- (void)goBack {
    [self.wkWebView goBack];
}

- (void)goForward {
    [self.wkWebView goForward];
}

- (void)evaluateJS:(const std::string &)js {
    if (!self.wkWebView) {[self setupWebView];}
    [self.wkWebView evaluateJavaScript:@(js.c_str()) completionHandler:nil];
}

- (void)setScalesPageToFit:(const bool)scalesPageToFit {
//    if (!self.uiWebView) {[self setupWebView];}
//    self.uiWebView.scalesPageToFit = scalesPageToFit;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = [[[navigationAction request] URL] absoluteString];
    if ([[webView.URL scheme] isEqualToString:self.jsScheme]) {
        self.onJsCallback([url UTF8String]);
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (self.shouldStartLoading && url) {
        if (self.shouldStartLoading([url UTF8String]) )
            decisionHandler(WKNavigationActionPolicyAllow);
        else
            decisionHandler(WKNavigationActionPolicyCancel);

        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.didFinishLoading) {
        NSString *url = [webView.URL absoluteString];
        self.didFinishLoading([url UTF8String]);
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.didFailLoading) {
        NSString *errorInfo = error.userInfo[NSURLErrorFailingURLStringErrorKey];
        if (errorInfo) {
            self.didFailLoading([errorInfo UTF8String]);
        }
    }
}

#pragma WKUIDelegate

// Implement js alert function.
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];

    auto rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    NSLog(@"message.name:%@", message.name);
//    NSLog(@"message.body:%@", message.body);
    if ([message.name isEqualToString:self.jsName]) {
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            NSDictionary *body = (NSDictionary *)message.body;
            NSString *name = [body objectForKey:@"name"];
            if ([name isEqualToString:@"OpenUrl"]) {
                NSDictionary *data = [body objectForKey:@"data"];
                NSString *url = [data objectForKey:@"url"];
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                   // NSLog(@"success");
               }];
            } else {
                NSError* error;
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
                NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                // 将NSString转换为C++字符串
                std::string cppString = [jsonString UTF8String];
                self.getJSCallback(cppString);
            }
        }
    }
}

//#pragma mark - UIWebViewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSString *url = [[request URL] absoluteString];
//    if ([[[request URL] scheme] isEqualToString:self.jsScheme]) {
//        self.onJsCallback([url UTF8String]);
//        return NO;
//    }
//    if (self.shouldStartLoading && url) {
//        return self.shouldStartLoading([url UTF8String]);
//    }
//    return YES;
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    if (self.didFinishLoading) {
//        NSString *url = [[webView.request URL] absoluteString];
//        self.didFinishLoading([url UTF8String]);
//    }
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    if (self.didFailLoading) {
//        NSString *url = error.userInfo[NSURLErrorFailingURLStringErrorKey];
//        if (url) {
//            self.didFailLoading([url UTF8String]);
//        }
//    }
//}

@end



namespace cocos2d {
namespace experimental {
    namespace ui{

WebViewImpl::WebViewImpl(WebView *webView)
        : _uiWebViewWrapper([UIWebViewWrapper newWebViewWrapper]),
        _webView(webView) {
            
    _uiWebViewWrapper.shouldStartLoading = [this](std::string url) {
        if (this->_webView->_onShouldStartLoading) {
            return this->_webView->_onShouldStartLoading(this->_webView, url);
        }
        return true;
    };
    _uiWebViewWrapper.didFinishLoading = [this](std::string url) {
        if (this->_webView->_onDidFinishLoading) {
            this->_webView->_onDidFinishLoading(this->_webView, url);
        }
    };
    _uiWebViewWrapper.didFailLoading = [this](std::string url) {
        if (this->_webView->_onDidFailLoading) {
            this->_webView->_onDidFailLoading(this->_webView, url);
        }
    };
    _uiWebViewWrapper.onJsCallback = [this](std::string url) {
        if (this->_webView->_onJSCallback) {
            this->_webView->_onJSCallback(this->_webView, url);
        }
    };
    _uiWebViewWrapper.getJSCallback = [this](std::string url) {
        if (this->_webView->_getJSCallback) {
            this->_webView->_getJSCallback(this->_webView, url);
        }
    };
}

WebViewImpl::~WebViewImpl(){
    [_uiWebViewWrapper release];
    _uiWebViewWrapper = nullptr;
}

void WebViewImpl::setJavascriptInterfaceScheme(const std::string &scheme) {
    [_uiWebViewWrapper setJavascriptInterfaceScheme:scheme];
}
    
void WebViewImpl::setJavascripMethodName(const std::string &name) {
    [_uiWebViewWrapper setJavascripMethodName:name];
}

void WebViewImpl::loadData(const Data &data,
                           const std::string &MIMEType,
                           const std::string &encoding,
                           const std::string &baseURL) {
    
    std::string dataString(reinterpret_cast<char *>(data.getBytes()), static_cast<unsigned int>(data.getSize()));
    [_uiWebViewWrapper loadData:dataString MIMEType:MIMEType textEncodingName:encoding baseURL:baseURL];
}

void WebViewImpl::loadHTMLString(const std::string &string, const std::string &baseURL) {
    [_uiWebViewWrapper loadHTMLString:string baseURL:baseURL];
}

void WebViewImpl::loadURL(const std::string &url) {
    this->loadURL(url, false);
}

void WebViewImpl::loadURL(const std::string &url, bool cleanCachedData) {
    [_uiWebViewWrapper loadUrl:url cleanCachedData:cleanCachedData];
}

void WebViewImpl::loadFile(const std::string &fileName) {
    auto fullPath = cocos2d::FileUtils::getInstance()->fullPathForFilename(fileName);
    [_uiWebViewWrapper loadFile:fullPath];
}

void WebViewImpl::stopLoading() {
    [_uiWebViewWrapper stopLoading];
}

void WebViewImpl::reload() {
    [_uiWebViewWrapper reload];
}

bool WebViewImpl::canGoBack() {
    return _uiWebViewWrapper.canGoBack;
}

bool WebViewImpl::canGoForward() {
    return _uiWebViewWrapper.canGoForward;
}

void WebViewImpl::goBack() {
    [_uiWebViewWrapper goBack];
}

void WebViewImpl::goForward() {
    [_uiWebViewWrapper goForward];
}

void WebViewImpl::evaluateJS(const std::string &js) {
    [_uiWebViewWrapper evaluateJS:js];
}

void WebViewImpl::setBounces(bool bounces) {
    [_uiWebViewWrapper setBounces:bounces];
}

void WebViewImpl::setScalesPageToFit(const bool scalesPageToFit) {
    [_uiWebViewWrapper setScalesPageToFit:scalesPageToFit];
}

void WebViewImpl::draw(cocos2d::Renderer *renderer, cocos2d::Mat4 const &transform, uint32_t flags) {
    if (flags & cocos2d::Node::FLAGS_TRANSFORM_DIRTY) {
        
        auto director = cocos2d::Director::getInstance();
        auto glView = director->getOpenGLView();
        auto frameSize = glView->getFrameSize();
        
        auto scaleFactor = [static_cast<CCEAGLView *>(glView->getEAGLView()) contentScaleFactor];

        auto winSize = director->getWinSize();

        auto leftBottom = this->_webView->convertToWorldSpace(cocos2d::Vec2::ZERO);
        auto rightTop = this->_webView->convertToWorldSpace(cocos2d::Vec2(this->_webView->getContentSize().width, this->_webView->getContentSize().height));

        auto x = (frameSize.width / 2 + (leftBottom.x - winSize.width / 2) * glView->getScaleX()) / scaleFactor;
        auto y = (frameSize.height / 2 - (rightTop.y - winSize.height / 2) * glView->getScaleY()) / scaleFactor;
        auto width = (rightTop.x - leftBottom.x) * glView->getScaleX() / scaleFactor;
        auto height = (rightTop.y - leftBottom.y) * glView->getScaleY() / scaleFactor;

        [_uiWebViewWrapper setFrameWithX:x
                                      y:y
                                  width:width
                                 height:height];
    }
}

void WebViewImpl::setVisible(bool visible){
    [_uiWebViewWrapper setVisible:visible];
}
        
void WebViewImpl::setOpacityWebView(float opacity){
    [_uiWebViewWrapper setOpacityWebView: opacity];
}
        
float WebViewImpl::getOpacityWebView() const{
    return [_uiWebViewWrapper getOpacityWebView];
}

void WebViewImpl::setBackgroundTransparent(){
    [_uiWebViewWrapper setBackgroundTransparent];
}

        
    } // namespace ui
} // namespace experimental
} //namespace cocos2d

#endif // CC_TARGET_PLATFORM == CC_PLATFORM_IOS
