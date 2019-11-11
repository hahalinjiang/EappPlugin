//
//  newCordovaFrameViewController.h
//  YTH
//
//  Created by gu yong on 2019/9/5.
//

#import <UIKit/UIKit.h>
#import "Cordova/CDVViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface newCordovaFrameViewController : CDVViewController{
    
}

@property(nonatomic,retain) NSString* m_Url;
@property(nonatomic,assign) NSString* m_enterEffect;     // 0 右push进来  1下推上来
@property(nonatomic,assign) NSString* m_isSubView;       // 是否是子页面
- (NSURL*)appUrl;
-(void)controllerinit:(NSString*)url enterEffect:(NSString*)effect;
-(id)initObject:(id)sender;
+(newCordovaFrameViewController*)shareController;
-(void)PushNewViewController:(UIViewController*) control;
-(void)Back;
@end

NS_ASSUME_NONNULL_END
