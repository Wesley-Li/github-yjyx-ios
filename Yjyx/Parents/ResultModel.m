//
//  ResultModel.m
//  Yjyx
//
//  Created by liushaochang on 16/6/28.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "ResultModel.h"

@implementation ResultModel

- (void)initModelWithArray:(NSArray *)array {

    self.q_id = array[0];
    self.myAnswer = array[1];
    self.rightOrWrong = array[2];
    self.time = array[3];
    if (array.count == 5) {
        self.writeprocess = [array[4] objectForKey:@"writeprocess"];
        
        if ([[array[4] objectForKey:@"writeprocess"] count] == 0 ) {
            
            self.anonatationShow = NO;
        }else {
            NSArray *array1 = [array[4] objectForKey:@"writeprocess"];
            for (int i = 0; i < array1.count; i++) {
                if ([array1[i][@"img"] length] != 0) {
                    self.anonatationShow = YES;
                    break;
                }else {
                    
                    self.anonatationShow = NO;
                }
                
            }
            
        }

        
    }
}


@end
