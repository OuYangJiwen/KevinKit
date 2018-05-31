//
//  HSVWithNew.h
//  ChoicesColor
//
//  Created by 冷求慧 on 17/6/13.
//  Copyright © 2017年 冷求慧. All rights reserved.
//

#ifndef HSVWithNew_h
#define HSVWithNew_h

#define UNDEFINED 0

//定义两个结构体

typedef struct {float r, g, b;} RGBType;
typedef struct {float h, s, v;} HSVType;
typedef struct{float x, y;} CENTER;
typedef struct{float x, y;} POINT;

RGBType RGBTypeMake(float r, float g, float b);
HSVType HSVTypeMake(float h, float s, float v);
CENTER CENTERMake(float x,float y);
//point
POINT POINTMake(float x,float y);

HSVType RGB_to_HSV( RGBType RGB );
RGBType HSV_to_RGB( HSVType HSV );
POINT center_point_alue(RGBType rgb,CENTER center);


#endif /* HSVWithNew_h */
