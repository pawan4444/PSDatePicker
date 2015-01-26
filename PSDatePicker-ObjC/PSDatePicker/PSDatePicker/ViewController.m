//
//  ViewController.m
//  PSDatePicker
//
//  Created by Pawan Kumar Singh on 17/01/15.
//  Copyright (c) 2015 Pawan Kumar Singh. All rights reserved.
//

#import "ViewController.h"
#import "PSDatePicker.h"

@interface ViewController ()
@property (nonatomic, strong) PSDatePicker *dateMonthPicker;
@property (nonatomic, strong) PSDatePicker *monthYearPicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Date And Month - Ideal for anniversary
    _dateMonthPicker = [[PSDatePicker alloc] initWithPickerMode:PSDatePickerModeDateAndMonth];
    _dateMonthPicker.center = CGPointMake(self.view.center.x, self.view.center.y-150.0);
    [self.view addSubview:_dateMonthPicker];
    
    //Month and Year - Ideal for Card or service Expiry
    _monthYearPicker = [[PSDatePicker alloc] initWithPickerMode:PSDatePickerModeMonthAndYear];
    _monthYearPicker.center = CGPointMake(self.view.center.x, self.view.center.y+150.0);
    [self.view addSubview:_monthYearPicker];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, 280, 34);
    nextButton.center = self.view.center;
    nextButton.backgroundColor = [UIColor colorWithRed: 0.10 green: 0.423 blue: 0.17 alpha: 1.0];
    [nextButton setTitle:@"Print Date" forState: UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    [nextButton addTarget:self action:@selector(printDateButton_Action:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)printDateButton_Action:(UIButton *)sender
{
    NSLog(@"%@",[_dateMonthPicker description]);
    NSLog(@"%@",[_monthYearPicker description]);
}

- (void)dealloc {
    self.dateMonthPicker = nil;
    self.monthYearPicker = nil;
}
@end
