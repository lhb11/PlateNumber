//
//  ProvinceCollectionViewCell.m
//  ProvinceSelectView
//
//  Created by 李挺哲 on 2016/11/25.
//  Copyright © 2016年 李挺哲. All rights reserved.
//

#import "ProvinceCollectionViewCell.h"

@implementation ProvinceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_label.layer setMasksToBounds:YES];
    [_label.layer setCornerRadius:8.0];//设置矩形四个圆角半径
    [_label.layer setBorderWidth:1.5];//边框宽度
    [_label.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
//    NSLog(@"ProvinceCollectionViewCell size =%@, label size =%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(_label.frame));
    
}

-(void)layoutIfNeeded{

//    NSLog(@"ProvinceCollectionViewCell size =%@, label size =%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(_label.frame));


}

@end
