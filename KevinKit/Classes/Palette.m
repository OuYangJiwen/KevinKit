//
//  Palette.m
//  ChoicesColor
//
//  Created by 冷求慧 on 17/6/13.
//  Copyright © 2017年 冷求慧. All rights reserved.
//

#import "Palette.h"

@interface Palette (){
    
    HSVType currentHSVWithNew;
}

@property (nonatomic,strong)UIImageView *mainImageView;

@property (nonatomic,strong)UIImageView *sliderImageView;

@end

@implementation Palette
#pragma mark xib关联
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSomeUI];
}
#pragma mark 初始化
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSomeUI];
    }
    return self;
}
-(void)setSliderCenter:(CGPoint)sliderCenter{
    _sliderCenter=sliderCenter;
    self.sliderImageView.center=sliderCenter;
    
}
#pragma mark 添加UI

-(void)addSomeUI{
    
    self.mainImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.mainImageView.image=[UIImage imageNamed:@"paletteColor"];
    [self addSubview:self.mainImageView];
    
    self.sliderImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"followCircle"]];
    [self addSubview:self.sliderImageView];
    self.sliderImageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}



#pragma mark 开始触摸或者点击
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self calculateShowColor:touches WithType:PaletteChoiceTypeTouchesBegan];   // 得到颜色
}
#pragma mark 滑动触摸
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self calculateShowColor:touches WithType:PaletteChoiceTypeTouchesMoved]; // 得到颜色
}
#pragma mark 结束触摸
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self calculateShowColor:touches WithType:PaletteChoiceTypeTouchesEnded]; // 得到颜色
}
#pragma mark 计算和传递选择的颜色
-(CGPoint)calculateShowColor:(NSSet<UITouch *> *)touches{
    UITouch *touchObj=touches.anyObject;
    CGPoint movePoint=[touchObj locationInView:self];                       // 得到滑动的点
    
    UIColor *color=[self calculateCenterPointInView:movePoint];            //  计算得到真正的中心点和颜色
    if([self.delegate respondsToSelector:@selector(patette:choiceColor:colorPoint:)]){
        [self.delegate patette:self choiceColor:color colorPoint:self.sliderImageView.center]; // 通过代理传递颜色
    }
    
    RGBType rgb = [self rgbWithCenterPointInView:movePoint];
    
    if ([self.delegate respondsToSelector:@selector(patette:choiceRgb:hexString:)]) {
        [self.delegate patette:self choiceRgb:rgb hexString:[self toStrByRGB:rgb]];
    }
    return movePoint;
}


#pragma mark 根据类型计算和传递选择的颜色
-(void)calculateShowColor:(NSSet<UITouch *> *)touches WithType:(PaletteChoiceType)type {
    
    CGPoint movePoint= [self calculateShowColor:touches];
    RGBType rgb = [self rgbWithCenterPointInView:movePoint];
    if ([self.delegate respondsToSelector:@selector(patette:choiceColorWithRgb:choiceType:hexString:)]) {
        [self.delegate patette:self choiceColorWithRgb:rgb choiceType:type hexString:[self toStrByRGB:rgb]];
    }
    
    switch (type) {
        case PaletteChoiceTypeTouchesBegan:
            if ([self.delegate respondsToSelector:@selector(patette:choiceColorWithTouchesBeganRgb:hexString:)]) {
                [self.delegate patette:self choiceColorWithTouchesBeganRgb:rgb hexString:[self toStrByRGB:rgb]];
            }
            break;
            
        case PaletteChoiceTypeTouchesMoved:
            if ([self.delegate respondsToSelector:@selector(patette:choiceColorWithTouchesMovedRgb:hexString:)]) {
                [self.delegate patette:self choiceColorWithTouchesMovedRgb:rgb hexString:[self toStrByRGB:rgb]];
            }
            break;
            
        case PaletteChoiceTypeTouchesEnded:
            if ([self.delegate respondsToSelector:@selector(patette:choiceColorWithTouchesEndedRgb:hexString:)]) {
                [self.delegate patette:self choiceColorWithTouchesEndedRgb:rgb hexString:[self toStrByRGB:rgb]];
            }
            break;
        default:
            break;
    }
    
    
    
}

#pragma mark 计算中心点位置和获取颜色
-(UIColor *)calculateCenterPointInView:(CGPoint)point{
    
    CGPoint center=CGPointMake(self.frame.size.width/2,self.frame.size.height/2);  // 中心点
    double radius=self.frame.size.width/2;          // 半径
    double dx=ABS(point.x-center.x);    //  ABS函数: int类型 取绝对值
    double dy=ABS(point.y-center.y);   //   atan pow sqrt也是对应的数学函数
    double angle=atan(dy/dx);
    if (isnan(angle)) angle=0.0;
    double dist=sqrt(pow(dx,2)+pow(dy,2));
    double saturation=MIN(dist/radius,1.0);
    
    if (dist<10) saturation=0;
    if (point.x<center.x) angle=M_PI-angle;
    if (point.y>center.y) angle=2.0*M_PI-angle;
    
    HSVType currentHSV=HSVTypeMake(angle/(2.0*M_PI), saturation, 1.0);
    
    [self centerPointValue:currentHSV];    // 计算中心点位置
    
    UIColor *color=[UIColor colorWithHue:currentHSV.h saturation:currentHSV.s brightness:1.0 alpha:1.0];  // 得到对应的颜色
    return color;
}

- (RGBType)rgbWithCenterPointInView:(CGPoint)point{
    CGPoint center=CGPointMake(self.frame.size.width/2,self.frame.size.height/2);  // 中心点
    double radius=self.frame.size.width/2;          // 半径
    double dx=ABS(point.x-center.x);    //  ABS函数: int类型 取绝对值
    double dy=ABS(point.y-center.y);   //   atan pow sqrt也是对应的数学函数
    double angle=atan(dy/dx);
    if (isnan(angle)) angle=0.0;
    double dist=sqrt(pow(dx,2)+pow(dy,2));
    double saturation=MIN(dist/radius,1.0);
    
    if (dist<10) saturation=0;
    if (point.x<center.x) angle=M_PI-angle;
    if (point.y>center.y) angle=2.0*M_PI-angle;
    
    HSVType currentHSV= HSVTypeMake(angle/(2.0*M_PI), saturation, 1.0);
    RGBType rgb = HSV_to_RGB(currentHSV);
    return rgb;
}

#pragma mark 真正显示颜色的中心点
-(void)centerPointValue:(HSVType)currentHSV{
    
    currentHSVWithNew=currentHSV;
    currentHSVWithNew.v=1.0;
    double angle=currentHSVWithNew.h*2.0*M_PI;
    CGPoint center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    double radius=self.frame.size.width/2-self.sliderImageView.frame.size.width/2;
    radius *=currentHSVWithNew.s;
    
    CGFloat x=center.x+cosf(angle)*radius;
    CGFloat y=center.y-sinf(angle)*radius;
    
    x=roundf(x-self.sliderImageView.frame.size.width/2)+self.sliderImageView.frame.size.width/2;
    y=roundf(y-self.sliderImageView.frame.size.height/2)+self.sliderImageView.frame.size.height/2;
    
    self.sliderImageView.center=CGPointMake(x,y);    // 滑动图片的中心点位置
}

-(void)centerPointValueWithRGB:(RGBType)rgbType{
    
    HSVType myCurrentHSVWithNew = RGB_to_HSV(rgbType);
    [self centerPointValue:myCurrentHSVWithNew];
    
//////    myCurrentHSVWithNew=currentHSV;
////    myCurrentHSVWithNew.v=1.0;
////    double angle=myCurrentHSVWithNew.h*2.0*M_PI;
//    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
////    CGPoint xceneter = CGPointMake(self.sliderImageView.frame.size.width/2, self.sliderImageView.frame.size.height/2);
////    double radius=self.frame.size.width/2-self.sliderImageView.frame.size.width/2;
////    radius *=currentHSVWithNew.s;
////
////    CGFloat x=center.x+cosf(angle)*radius;
////    CGFloat y=center.y-sinf(angle)*radius;
////
////    x=roundf(x-self.sliderImageView.frame.size.width/2)+self.sliderImageView.frame.size.width/2;
////    y=roundf(y-self.sliderImageView.frame.size.height/2)+self.sliderImageView.frame.size.height/2;
////
////    self.sliderImageView.center=CGPointMake(x,y);    // 滑动图片的中心点位置
//
//    POINT point =  center_point_alue(rgbType, CENTERMake(center.x, center.y));
//     self.sliderImageView.center=CGPointMake(point.x,point.y);
}

- (NSString*)toStrByUIColor:(UIColor*)color{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    return [NSString stringWithFormat:@"#%06x", rgb];
}

- (NSString*)toStrByRGB:(RGBType)RGB{
//    CGFloat r, g, b, a;
//    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (RGB.r * 255.0f)<<16 | (int) (RGB.g * 255.0f)<<8 | (int) (RGB.b * 255.0f)<<0;
    return [NSString stringWithFormat:@"#%06x", rgb];
}

@end

