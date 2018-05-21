//
//  MEBTextField.m
//  erpboss
//
//  Created by 搞得赢 on 2017/11/22.
//  Copyright © 2017年 Meituan. All rights reserved.
//


#import "MEBTextField.h"
#import "NSString+MEBTextField.h"

#define kNumbersPeriod  @"0123456789."
#define kOnlyNumber  @"0123456789"
#define KOnlyCharacter @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define KCharacterNumber @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@implementation MEBTextField

- (void)configurePPTextfield
{
    self.delegate = (id<UITextFieldDelegate>)self;
    self.autocorrectionType = UITextAutocorrectionTypeNo; // 不自动提示
    [self pp_addTargetEditingChanged];
    [self setupDefaultConfigure];
    
}
#pragma mark - 配置默认设置
- (void)setupDefaultConfigure
{
    _isOnlyNumber = NO;
    _isPriceHeaderPoint = NO;
    // 清楚按钮默认设置
    _isClearWhileEditing = YES;
    if (_isClearWhileEditing) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    _isSpecialCharacter = YES;
    _mustInputStrAtBegin = NULL;
    _mustInputStrAtEnd = NULL;
    _maxPrice = 999999999;
    _minPrice = -999999999;
    _canInputMinusWhenPrice = NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurePPTextfield];
    }
    return self;
}

#pragma mark - 支持xib
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configurePPTextfield];
}

- (void)setIsClearWhileEditing:(BOOL)isClearWhileEditing
{
    _isClearWhileEditing = isClearWhileEditing;
    if (isClearWhileEditing) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.clearButtonMode = UITextFieldViewModeNever;
    }
}

- (void)setIsSpecialCharacter:(BOOL)isSpecialCharacter
{
    _isSpecialCharacter = isSpecialCharacter;
}

- (void)setCanInputCharacters:(NSArray<NSString *> *)canInputCharacters
{
    // 再次说明：当不可以输入特殊字符，但是特殊字符中的某个或某几个又是需要的时，所以前提是不可以输入特殊字符
    _canInputCharacters = canInputCharacters;
    [self setIsSpecialCharacter:NO];
}

- (void)setCanotInputCharacters:(NSArray<NSString *> *)canotInputCharacters
{
    _canotInputCharacters = canotInputCharacters;
}

- (void)setMustInputStrAtBegin:(NSString *)mustInputStrAtBegin
{
    if (!_mustInputStrAtBegin) {
        _mustInputStrAtBegin = mustInputStrAtBegin;
    }
    _hasMustInputStr = YES;
}

- (void)setMustInputStrAtEnd:(NSString *)mustInputStrAtEnd
{
    if (!_mustInputStrAtEnd) {
        _mustInputStrAtEnd = mustInputStrAtEnd;
    }
    _hasMustInputStr = YES;
}

- (void)setIsOnlyNumber:(BOOL)isOnlyNumber
{
    _isOnlyNumber = isOnlyNumber;
    _isSpecialCharacter = NO;
    if (_isOnlyNumber) {
        _isPrice = NO;
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (void)setIsPrice:(BOOL)isPrice
{
    _isPrice = isPrice;
    _isSpecialCharacter = NO;
    if (_canotInputCharacters) {
        _canotInputCharacters = [NSArray array];
    }
    //防止冲突
    if (_isPrice) {
        _isOnlyNumber = NO;
        if (_canInputMinusWhenPrice) {
            MEBNumberKeyboard *keyboard = [[MEBNumberKeyboard alloc] initWithFrame:CGRectZero];
            keyboard.allowsDecimalPoint = YES;
            keyboard.delegate = self;
            self.inputView = keyboard;
            
        } else {
            self.keyboardType = UIKeyboardTypeDecimalPad;
        }
    }
}

- (void)editChanage:(id)sender
{
    NSString *str = (NSString *)sender;
    [self textField:self shouldChangeCharactersInRange:NSMakeRange(self.text.length, 1) replacementString:str];
}

- (void)setIsPriceHeaderPoint:(BOOL)isPriceHeaderPoint
{
    _isPriceHeaderPoint = isPriceHeaderPoint;
    [self setIsPrice:YES];
}

- (void)setMaxPrice:(float)maxPrice
{
    if (_maxPrice != maxPrice) {
        _maxPrice = maxPrice;
    }
    [self setIsPrice:YES];
}

- (void)setMinPrice:(float)minPrice
{
    if (_minPrice != minPrice) {
        _minPrice = minPrice;
    }
    [self setIsPrice:YES];
}

#pragma mark - 最大纯数字数量
- (void)setMaxNumberCount:(NSInteger)maxNumberCount
{
    _maxNumberCount = maxNumberCount;
    [self setIsOnlyNumber:YES];
}

#pragma mark - 电话号码
- (void)setIsPhoneNumber:(BOOL)isPhoneNumber
{
    _isPhoneNumber = isPhoneNumber;
    [self setIsOnlyNumber:YES];
    [self setMaxNumberCount:11];
}

#pragma mark - 是不是密码
- (void)setIsPassword:(BOOL)isPassword
{
    _isPassword = isPassword;
    self.secureTextEntry = YES;
    _isSpecialCharacter = NO;
}

- (void)setCanInputPassword:(NSArray<NSString *> *)canInputPasswords
{
    // 再次说明：密码默认只能输入字母和数字，但有时又要可以输入某个或某些非字母或数字的字符，所以前提是（是输入密码）
    _canInputPasswords = canInputPasswords;
    [self setIsPassword:YES];
}

- (void)setMaxCharactersLength:(NSInteger)maxCharactersLength
{
    _maxCharactersLength = maxCharactersLength;
    // 说明：maxCharactersLength和maxTextLength互斥，无论谁，都是要判断其值是否大于0，所以，其中一个大于0时，另一个就要为0
    if (_maxCharactersLength > 0) {
        _maxTextLength = 0;
    }
}

- (void)setMaxTextLength:(NSInteger)maxTextLength
{
    _maxTextLength = maxTextLength;
    if (_maxTextLength > 0) {
        _maxCharactersLength = 0;
    }
}

#pragma mark - UITextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.ppTextFieldReturnTypeBlock) {
        self.ppTextFieldReturnTypeBlock(self);
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_mustInputStrAtEnd != NULL) {
        if (_mustInputStrAtEnd.length <= self.text.length) {
            if ([[self.text substringFromIndex:self.text.length - _mustInputStrAtEnd.length] isEqualToString:_mustInputStrAtEnd] == NO) {
                self.text = [NSString stringWithFormat:@"%@%@", self.text, _mustInputStrAtEnd];
            }
        }
    }
    
    // 必须textFieldShouldEndEditing返回为YES
    if (self.ppTextFieldEndEditBlock) {
        self.ppTextFieldEndEditBlock(self);
    }
}

#pragma mark - MMNumberKeyboard Delegate
- (BOOL)numberKeyboard:(MEBNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text
{
    return [self textField:self shouldChangeCharactersInRange:NSMakeRange(self.text.length, 0) replacementString:text];
}

#pragma mark - 是否允许该输入（数字类型，价格类型，特殊字符类型 是否相符）
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_hasMustInputStr) {
        [self deleteMustInputStr:(MEBTextField *)textField];
        range = NSMakeRange(range.location - _mustInputStrAtBegin.length, range.length);
    }
    
    // 此方法里面不需要根据字符串最大个数判断是否可以输入,截取方法里面用到，超过了就截取！！！
    // 判断输入的是否为数字 (只能输入数字)
    if (_isOnlyNumber) {
        // 如果是数字了，但是该数字包含在数组canotInputCharacters里，同样不能输入
        if ([string pp_is:PPTextFieldStringTypeNumber]) {
            if ([self.canotInputCharacters containsObject:string]) {
                return NO;
            }else{
                return YES;
            }
        }else{
            return NO;
        }
    }
    
    // 密码
    if (_isPassword) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:KCharacterNumber] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            if ([self.canInputPasswords containsObject:string]) {
                return YES;
            }
            return NO;
        }else{
            return YES;
        }
    }
    // 与_isSpecialCharacter互斥，所以此处必须写，要不走下面的_isSpecialCharacter的判断
    if (_isPrice) {
        BOOL isLimitPrice = [self limitPriceWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
        if (_hasMustInputStr) {
            [self addMustInputStr:_mustInputStrAtBegin];
        }
        return isLimitPrice;
    }
    // 特殊字符，一定要放在该方法最后一个判断，要不会影响哪些它互斥的设置
    if (!_isSpecialCharacter) {
        if ([self.canInputCharacters containsObject:string] || [self.canInputPasswords containsObject:string]) {
            return YES;
        }else{
            if ([string pp_isSpecialLetter] || [self.canotInputCharacters containsObject:string]) {
                return NO;
            }
            return YES;
        }
    }
    return YES;
}

/*
- (BOOL)limitPriceWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 参考：[UITextField 的限制输入金额(可为小数的正确金额)](http://www.cnblogs.com/fcug/p/5500349.html)
    if (textField.text.length > 10) {
        return range.location < 11;
    }else{
        BOOL isHaveDian = YES;
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            isHaveDian=NO;
        }
        if ([string length] > 0){
            unichar single=[string characterAtIndex:0]; // 当前输入的字符
            if ((single >='0' && single<='9') || single=='.') // 数据格式正确
            {
                if (_isPriceHeaderPoint) {
                    // 首字母可以为小数点
                    if([textField.text length]==0){
                        if(single == '.'){
                            NSLog(@"isheder11 %@",textField.text);
                            textField.text = @"0"; // 此处强制让textField.text = 0,然后又return YES,这样第一个字符输入.，显示的就是0.
                            NSLog(@"%@",textField.text);
                            return YES;
                        }
                    }
                }
                // 首字母不能为小数点
                if([textField.text length]==0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                if([textField.text length]==1 && [textField.text isEqualToString:@"0"]){
                    if(single != '.'){
                        textField.text = @"0.";
                        return YES;
                    }
                }
                if (single=='.'){
                    if(!isHaveDian) // text中还没有小数点
                    {
                        isHaveDian=YES;
                        return YES;
                    }else
                    {
                        if (range.location > 100000000) {
                            range.location = 0;
                        }
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else
                {
                    if (isHaveDian) // 存在小数点
                    {
                        // 判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        NSInteger tt=range.location-ran.location;
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }
                    else
                    {
                        return YES;
                    }
                }
            }else{ // 输入的数据格式不正确
                if (range.location > 10000000) {
                    range.location = 0;
                }
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
}
*/

- (BOOL)limitPriceWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 参考：[UITextField 的限制输入金额(可为小数的正确金额)](http://www.cnblogs.com/fcug/p/5500349.html)
    if (textField.text.length > 10) {
        return range.location < 11;
    }else{
        BOOL isHaveDian = YES;
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            isHaveDian = NO;
        }
        BOOL isHaveMinus = YES;
        if ([textField.text rangeOfString:@"-"].location == NSNotFound) {
            isHaveMinus = NO;
        }
        if ([string length] > 0){
            unichar single=[string characterAtIndex:0]; // 当前输入的字符
            if (single=='-') {
                if (!_canInputMinusWhenPrice) {
                    return NO;
                }
                if ([textField.text length] == 0) {
                    return YES;
                } else {
                    return NO;
                }
            }
            if ((single >='0' && single<='9') || single=='.' || single=='-') // 数据格式正确
            {
                if (_isPriceHeaderPoint) {
                    // 首字母可以为小数点
                    if (isHaveMinus) {
                        if([textField.text length]==1){
                            if(single == '.'){
                                NSLog(@"isheder11 %@",textField.text);
                                textField.text = @"-0"; // 此处强制让textField.text = 0,然后又return YES,这样第一个字符输入.，显示的就是0.
                                NSLog(@"%@",textField.text);
                                return YES;
                            }
                        }
                    } else {
                        if([textField.text length]==0){
                            if(single == '.'){
                                NSLog(@"isheder11 %@",textField.text);
                                textField.text = @"0"; // 此处强制让textField.text = 0,然后又return YES,这样第一个字符输入.，显示的就是0.
                                NSLog(@"%@",textField.text);
                                return YES;
                            }
                        }
                    }
                }
                // 首字母不能为小数点
                if (isHaveMinus) {
                    if([textField.text length]==1){
                        if(single == '.'){
                            [textField.text stringByReplacingCharactersInRange:range withString:@"-"];
                            return NO;
                        }
                    }
                } else {
                    if([textField.text length]==0){
                        if(single == '.'){
                            [textField.text stringByReplacingCharactersInRange:range withString:@""];
                            return NO;
                        }
                    }
                }
                if (isHaveMinus) {
                    if([textField.text length]==2 && [textField.text isEqualToString:@"-0"]){
                        if(single != '.'){
                            textField.text = @"-0.";
                            return YES;
                        }
                    }
                } else {
                    if([textField.text length]==1 && [textField.text isEqualToString:@"0"]){
                        if(single != '.'){
                            textField.text = @"0.";
                            return YES;
                        }
                    }
                }
                if (isHaveMinus) {
                    if (single=='.'){
                        if(!isHaveDian) // text中还没有小数点
                        {
                            isHaveDian=YES;
                            return YES;
                        }else
                        {
                            if (range.location > 100000000) {
                                range.location = 0;
                            }
                            [textField.text stringByReplacingCharactersInRange:range withString:@""];
                            return NO;
                        }
                    }
                    else
                    {
                        if (isHaveDian) // 存在小数点
                        {
                            // 判断小数点的位数
                            NSRange ran=[textField.text rangeOfString:@"."];
                            NSInteger tt=range.location-ran.location;
                            if (tt <= 2){
                                return YES;
                            }else{
                                return NO;
                            }
                        }
                        else
                        {
                            return YES;
                        }
                    }
                } else {
                    if (single=='.'){
                        if(!isHaveDian) // text中还没有小数点
                        {
                            isHaveDian=YES;
                            return YES;
                        }else
                        {
                            if (range.location > 100000000) {
                                range.location = 0;
                            }
                            [textField.text stringByReplacingCharactersInRange:range withString:@""];
                            return NO;
                        }
                    }
                    else
                    {
                        if (isHaveDian) // 存在小数点
                        {
                            // 判断小数点的位数
                            NSRange ran=[textField.text rangeOfString:@"."];
                            NSInteger tt=range.location-ran.location;
                            if (tt <= 2){
                                return YES;
                            }else{
                                return NO;
                            }
                        }
                        else
                        {
                            return YES;
                        }
                    }
                }
            }else{ // 输入的数据格式不正确
                if (range.location > 10000000) {
                    range.location = 0;
                }
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
}

#pragma mark - 输入后是否符合输入标准
- (void)pp_addTargetEditingChanged
{
    [self addTarget:self action:@selector(textFieldTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextEditingChanged:(id)sender
{
    bool isChinese; // 判断当前输入法是否是中文
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    // [[UITextInputMode currentInputMode] primaryLanguage]，废弃的方法
    if ([current.primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
        if (currentar.count>1) {
            UITextInputMode *secondCurrent = [currentar objectAtIndex:1];
            if (secondCurrent) {
                if ([secondCurrent.primaryLanguage isEqualToString:@"en-US"]) {
                    isChinese = false;
                } else {
                    isChinese = true;
                }
            }
        }
    }else{
        isChinese = true;
    }
    if(sender == self) {
        NSString *toBeString = self.text;
        if (isChinese) { // 中文输入法下
            UITextRange *selectedRange = [self markedTextRange];
            // 获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                [self setupLimits:toBeString];
            }
        }else{
            [self setupLimits:toBeString];
        }
    }
    // 所有都处理完了来回调
    if (self.ppTextfieldTextChangedBlock) {
        self.ppTextfieldTextChangedBlock(self);
    }
}

- (void)setupLimits:(NSString *)toBeString
{
    if (_hasMustInputStr) {
         if (self.text.length != 0) {
            if (_mustInputStrAtBegin != NULL) {
                if (_mustInputStrAtBegin.length <= self.text.length) {
                    if ([[self.text substringToIndex:_mustInputStrAtBegin.length] isEqualToString:_mustInputStrAtBegin] == YES) {
                        toBeString = [toBeString substringFromIndex:_mustInputStrAtBegin.length];
                    }
                }
            }
            if (_mustInputStrAtEnd != NULL) {
                if (_mustInputStrAtEnd.length <= self.text.length) {
                    if ([[self.text substringFromIndex:toBeString.length -_mustInputStrAtBegin.length] isEqualToString:_mustInputStrAtEnd] == YES) {
                        toBeString = [toBeString substringToIndex:toBeString.length - _mustInputStrAtEnd.length];
                    }
                }
            }
        }
    }
    
    if (toBeString.length == 0) {
        return;
    }
    
    // 价格，return 不然的话会走（特殊字符处理），这样就把.去掉了
    if (_isPrice) {
        float nowPrice = [toBeString floatValue];
        if (nowPrice > _maxPrice) {
            self.text = [toBeString substringToIndex:toBeString.length-1];
        } else {
            if (nowPrice < _minPrice) {
                self.text = [toBeString substringToIndex:toBeString.length-1];
            } else {
                self.text = toBeString;
            }
        }
        // 价格要放在【特殊字符处理】前，并且不让再继续下去。
        if (_hasMustInputStr) {
             [self addMustInputStr:toBeString];
        }
        return;
    }
    NSLog(@"price---%@----%@",toBeString,self.text);
    // 特殊字符处理
    if (!_isSpecialCharacter) {
        NSMutableArray *filterArrs = [NSMutableArray arrayWithArray:self.canInputCharacters];
        // 要处理
        if (_isPassword && self.canInputPasswords.count > 0) {
            [filterArrs addObjectsFromArray:self.canInputPasswords];
        }
        NSLog(@"phone11 %@---%@",toBeString,self.text);
        self.text = [toBeString pp_removeSpecialLettersExceptLetters:filterArrs];
        NSLog(@"phone22 %@---%@",toBeString,self.text);
    }
    
    // 纯数字限制：如果限制最大个数大于0，就配置_maxNumberCount，不允许多输入
    // 要放在特殊字符处理后，因为放在前，走特殊字符时，toBeString并没有被裁剪，而self.text又=toBeString，所以放后面
    if (_isOnlyNumber) {
        if ([toBeString pp_is:PPTextFieldStringTypeNumber]) {
            if (_maxNumberCount > 0) {
                if (toBeString.length > _maxNumberCount) {
                    self.text = [toBeString substringToIndex:_maxNumberCount];
                    // 超过了最大限制数字
                } else {
                    self.text = toBeString;
                }
            }
        }
    }
    
    // 最大字数和最大字符数判断
    // 区分中英文
    if (_maxCharactersLength > 0) {
        if (!_isPhoneNumber) { // 电话号码时_maxCharactersLength无效
            int totalCountAll = [toBeString pp_getStrLengthWithCh2En1];
            if (totalCountAll > _maxCharactersLength) {
                int totalCount = 0;
                for (int i = 0; i < toBeString.length; i++) {
                    NSString *str1 = [toBeString substringWithRange:NSMakeRange(i, 1)];
                    BOOL currentIsCN = [str1 pp_is:PPTextFieldStringTypeChinese]; //当前字符是不是中文
                    if (currentIsCN) {
                        totalCount +=2;
                    } else {
                        totalCount +=1;
                    }
#warning pp -2016--10-09
                    // 点击过快，会替换到最后一个字符串，???
                    if (totalCount > _maxCharactersLength) {
                        self.text = [toBeString substringToIndex:i];
                        if (_hasMustInputStr) {
                            [self addMustInputStr:toBeString];
                        }
                        return;
                    }
                }
            }
        }
    }
    
    // 不区分中英文
    if (_maxTextLength > 0) {
        if (!_isPhoneNumber) { // 电话号码时_maxTextLength无效
            if (toBeString.length > _maxTextLength) {
                self.text = [toBeString substringToIndex:_maxTextLength];
            }
        }
    }
    if (_hasMustInputStr) {
        [self addMustInputStr:toBeString];
    }
}

- (void)addMustInputStr:(NSString *)toBeString
{
    if (_hasMustInputStr) {
        if (_mustInputStrAtBegin != NULL) {
            if (self.text.length == 0) {
                toBeString =  [NSString stringWithFormat:@"%@%@", _mustInputStrAtBegin, self.text];
                self.text = toBeString;
            } else if (_mustInputStrAtBegin.length <= self.text.length) {
                if ([[self.text substringToIndex:_mustInputStrAtBegin.length] isEqualToString:_mustInputStrAtBegin] == NO) {
                    toBeString = [NSString stringWithFormat:@"%@%@", _mustInputStrAtBegin, self.text];
                    self.text = toBeString;
                }
            }
        }
    }
}

- (void)deleteMustInputStr:(MEBTextField *)textField
{
    if (_hasMustInputStr) {
        if (textField.text.length != 0) {
            if (_mustInputStrAtBegin != NULL) {
                if (_mustInputStrAtBegin.length <= self.text.length) {
                    if ([[textField.text substringToIndex:_mustInputStrAtBegin.length] isEqualToString:_mustInputStrAtBegin] == YES) {
                        textField.text = [textField.text substringFromIndex:_mustInputStrAtBegin.length];
                    }
                }
            }
            if (_mustInputStrAtEnd != NULL) {
                if (_mustInputStrAtEnd.length <= self.text.length) {
                    if ([[textField.text substringFromIndex:textField.text.length -_mustInputStrAtBegin.length] isEqualToString:_mustInputStrAtEnd] == YES) {
                        textField.text = [textField.text substringToIndex:textField.text.length - _mustInputStrAtEnd.length];
                    }
                }
            }
        }
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (@available(iOS 11.2, *)) {
        NSString *keyPath = @"textContentView.provider";
        @try {
            if (self.window) {
                id provider = [self valueForKeyPath:keyPath];
                if (!provider && self) {
                    [self setValue:self forKeyPath:keyPath];
                }
            } else {
                [self setValue:nil forKeyPath:keyPath];
            }
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
}

- (void)dealloc
{
    NSLog(@"gao de ying - %s", __FUNCTION__);
}

@end
