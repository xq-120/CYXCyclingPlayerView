//
//  NSString+Help.m
//  app001
//
//  Created by 薛权 on 16/6/21.
//  Copyright © 2016年 xionghao. All rights reserved.
//

#import "NSString+Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import "CYXTool.h"

static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
static const NSString *kRandomAlphabetNumber = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation NSString (RandomString)

+ (NSString *)randomStringWithLength:(NSInteger)length type:(RandomStringType)type
{
    if (length <= 0){
        return nil;
    }
    
    NSString *sourceStr = nil;
    if (type == RandomStringTypeAlphabet) {
        sourceStr = [kRandomAlphabet copy];
    }else if (type == RandomStringTypeAlphabetNumber){
        sourceStr = [kRandomAlphabetNumber copy];
    }else{
        return nil;
    }
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++){
        [randomString appendFormat: @"%C", [sourceStr characterAtIndex:arc4random_uniform((u_int32_t)[sourceStr length])]];
    }
    return randomString;
}

@end


@implementation NSString (Validate)

/**
 *  校验身份证号码
 */
- (BOOL)validateIDCardNumber
{
    /*
     目前中国实行的是第二代身份证，身份证号统一为18位，之前的15位在更换第二代身份证之后，将变成18位。
     验证身份证必须满足一下规则：
     1、长度必须是18位，前17位必须是数字，第十八位可以是数字或X；
     2、前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91；
     3、第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
     4、第17位表示性别，双数表示女，单数表示男
     5、第18位为前17位的校验位
     6、出生年份的前两位必须是19或20
     7、如果格式正确，将前17位数字分别乘以不同的系数，从第1位到第17位的系数分别为：7-9-10-5-8-4-2-1-6-3-7-9-10-5-8-4-2，将这17位数字和系数相乘的结果相加。然后除以11，余数只可能为0-1-2-3-4-5-6-7-8-9-10这11个数字，其分别对应的最后一位身份证的号码为1-0-X-9-8-7-6-5-4-3-2
    */
    
    NSString *IDNumber = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (IDNumber.length != 18)
    {
        return NO;
    }
    
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd, @"[0-9]{3}[0-9Xx]"];
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![regexTest evaluateWithObject:IDNumber])
    {
        return NO;
    }
    
    NSMutableArray *IDArray = [NSMutableArray array];
    // 遍历身份证字符串,存入数组中
    for (NSInteger i = 0; i < 18; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    // 系数数组
    NSArray *coefficientArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    // 余数数组
    NSArray *remainderArray = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    NSInteger sum = 0;
    for (NSInteger i = 0; i < 17; i++)
    {
        NSInteger coefficient = [coefficientArray[i] integerValue];
        NSInteger ID = [IDArray[i] integerValue];
        sum += coefficient * ID;
    }
    // 这个和除以11的余数对应的数
    NSString *str = remainderArray[(sum % 11)];
    // 身份证号码最后一位
    NSString *lastNOStr = [IDNumber substringFromIndex:17];
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    if ([str isEqualToString:lastNOStr])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//密码
- (BOOL)validatePassword
{
    NSString *passwordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    return [self validateWithRegExp:passwordRegex];
}

//邮箱
- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self validateWithRegExp:emailRegex];
}

//手机号码验证
- (BOOL)validateMobile
{
    //电信号段:133/153/180/181/189/177
    //联通号段:130/131/132/155/156/185/186/145/176
    //移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //虚拟运营商:170
    
    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    return [self validateWithRegExp:mobile];
}

- (BOOL)validateNumber
{
    NSString *number=@"^[0-9]+$";
    return [self validateWithRegExp:number];
}

- (BOOL)validateWithRegExp:(NSString *)regExp
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    BOOL rs = [predicate evaluateWithObject:self];
    return rs;
}

- (NSString *)removeSpacing
{
    NSString *rs = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return rs;
}

- (NSString *)formatterToBankNo
{
    return [self formatterNumberSeparatedPerBit:4];
}

- (NSString *)formatterNumberSeparatedPerBit:(NSInteger)bit
{
    if (bit <= 0){
        return self;
    }
    
    if (self.length <= bit){
        return self;
    }else{
        NSMutableString *destString = [[NSMutableString alloc] init];
        NSInteger loopCnt = 0;
        NSInteger cnt = self.length/bit;
        if (self.length%bit) {
            loopCnt = cnt;
        }else{
            loopCnt = cnt - 1;
        }
        for (int i = 0; i < loopCnt; i++)
        {
            NSString *subString = [self substringWithRange:NSMakeRange(i*bit, bit)];
            subString = [subString stringByAppendingString:@" "];
            [destString appendString:subString];
        }
        NSString *remainedString = [self substringFromIndex:loopCnt*bit];
        [destString appendString:remainedString];
        
        return destString;
    }
}

- (NSString *)floatStringTruncateWithDecimalDigit:(int)decimalDigit
{
    if (self.length == 0) {
        return @"0";
    }
    
    if ([self rangeOfString:@"."].length == 0) {    //不是小数
        return self;
    }
    
    NSString *rs = [CYXTool roundingNumber:self afterPoint:decimalDigit];
    return rs;
}

- (void)callTelephone
{
    NSMutableString *telFormat = [[NSMutableString alloc] initWithFormat:@"tel:%@", self];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIWebView *callWebview = [window viewWithTag:353534];
    if (callWebview == nil) {
        callWebview = [[UIWebView alloc] init];
        callWebview.tag = 353534;
    }
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telFormat]]];
    [window addSubview:callWebview];
}

@end

@implementation NSString (Calculate)

- (CGFloat)heightForStringWithFixedWidth:(CGFloat)width font:(UIFont *)font
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];//固定宽度,计算文本高度
    CGFloat height = ceilf(rect.size.height);
    return height+1;
}

- (CGFloat)widthForSingleLineStringWithFont:(UIFont *)font
{
    CGSize size = [self sizeForSingleLineStringWithFont:font];
    return size.width;
}

- (CGSize)sizeForSingleLineStringWithFont:(UIFont *)font
{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName: font}];
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return CGSizeZero;
    }
    
    CGSize ceiledSize = CGSizeMake(ceil(size.width), ceil(size.height));
    return ceiledSize;
}

@end

@implementation NSString (RichText)

+ (NSMutableAttributedString *)attributeString:(NSString *)totalString subString:(NSString *)subString color:(UIColor *)color font:(UIFont *)font
{
    if (totalString == nil) {
        return nil;
    }
    
    if (subString == nil) {
        return nil;
    }
    
    NSMutableAttributedString *mAttributString = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSMutableDictionary *attriDict = [NSMutableDictionary dictionary];
    [attriDict setValue:color forKey:NSForegroundColorAttributeName];
    [attriDict setValue:font forKey:NSFontAttributeName];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:subString options:NSRegularExpressionIgnoreMetacharacters error:nil];
    NSArray *matches = [regex matchesInString:totalString options:0 range:NSMakeRange(0, totalString.length)];
    
    for(NSTextCheckingResult *result in [matches objectEnumerator]){
        NSRange matchRange = [result range];
        [mAttributString setAttributes:attriDict range:matchRange];
    }
    
    return mAttributString;
}

+ (NSMutableAttributedString *)attributeString:(NSString *)totalString subStrings:(NSArray *)subStrings config:(NSDictionary *(^)(NSString *subString))config
{
    if (totalString == nil) {
        return nil;
    }
    
    NSMutableAttributedString *mAttributString = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *str in subStrings) {
        NSDictionary *attriDict = nil;
        if (config) {
            attriDict = config(str);
        }
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:str options:NSRegularExpressionIgnoreMetacharacters error:nil];
        NSArray *matches = [regex matchesInString:totalString options:0 range:NSMakeRange(0, totalString.length)];
        
        for(NSTextCheckingResult *result in [matches objectEnumerator]){
            NSRange matchRange = [result range];
            [mAttributString setAttributes:attriDict range:matchRange];
        }
    }
    
    return mAttributString;
}

@end
