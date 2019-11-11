//
//  webFramePlugin.m
//  YTH
//
//  Created by gu yong on 2019/9/5.
//

#import "webFramePlugin.h"
#import "AppDelegate.h"
#import "PDCameraScanViewController.h"

@implementation webFramePlugin

-(void)openNewView:(CDVInvokedUrlCommand*)command{
   
    [self.commandDelegate runInBackground:^{
        // 这里是实现
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* parameter1 = nil;
            NSString* parameter2 = nil;
            if ([command.arguments count]>1) {
                parameter1=[command.arguments objectAtIndex:1];
                parameter2=[command.arguments objectAtIndex:0];
            }
            CDVPluginResult*pluginResult =nil;
            NSString*callbackidStr=  command.callbackId;
            
            if ([[newCordovaFrameViewController shareController].m_isSubView isEqualToString:@"1"]) {
                pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"当前页面进入新页面，返进入失败！"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
                return ;
            }
            
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"成功"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
            newCordovaFrameViewController* cordovaController = [[newCordovaFrameViewController alloc]initObject:self];
            if ([parameter2 isEqualToString:@"by_bottom"]) {
                parameter2 = @"1";
            }else{
                parameter2 = @"0";
            }
            [cordovaController controllerinit:parameter1 enterEffect:parameter2];
        });
    }];
}
-(void)viewBack:(CDVInvokedUrlCommand*)command{
    CDVPluginResult*pluginResult =nil;
    NSString*callbackidStr=  command.callbackId;
    if ([[newCordovaFrameViewController shareController].m_isSubView isEqualToString:@"0"]) {
        
         pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"当前页面不能返回，返回失败！"];
         [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        return ;
    }
     newCordovaFrameViewController* cordovaController = [newCordovaFrameViewController shareController];
     pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"成功"];
     [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
     [cordovaController Back];
}

-(void)exitApp:(CDVInvokedUrlCommand*)command{
       AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                 UIWindow *window = delegate.window;
                 // 动画 1
                 [UIView animateWithDuration:0.5f animations:^{
					window.alpha = 0.4;
                 } completion:^(BOOL finished) {
					exit(0);
                 }];
}

-(void)barcodeScanne:(CDVInvokedUrlCommand*)command{
    
    PDCameraScanViewController* cameControl = [[PDCameraScanViewController alloc]init];
    cameControl.complete = (^void(NSString* message){
        CDVPluginResult*pluginResult =nil;
        NSString*callbackidStr=  command.callbackId;
        if (message == nil ||message.length<=0) {
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"二维码扫描失败"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        }else{
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
//            pluginResult.keepCallback=  [NSNumber numberWithInt:1];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        }
       
    });
    [self.viewController presentViewController:cameControl animated:YES completion:^{
    }];
}

-(void)setValueForApp:(CDVInvokedUrlCommand*)command{
    CDVPluginResult*pluginResult =nil;
    NSString*callbackidStr=  command.callbackId;
    if ([command.arguments count]<2) {
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数缺少，保存不成功！"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        return ;
    }
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* key = @"";
    NSString* value = @"";
    for(int i = 0 ;i<[command.arguments count];i++)
    {
        if (i%2==0) {   //key
                key = [command.arguments objectAtIndex:i];
        }else{     //value
                value =[command.arguments objectAtIndex:i];
                [userDefault setValue:value forKey:key];
        }
    }
    
    pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"保存成功"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    
}
-(void)getValueFromApp:(CDVInvokedUrlCommand*)command{
    CDVPluginResult*pluginResult =nil;
    NSString*callbackidStr=  command.callbackId;
    if ([command.arguments count]<1) {
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数缺少，取值不成功！"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        return ;
    }
    NSString* key= [command.arguments objectAtIndex:0];
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* value = [userDefault valueForKey:key];
    pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    
}


@end
