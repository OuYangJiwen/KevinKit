//
//  Palette.h
//  ChoicesColor
//
//  Created by 冷求慧 on 17/6/13.
//  Copyright © 2017年 冷求慧. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSVWithNew.h"


typedef NS_ENUM(NSInteger, PaletteChoiceType) {
    PaletteChoiceTypeTouchesBegan,
    PaletteChoiceTypeTouchesMoved,
    PaletteChoiceTypeTouchesEnded,
};

@class Palette;
@protocol PaletteDelegate <NSObject>
@optional
/**
 *  选中的颜色和对应的位置
 *
 *  @param patette    本类对象
 *  @param color      颜色对象
 *  @param colorPoint 中心点
 */
-(void)patette:(Palette *)patette choiceColor:(UIColor *)color colorPoint:(CGPoint)colorPoint;

/**
 选中的颜色

 @param patette 本类对象
 @param rgb 色值(RGB)
 */
- (void)patette:(Palette *)patette choiceRgb:(RGBType)rgb hexString:(NSString *)hexString;

/**
 选中的颜色和选中方式

 @param patette 本类对象
 @param rgb 色值(RGB)
 @param choiceType 选中方式
 */
- (void)patette:(Palette *)patette choiceColorWithRgb:(RGBType)rgb choiceType:(PaletteChoiceType)choiceType hexString:(NSString *)hexString;

/**
 准备移动时的颜色

 @param patette 本类对象
 @param rgb 色值(RGB)
 */
- (void)patette:(Palette *)patette choiceColorWithTouchesBeganRgb:(RGBType)rgb hexString:(NSString *)hexString;
/**
 拖动时的颜色
 
 @param patette 本类对象
 @param rgb 色值(RGB)
 */
- (void)patette:(Palette *)patette choiceColorWithTouchesMovedRgb:(RGBType)rgb hexString:(NSString *)hexString;
/**
 松开手时的颜色
 
 @param patette 本类对象
 @param rgb 色值(RGB)
 */
- (void)patette:(Palette *)patette choiceColorWithTouchesEndedRgb:(RGBType)rgb hexString:(NSString *)hexString;

@end

@interface Palette : UIView
/**
 *  代理属性
 */
@property (nonatomic,weak) id<PaletteDelegate> delegate;
/**
 *  滑块的中心点
 */
@property (nonatomic,assign) CGPoint    sliderCenter;
/**
 *  计算中心点位置和获取颜色
 *
 *  @param point 在本类View中的位置
 *
 *  @return 颜色
 */
-(UIColor *)calculateCenterPointInView:(CGPoint)point;

/**
 根据颜色计算中心点位置

 @param rgbType 色值(RGB)
 */
-(void)centerPointValueWithRGB:(RGBType)rgbType;

@end
