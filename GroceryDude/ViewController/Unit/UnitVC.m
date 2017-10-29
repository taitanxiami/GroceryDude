//
//  UnitVC.m
//  GroceryDude
//
//  Created by dianda on 2017/10/29.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "UnitVC.h"

@interface UnitVC ()<UITextFieldDelegate>

@end

@implementation UnitVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideKeyBoardWhenBackgroundIsTapped];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshInterface];
    [self.nameTextField becomeFirstResponder];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    [cdh saveContext];
}

 -(void)refreshInterface {
     
     CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
     
     //如果在缓存中存在数据对象，就返回，或者返回错误
     Unit *unit = [cdh.context  existingObjectWithID:self.selectedID error:nil];
     self.nameTextField.text = unit.name;
 }

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}

- (void)hideKeyBoardWhenBackgroundIsTapped {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)done:(id)sender {
    
    [self hideKeyBoard];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    CoreDataHelper *cdh = [(AppDelegate *)[UIApplication sharedApplication].delegate cdh];
    
    //如果在缓存中存在数据对象，就返回，或者返回错误
    Unit *unit = [cdh.context  existingObjectWithID:self.selectedID error:nil];
    
    if (textField == self.nameTextField) {
        unit.name = self.nameTextField.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
