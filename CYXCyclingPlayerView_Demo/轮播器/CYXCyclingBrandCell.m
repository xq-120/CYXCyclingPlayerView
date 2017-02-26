//
//  XQCyclingPlayerPictureCell.m
//  DayDayUpApp
//
//  Created by 薛权 on 16/11/1.
//  Copyright © 2016年 xq. All rights reserved.
//

#import "CYXCyclingBrandCell.h"
#import "NSString+Tool.h"

@implementation CYXCyclingBrandCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _brandLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.contentView addSubview:_brandLogo];
        
        _brandName = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, 20, 20)];
        _brandName.textColor = [UIColor blackColor];
        _brandName.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_brandName];
        
        UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-1, 5, 1, self.frame.size.height - 10)];
        [seperateView setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:seperateView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.brandLogo.image = nil;
    self.brandName.text = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat gap = 0;
    CGFloat imgW = 0;
    if (self.brandLogo.image!=nil && self.brandLogo.hidden != YES) {
        imgW = 20;
        gap = 3;
    }
    
    CGFloat labelMaxW = self.frame.size.width - 5 - imgW - gap - 5;
    CGFloat labelTextW = [self.brandName.text widthForSingleLineStringWithFont:[UIFont systemFontOfSize:12]];
    CGFloat labelW = labelTextW>labelMaxW?labelMaxW:labelTextW;
    CGFloat contentW = imgW+gap+labelW;
    
    CGFloat imgX = (self.frame.size.width - contentW)/2.0f;
    CGFloat imgY = (self.frame.size.height - 20)/2.0f;
    self.brandLogo.frame = CGRectMake(imgX, imgY, imgW, imgW);
    self.brandName.frame = CGRectMake(CGRectGetMaxX(self.brandLogo.frame)+gap, imgY, labelW, 20);
}

@end
