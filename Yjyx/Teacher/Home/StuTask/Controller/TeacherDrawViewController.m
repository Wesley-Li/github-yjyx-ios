//
//  TeacherDrawViewController.m
//  Yjyx
//
//  Created by liushaochang on 16/7/13.
//  Copyright © 2016年 Alibaba. All rights reserved.
//

#import "TeacherDrawViewController.h"
#import "YjyxDrawLine.h"

@interface TeacherDrawViewController ()

{
    UIColor *paintColor;

}
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;


@end

@implementation TeacherDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.voiceBtn.layer.cornerRadius = 41;
    self.voiceBtn.layer.masksToBounds = YES;
    [self.imageview setImageWithURL:[NSURL URLWithString:_imgURL]];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"储存" style:UIBarButtonItemStylePlain target:self action:@selector(saveImageAct:)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
       
}

- (IBAction)drawBlueLine:(UIButton *)sender {
    paintColor = [UIColor blueColor];
    
    YjyxDrawLine *lineView = [[YjyxDrawLine alloc] initWithFrame:self.imageview.frame];
    lineView.currentPaintBrushColor = paintColor;
    lineView.currentPaintBrushWidth = 3;
    [self.view addSubview:lineView];

}
- (IBAction)drawYelloewLine:(UIButton *)sender {
    paintColor = [UIColor yellowColor];
}
- (IBAction)drawRedLine:(UIButton *)sender {
    paintColor = [UIColor redColor];
}

- (void)saveImageAct:(id)sender {
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.imageview.frame];
    [self.view addSubview:imageV];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, imageV.frame.size.height), YES, 1.0);
    [imageV.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    imageV.image=uiImage;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
