//
//  NSString+Help.h
//  app001
//
//  Created by 薛权 on 16/6/21.
//  Copyright © 2016年 xionghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RandomStringType){
    RandomStringTypeAlphabet,
    RandomStringTypeAlphabetNumber,
};

@interface NSString (RandomString)

+ (NSString *)randomStringWithLength:(NSInteger)length type:(RandomStringType)type;

@end

@interface NSString (Validate)

//身份证格式验证
- (BOOL)validateIDCardNumber;

//密码格式验证
- (BOOL)validatePassword;

//邮箱格式验证,但不能验证是否是一个真正的邮箱
- (BOOL)validateEmail;

//手机号验证
- (BOOL)validateMobile;

//验证是否是纯数字
- (BOOL)validateNumber;

//自己写正则传入进行判断
- (BOOL)validateWithRegExp:(NSString *)regExp;


//移除文本中的空格
- (NSString *)removeSpacing;

//格式化为银行卡号格式
- (NSString *)formatterToBankNo;
- (NSString *)formatterNumberSeparatedPerBit:(NSInteger)bit;

//截取小数点位数,最多保留decimalDigit位,且去掉小数点后多余的0.
- (NSString *)floatStringTruncateWithDecimalDigit:(int)decimalDigit;

- (void)callTelephone;

@end

@interface NSString (Calculate)

- (CGFloat)heightForStringWithFixedWidth:(CGFloat)width font:(UIFont *)font;
//单行文本的宽度
- (CGFloat)widthForSingleLineStringWithFont:(UIFont *)font;
- (CGSize)sizeForSingleLineStringWithFont:(UIFont *)font;

@end

@interface NSString (RichText)

//改变一段文本中,所有某个子字符串的颜色,字体.
+ (NSMutableAttributedString *)attributeString:(NSString *)totalString subString:(NSString *)subString color:(UIColor *)color font:(UIFont *)font;

//改变一段文本中,所有某些子字符串的颜色,字体.
+ (NSMutableAttributedString *)attributeString:(NSString *)totalString subStrings:(NSArray *)subStrings config:(NSDictionary *(^)(NSString *subString))config;


@end
