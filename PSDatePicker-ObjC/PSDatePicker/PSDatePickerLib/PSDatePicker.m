//
//  PSDatePicker.m
//  PSDatePicker
//
//  Created by Pawan Kumar Singh on 26/01/15.
//  Copyright (c) 2015 Pawan Kumar Singh. All rights reserved.
//

#import "PSDatePicker.h"
@interface PSDatePicker() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) NSArray *monthArray;
@end

@implementation PSDatePicker

- (PSDatePicker *)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.monthArray = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
        self.datePickerMode = PSDatePickerModeDateAndTime;
    }
    return self;
}

- (PSDatePicker *)initWithPickerMode : (PSDatePickerMode)pickerMode
{
    switch (pickerMode) {
        case PSDatePickerModeMonthAndYear:
        {
            UIPickerView *picker = [[UIPickerView alloc] init];
            picker.tag = 1002;
            CGRect frame = picker.frame;
            self = [self initWithFrame:frame];
            [self initializeDateComponentsForDate:[NSDate date]];
            _day = 0;
            self.datePickerMode = PSDatePickerModeMonthAndYear;
            picker.dataSource = self;
            picker.delegate = self;
            [picker selectRow:[self currentMonthIndex] inComponent:0 animated:true];
            [picker selectRow:[self currentYearIndex] inComponent:1 animated:true];
            [self addSubview:picker];
        }
            break;
        case PSDatePickerModeDateAndMonth:
        {
            UIPickerView *picker = [[UIPickerView alloc] init];
            picker.tag = 1002;
            CGRect frame = picker.frame;
            self = [self initWithFrame: frame];
            [self initializeDateComponentsForDate:[NSDate date]];
            self.datePickerMode = PSDatePickerModeDateAndMonth;
            _year = 0;
            picker.dataSource = self;
            picker.delegate = self;
            [picker selectRow:[self todayDateIndex] inComponent:0 animated:true];
            [picker selectRow:[self currentMonthIndex] inComponent:1 animated:true];
            [self addSubview:picker];
        }
            break;
        default:
        {
            UIDatePicker *picker = [[UIDatePicker alloc] init];
            CGRect frame = picker.frame;
            self = [self initWithFrame:frame];
            picker.tag = 1002;
            picker.datePickerMode = [self getUIDatePickerMode:pickerMode];
            [self addSubview:picker];
        }
    }
    return self;
}

- (PSDatePicker *)init
{
    self = [self initWithPickerMode:PSDatePickerModeDateAndTime];
    return self;
}

-(NSString *)description
{
    NSMutableString *dateString = [[NSMutableString alloc] initWithString:@""];
    if (self.datePickerMode == PSDatePickerModeDateAndMonth || self.datePickerMode == PSDatePickerModeMonthAndYear)
    {
        if (_year != 0) {
            [dateString appendFormat:@"%04ld", _year];
        }
        if (_month != 0) {
            (dateString.length == 0) ? [dateString appendFormat:@"%02ld", _month] : [dateString appendFormat:@"-%02ld", _month];
        }
        if (_day != 0) {
            (dateString.length == 0) ? [dateString appendFormat:@"%02ld", _day] : [dateString appendFormat:@"-%02ld", _day];
        }
    }else {
        UIDatePicker *datePicker = (UIDatePicker *)[self viewWithTag:1002];
        [dateString appendString:datePicker.date.description];
    }
    return dateString;
}

- (void)initializeDateComponentsForDate: (NSDate *)date
{
    //getting date components for today's date
    NSCalendar *gregorianCalender  = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [gregorianCalender components:flags fromDate:[NSDate date]];
    
    _day = dateComponents.day;
    _month = dateComponents.month;
    _year = dateComponents.year;
    
}

#pragma mark - UIPickerViewDataSource -

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the number of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger number = 0;
    if (self.datePickerMode == PSDatePickerModeDateAndMonth)
    {
        if(component == 0)
        {
            number = [@[@31,@29,@31,@30,@31,@30,@31,@31,@30,@31,@30,@31][_month] integerValue];
        }else
        {
            number = 12;     // 12 months
        }
    }else if (self.datePickerMode == PSDatePickerModeMonthAndYear)
    {
        if(component == 0)
        {
            number = 12;     //12 months
        }else
        {
            number = 10000;  //10000 year. Same as default UIDatePicker if maximum and minimum date is not set
        }
    }
    return number;
}

//
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.datePickerMode == PSDatePickerModeDateAndMonth)
    {
        if(component == 0)
        {
            //Date component is at 0
            _day = row+1;
            
        }else{
            //Month component is at 1
            _month = row+1;
            [pickerView reloadAllComponents];
        }
        
    }else if (self.datePickerMode == PSDatePickerModeMonthAndYear){
        if(component == 0)
        {
            //Month component is at 0
            _month = row+1;
        }else{
            //Year component is at 1
            _year = row+1;
        }
    }
}

//MARK: - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (self.datePickerMode)
    {
        case PSDatePickerModeDateAndMonth:
            return (component == 0) ? [NSString stringWithFormat:@"%2ld",row+1] : self.monthArray[row];
        case PSDatePickerModeMonthAndYear:
            return (component == 0) ? self.monthArray[row] : [NSString stringWithFormat:@"%ld",row+1];
        default:
            return @"";
    }
}

#pragma mark - Helper methods -
- (NSInteger)todayDateIndex
{
    NSCalendar *gregorianCalender  = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [gregorianCalender components:flags fromDate:[NSDate date]];
    return dateComponents.day-1;
}

- (NSInteger)currentMonthIndex
{
    NSCalendar *gregorianCalender  = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [gregorianCalender components:flags fromDate:[NSDate date]];
    return dateComponents.month-1;
}

- (NSInteger)currentYearIndex
{
    NSCalendar *gregorianCalender  = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [gregorianCalender components:flags fromDate:[NSDate date]];
    return dateComponents.year-1;
}

- (UIDatePickerMode)getUIDatePickerMode:(PSDatePickerMode)datePickerMode
{
    switch (datePickerMode) {
        case PSDatePickerModeTime:
            return UIDatePickerModeTime;
        case PSDatePickerModeDate:
            return UIDatePickerModeDate;
        case PSDatePickerModeDateAndTime:
            return UIDatePickerModeDateAndTime;
        case PSDatePickerModeCountDownTimer:
            return UIDatePickerModeCountDownTimer;
        default:
            return UIDatePickerModeDate;
    }
}

// if animated is YES, animate the wheels of time to display the new date
- (void)setDate:(NSDate *)date animated:(BOOL)animate
{
    
}

@end