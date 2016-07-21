//
//  YjyxDrawLine.h
//  Yjyx
//
//  Created by liushaochang on 16/7/15.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxDrawLine : UIView

//所有的线条信息，包含了颜色，坐标和粗细信息
@property (nonatomic,strong) NSMutableArray  *allMyDrawPaletteLineInfos;
// 信息暂存
@property (nonatomic, strong) NSMutableArray *tempInfos;
//从外部传递的 笔刷长度和宽度，在包含画板的VC中 要是颜色、粗细有所改变 都应该将对应的值传进来
@property (nonatomic,strong)UIColor *currentPaintBrushColor;
@property (nonatomic)float currentPaintBrushWidth;

+ (YjyxDrawLine *)defaultLine;

//外部调用的清空画板和撤销上一步
- (void)cleanAllDrawBySelf;// 清空画板
- (void)cleanFinallyDraw;// 撤销上一条线条
- (void)recoverFinalDraw;// 恢复上一条线条

@end
