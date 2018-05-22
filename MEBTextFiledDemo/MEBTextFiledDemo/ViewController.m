//
//  ViewController.m
//  MEBTextFiledDemo
//
//  Created by 搞得赢 on 2018/5/2.
//  Copyright © 2018年 德赢工作室. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpHideKeyBoard];
    [self setUpTF1];
    [self setUpTF2];
    [self setUpTF3];
    [self setUpTF4];
    [self setUpTF5];
}

- (void)setUpHideKeyBoard
{
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gr];
}

- (void)hideKeyboard
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.view endEditing:YES];
    }];
}

- (void)setUpTF1
{
    self.tf1.canInputMinusWhenPrice = NO;
    self.tf1.isPrice = YES;
}

- (void)setUpTF2
{
    self.tf2.canInputMinusWhenPrice = YES;
    self.tf2.isPrice = YES;
}

- (void)setUpTF3
{
    self.tf3.canInputMinusWhenPrice = YES;
    self.tf3.isPrice = YES;
    self.tf3.maxPrice = 999999;
    self.tf3.minPrice = - 999;
}

- (void)setUpTF4
{
    self.tf4.canInputMinusWhenPrice = YES;
    self.tf4.isPrice = YES;
    self.tf4.maxPrice = 999999;
    self.tf4.minPrice = - 999;
    self.tf4.mustInputStrAtBegin = @"$";
}

- (void)setUpTF5
{
    self.tf5.canInputMinusWhenPrice = YES;
    self.tf5.isPrice = YES;
    self.tf5.maxPrice = 999999;
    self.tf5.minPrice = - 999;
    self.tf5.mustInputStrAtEnd = @"元";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
