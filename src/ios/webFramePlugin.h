//
//  webFramePlugin.h
//  YTH
//
//  Created by gu yong on 2019/9/5.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import "newCordovaFrameViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface webFramePlugin : CDVPlugin

-(void)openNewView:(CDVInvokedUrlCommand*)command;
-(void)viewBack:(CDVInvokedUrlCommand*)command;
-(void)exitApp:(CDVInvokedUrlCommand*)command;
-(void)barcodeScanne:(CDVInvokedUrlCommand*)command;
-(void)setValueForApp:(CDVInvokedUrlCommand*)command;
-(void)getValueFromApp:(CDVInvokedUrlCommand*)command;
@end

NS_ASSUME_NONNULL_END
