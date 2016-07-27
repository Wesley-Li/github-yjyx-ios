//
//  TaskConditonModel.m
//  Yjyx
//
//  Created by liushaochang on 16/5/24.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TaskConditonModel.h"

@implementation TaskConditonModel


- (void)initModelWithArray:(NSArray *)arr {

    NSLog(@"----%@", arr);
    self.t_id = arr[0];
    self.answerArr = arr[1];
    self.rightOrWrong = arr[2];
    self.time = arr[3];
    
    if (arr.count == 5) {
        if ([[arr[4] objectForKey:@"writeprocess"] count] == 0 ) {
            self.voiceShow = NO;
            self.imgShow = NO;
        }else {
            NSArray *array = [arr[4] objectForKey:@"writeprocess"];
            for (int i = 0 ; i < array.count; i++) {
                if ([array[i][@"teachervoice"] count]!= 0) {
                    self.voiceShow = YES;
                    break;
                }else {
                    
                    self.voiceShow = NO;
                }
                
                
            }
            
            for (int i = 0; i < array.count; i++) {
                if ([array[i][@"img"] length] != 0) {
                    self.imgShow = YES;
                    break;
                }else {
                    
                    self.imgShow = NO;
                }
                
            }
            
        }

    }
    
    
}


@end
