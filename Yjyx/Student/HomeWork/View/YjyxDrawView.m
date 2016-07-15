//
//  YjyxDrawView.m
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/7/11.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "YjyxDrawView.h"
#import "YjyxBezierPath.h"
@interface YjyxDrawView()

@property (nonatomic , strong) UIBezierPath *path;
@property (nonatomic ,strong) NSMutableArray *allPathArray;
@property(nonatomic ,assign)CGFloat pathWidth;
@property (nonatomic ,strong)UIColor *color;

@property (strong, nonatomic) NSMutableArray *delePathArr;
@end
@implementation YjyxDrawView
- (NSMutableArray *)delePathArr
{
    if (_delePathArr == nil) {
        _delePathArr = [NSMutableArray array];
    }
    return _delePathArr;
}
-(NSMutableArray *)allPathArray{
    
    if (_allPathArray == nil) {
        _allPathArray = [NSMutableArray array];
    }
    return _allPathArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}
- (void)awakeFromNib
{
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self addGestureRecognizer:pan];
    
    self.color = [UIColor redColor];
    self.pathWidth = 2;
}
- (void)revoke
{
    if (self.allPathArray.count == 0) {
        return;
    }
    [self.delePathArr addObject:self.allPathArray.lastObject];
    [self.allPathArray removeLastObject];
    [self setNeedsDisplay];
}
- (void)goForward
{
    if(self.delePathArr.count == 0){
        return;
    }
    [self.allPathArray addObject:self.delePathArr.lastObject];
    [self.delePathArr removeLastObject];
    [self setNeedsDisplay];
}
- (void)clear
{
    [self.allPathArray removeAllObjects];
    [self setNeedsDisplay];
}
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint curP =  [pan locationInView:self];
    if(pan.state == UIGestureRecognizerStateBegan){
        YjyxBezierPath *path = [[YjyxBezierPath alloc] init];
     
        [self.allPathArray addObject:path];
        [path setLineWidth:self.pathWidth];
        path.color = self.color;
        self.path = path;
        [path moveToPoint:curP];
        
    }else if(pan.state == UIGestureRecognizerStateChanged){
   
        [self.path addLineToPoint:curP];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    for (YjyxBezierPath *path in self.allPathArray) {
        [path.color set];
        [path stroke];
    }
}


@end
