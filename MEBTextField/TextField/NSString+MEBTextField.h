//
//  NSString+MEBTextField.h
//  erpboss
//
//  Created by 搞得赢 on 2017/11/22.
//  Copyright © 2017年 Meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PPTextFieldStringType) {
    PPTextFieldStringTypeNumber,              //数字
    PPTextFieldStringTypeLetter,              //字母
    PPTextFieldStringTypeChinese,             //汉字
    PPTextFieldStringTypeNineGridChinese      //九宫格汉字
};

@interface NSString (MEBTextField)

/**
    某个字符串是不是数字、字母、汉字。
 */
-(BOOL)pp_is:(PPTextFieldStringType)stringType;


/**
    字符串是不是特殊字符，此时的特殊字符就是：出数字、字母、汉字以外的。
 */
-(BOOL)pp_isSpecialLetter;

/**
    获取字符串长度 【一个汉字算2个字符串，一个英文算1个字符串】
 */
-(int)pp_getStrLengthWithCh2En1;


/**
    移除字符串中除exceptLetters外的所有特殊字符
 */
-(NSString *)pp_removeSpecialLettersExceptLetters:(NSArray<NSString *> *)exceptLetters;

@end
