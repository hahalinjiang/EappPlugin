//
//  newCordovaFrameViewController.m
//  YTH
//
//  Created by gu yong on 2019/9/5.
//

#import "newCordovaFrameViewController.h"
#import "AppDelegate.h"
#import "CDVSplashScreen.h"

@interface newCordovaFrameViewController ()

@end

@implementation newCordovaFrameViewController

static newCordovaFrameViewController* gl_control=nil;
+(newCordovaFrameViewController*)shareController{
    if (gl_control == nil) {
        newCordovaFrameViewController* newController = [[newCordovaFrameViewController alloc]init];
        gl_control = newController;
    }
    return gl_control;
}
-(id)initObject:(id)sender{
    newCordovaFrameViewController* newController = [[newCordovaFrameViewController alloc]init];
    gl_control = newController;
    return newController;
}

-(void)controllerinit:(NSString*)url enterEffect:(NSString*)effect{
    self.m_Url = url;
    self.m_enterEffect = effect;
    
    [self PushNewViewController:self];
}

- (NSURL*)appUrl
{
    NSURL* url = [NSURL URLWithString:self.m_Url];
    return url;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.m_isSubView = @"0";

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.m_isSubView = @"1";
}
-(void)PushNewViewController:(UIViewController*) control{
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(![self.m_enterEffect isEqualToString:@"1"])  //右推
    {
        [delegate.viewController.navigationController pushViewController:control animated:YES];
    }else {
        [delegate.viewController presentViewController:control animated:YES completion:^{
        }];
        
    }
    self.m_isSubView = @"1";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CDVSplashScreen* plugin = (CDVSplashScreen*)[self.commandDelegate getCommandInstance:@"SplashScreen"];
    [plugin hide:nil];
    
    
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.m_Url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    UIWebView* webView = (UIWebView*)self.webViewEngine.engineWebView;
    if ([webView isLoading]) {
        [webView stopLoading];
    }
    [webView loadRequest:request];
    self.view.backgroundColor = [UIColor whiteColor];
    
//     [self initTitle];
    // Do any additional setup after loading the view.
}

-(void)initTitle{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIView* g_view = [[UIView alloc]initWithFrame:CGRectMake(0,0,size.width,60)];
    g_view.backgroundColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:0.5];
    [self.view addSubview:g_view];
    
    UILabel* g_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, size.width, 40)];
    g_label.backgroundColor = [UIColor clearColor];
    g_label.textColor = [UIColor blackColor];
    g_label.text = @"EAPP";
    g_label.textAlignment = NSTextAlignmentCenter;
    g_label.font = [UIFont systemFontOfSize:14];
    [g_view addSubview:g_label];
    
    UIButton* g_button = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 60, 30)];
    g_button.backgroundColor = [UIColor clearColor];
    [g_button setTitle:@"返回" forState:UIControlStateNormal];
    g_button.titleLabel.font = [UIFont systemFontOfSize:14];
    [g_button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [g_button addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    [g_view addSubview:g_button];
    g_button.layer.masksToBounds = YES;
    g_button.layer.cornerRadius = 5;
    g_button.layer.borderColor = [UIColor orangeColor].CGColor;
    g_button.layer.borderWidth = 1;
    
}
-(void)Back
{
  
    if(![self.m_enterEffect isEqualToString:@"1"])  //右推
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
   self.m_isSubView = @"0";
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
