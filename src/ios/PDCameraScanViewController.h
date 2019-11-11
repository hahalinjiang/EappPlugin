//
//  PDCameraScanViewController.h
//  DiErZhouKaoShi
//
//  Created by 裴铎 on 2018/7/16.
//  Copyright © 2018年 裴铎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDCameraScanViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
}
@property(nonatomic,retain)UIImageView* m_imageView;
@property(nonatomic,retain)void(^complete)(NSString* flag);
@property(nonatomic,retain)UIImage* m_image;
@end
