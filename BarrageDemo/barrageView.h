//
//  barrageView.h
//  BarrageDemo
//
//  Created by cheng on 2017/3/3.
//  Copyright © 2017年 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAModle.h"
@class BAImage;
@interface barrageView : UIView

/**
 *  添加弹幕图片
 */
- (void)addImage:(BAImage *)image;

/**
 *  根据弹幕模型生成弹幕图片
 */
- (BAImage *)imageWithBarrage:(BAModle *)danMu;
@end
