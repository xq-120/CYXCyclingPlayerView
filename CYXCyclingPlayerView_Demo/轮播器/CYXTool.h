//
//  CYXTool.h
//  app001
//
//  Created by 薛权 on 16/8/16.
//  Copyright © 2016年 xionghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYXTool : NSObject

+ (NSString *)fetchPhoneType;

+ (NSString *)roundingNumber:(NSString *)price afterPoint:(NSInteger)position roudingMode:(NSRoundingMode)roundingMode;

//roundingMode:四舍五入
+ (NSString *)roundingNumber:(NSString *)price afterPoint:(NSInteger)position;

//roundingMode:四舍五入;保留两位小数且去掉末尾多余0; 0.325000 ->0.32; 0.325100 ->0.33;
+ (NSString *)defaultRoundingNumber:(NSString *)price;

@end
