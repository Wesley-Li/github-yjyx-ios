//
//  YjyxKnowledgeCardView.h
//  Yjyx
//
//  Created by yjyx-iOS2 on 16/8/23.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YjyxKnowledgeCardView : UIView

@property (strong, nonatomic) NSString *knowledgeContent;
- (void)setKnowledgeContent:(NSString *)knowledgeContent andHeight:(CGFloat)high;
+ (instancetype)knowledgeCardView;
@end
