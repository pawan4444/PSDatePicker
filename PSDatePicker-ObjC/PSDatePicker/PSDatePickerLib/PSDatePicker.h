//
//  PSDatePicker.h
//  PSDatePicker
//
//  Created by Pawan Kumar Singh on 26/01/15.
//  Copyright (c) 2015 Pawan Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PSDatePickerMode)
{
    PSDatePickerModeTime,   // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    PSDatePickerModeDate,   // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    PSDatePickerModeDateAndTime, // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    PSDatePickerModeCountDownTimer, // Displays hour and minute (e.g. 1 | 53)
    PSDatePickerModeMonthAndYear,   // Displayes month and year (e.g. January | 2015) use case - Credit card expiry
    PSDatePickerModeDateAndMonth,   // Displayes date and month (e.g. 28 | May). Use case - Anniversary
    
};

@interface PSDatePicker : UIView

@property (nonatomic, assign) PSDatePickerMode datePickerMode;     // default is UIDatePickerModeDateAndTime

- (PSDatePicker *)initWithPickerMode : (PSDatePickerMode)pickerMode;
@end
