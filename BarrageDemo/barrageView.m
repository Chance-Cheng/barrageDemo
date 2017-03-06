//
//  barrageView.m
//  BarrageDemo
//
//  Created by cheng on 2017/3/3.
//  Copyright © 2017年 cheng. All rights reserved.
//

#import "barrageView.h"
#import "BAImage.h"
@interface barrageView()

@property (nonatomic, assign) CGFloat imageX;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *deleteImageArray;

@property (nonatomic, strong) CADisplayLink *link;
@end


@implementation barrageView


#pragma mark - 添加弹幕图片
- (void)addImage:(BAImage *)image{
    [self.imageArray addObject:image];
    [self addTimer];
}
#pragma mark - 绘制弹幕图片
- (BAImage *)imageWithBarrage:(BAModle *)danMu{
    // 开启绘图上下文
    //
    UIFont *font = [UIFont systemFontOfSize:13];
    // 头像
    CGFloat iconH = 30;
    CGFloat iconW = iconH;
    // 间距
    CGFloat marginX = 5;
    
    // 表情的尺寸
    CGFloat emotionW = 25;
    CGFloat emotionH = emotionW;
    // 计算用户名占据的区域
    CGSize nameSize = [danMu.userName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    // 计算内容占据的区域
    CGSize textSize = [danMu.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    // 位图上下文的尺寸
    CGFloat contentH = iconH;
    CGFloat contentW = iconW + 4 * marginX + nameSize.width + textSize.width + danMu.emotions.count * emotionH;
    
    CGSize contextSize = CGSizeMake(contentW, contentH);
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0.0);
    
    // 获得位图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 将上下文保存到栈中
    CGContextSaveGState(ctx);
    // 1.绘制圆形区域
    CGRect iconFrame = CGRectMake(0, 0, iconW, iconH);
    // 绘制头像圆形
    CGContextAddEllipseInRect(ctx, iconFrame);
    // 超出圆形的要裁剪
    CGContextClip(ctx);
    // 2.绘制头像
    UIImage *icon = danMu.type ? [UIImage imageNamed:@"headImage_1"]:[UIImage imageNamed:@"headImage_2"];
    [icon drawInRect:iconFrame];
    // 将上下文出栈替换当前上下文
    CGContextRestoreGState(ctx);
    // 3.绘制背景图片
    CGFloat bgX = iconW + marginX;
    CGFloat bgY = 0;
    CGFloat bgW = contentW - bgX;
    CGFloat bgH = contentH;
    danMu.type ? [[UIColor orangeColor] set]:[[UIColor whiteColor] set];
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(bgX, bgY, bgW, bgH) cornerRadius:20.0] fill];
    
    // 4.绘制用户名
    CGFloat nameX = bgX + marginX;
    CGFloat nameY = (contentH - nameSize.height) * 0.5;
    [danMu.userName drawAtPoint:CGPointMake(nameX, nameY) withAttributes:@{NSAttachmentAttributeName:font,NSForegroundColorAttributeName:danMu.type == NO ? [UIColor orangeColor]:[UIColor blackColor]}];
    
    // 5.绘制内容
    CGFloat textX = nameX + nameSize.width + marginX;
    CGFloat textY = nameY;
    [danMu.text drawAtPoint:CGPointMake(textX, textY) withAttributes:@{NSAttachmentAttributeName:font,NSForegroundColorAttributeName:danMu.type == NO ? [UIColor blackColor]:[UIColor whiteColor]}];
    
    // 6.绘制表情
    __block CGFloat emotionX = textX + textSize.width;
    CGFloat emotionY = (contentH - emotionH) * 0.5;
    [danMu.emotions enumerateObjectsUsingBlock:^(NSString *emotionName, NSUInteger idx, BOOL * _Nonnull stop) {
        // 加载表情图片
        UIImage *emotion = [UIImage imageNamed:emotionName];
        [emotion drawInRect:CGRectMake(emotionX, emotionY, emotionW, emotionH)];
        // 修改emotionX
        emotionX += emotionW;
    }];
    // 从位图上下文中获得绘制好的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return [[BAImage alloc] initWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}
    
#pragma mark - 绘制移动
- (void)drawRect:(CGRect)rect{
    
    for (BAImage *image in self.imageArray) {
        image.x -= 3;
        // 绘制图片
        [image drawAtPoint:CGPointMake(image.x, image.y)];
        // 判断图片是否超出屏幕
        if (image.x + image.size.width < 0) {
            [self.deleteImageArray addObject:image];
        }
    }
    // 移除超过屏幕的弹幕
    for (BAImage *image in self.deleteImageArray) {
        [self.imageArray removeObject:image];
    }
    [self.deleteImageArray removeAllObjects];
}
#pragma mark - 添加定时器
- (void)addTimer{
    if (self.link) {
        return;
    }
    // 每秒执行60次回调
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    // 将定时器添加到runLoop
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}
#pragma mark - 懒加载
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}
- (NSMutableArray *)deleteImageArray{
    if (!_deleteImageArray) {
        _deleteImageArray = [NSMutableArray new];
    }
    return _deleteImageArray;
}

@end
