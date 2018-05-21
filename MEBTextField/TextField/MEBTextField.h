//
//  MEBTextField.h
//  erpboss
//
//  Created by 搞得赢 on 2017/11/22.
//  Copyright © 2017年 Meituan. All rights reserved.
//

/**
 *  已知bug:设置maxCharactersLength或者maxTextLength大于0，如果输入达到最大限制，虽然可以输入，但是快速点击键盘，会替换最后一个字符串
 *  默认都不能输入特殊字符
 */

#import <UIKit/UIKit.h>
#import "MEBNumberKeyboard.h"

@interface MEBTextField : UITextField <MEBNumberKeyboardDelegate>

#pragma mark - TextField is属性设置

/** 是否当编辑的时候显示clearButton，默认为yes */
@property(nonatomic, assign) BOOL isClearWhileEditing;

/** 是否可以输入特殊字符，默认YES，即可以输入 */
@property(nonatomic, assign) BOOL isSpecialCharacter;

/** 可输入的最大长度，不区分中英文 */
@property(nonatomic, assign) NSInteger maxTextLength;

/** 字符串最大长度，一个中文2个字符，一个英文1个字符，中文输入法下的都算中文 */
@property(nonatomic, assign) NSInteger maxCharactersLength;

/**
 *  可以输入的字符串数组
 *
 *  控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的
 *
 *  只有当isSpecialCharacter为NO时，有效
 */
@property(nonatomic, strong) NSArray<NSString *> *canInputCharacters;

/**
 *  不可以输入的字符串数组
 *
 *  全局限制，没有前提条件
 */
@property(nonatomic, strong) NSArray<NSString *> *canotInputCharacters;

/** 结尾、开头 有必填str，则会自动设为YES，默认为NO */
@property(nonatomic, assign) BOOL hasMustInputStr;

/** 开头必须输入的字符串，如果没有输入则自动添加 */
@property(nonatomic, copy) NSString *mustInputStrAtBegin;

/** 末尾必须输入的字符串，如果没有输入则自动添加 */
@property(nonatomic, copy) NSString *mustInputStrAtEnd;

/** 是否只能输入数字，默认为NO */
@property(nonatomic, assign) BOOL isOnlyNumber;

/**
 *  最多纯数字个数，比如手机11位，商品条码13位等
 *
 *  设置了maxNumberCount，默认 isOnlyNumber = YES
 */
@property(nonatomic, assign) NSInteger maxNumberCount;

/**
 *  是否是手机号码
 *
 *  设置了isPhoneNumber，默认 isOnlyNumber = YES && maxNumberCount == 11，此时maxTextLength和maxCharactersLength无效
 */
@property(nonatomic, assign) BOOL isPhoneNumber;

/**
 *  是否是价格
 *
 *  只有一个“.”，小数点后保留2位小数，首位不能输入"."，首位输入0，第二位不是“.”，会自动补充“.”
 *
 *  如果isPrice==YES，则isOnlyNumber=NO，即使isOnlyNumber设置为YES也没用，此时canotInputCharacters无效
 */
@property(nonatomic, assign) BOOL isPrice;

/**
 *  价格是否允许以“.”开头，默认是不允许，如果允许，请设置为YES
 *
 *  设置了isPriceHeaderPoint，则isPrice = YES，此时canotInputCharacters无效
 */
@property(nonatomic, assign) BOOL isPriceHeaderPoint;

/** 可输入的最大金额 */
@property(nonatomic, assign) float maxPrice;

/** 可输入的最小金额 */
@property(nonatomic, assign) float minPrice;

/** 当为价格时，可输入- */
@property(nonatomic, assign) BOOL canInputMinusWhenPrice;

/** 是否是密码，默认只能字母和数字 */
@property(nonatomic,assign) BOOL isPassword;

/**
 *  密码可以输入的字符串数组
 *
 *  控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的
 *
 *  只有当isPassword为YES时有效
 */
@property(nonatomic,strong)NSArray<NSString *> *canInputPasswords;

#pragma mark - TextField Block回调
/**
 *  文本框字符变动，回调block
 *
 *  实时监测tf的文字
 */
@property(nonatomic,copy)void(^ppTextfieldTextChangedBlock)(MEBTextField *tf);

/** 结束编辑或者失去第一响应，回调block */
@property(nonatomic,copy)void(^ppTextFieldEndEditBlock)(MEBTextField *tf);

/** 键盘右下角returnType点击block */
@property(nonatomic,copy)void(^ppTextFieldReturnTypeBlock)(MEBTextField *tf);

@end
