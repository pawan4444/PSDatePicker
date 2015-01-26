//
//  PSDatePicker.swift
//  SwiftPicker
//
//  Created by Pawan Kumar Singh on 01/11/14.
//  Copyright (c) 2014 Pawan Kumar Singh. All rights reserved.
//

import UIKit

class PSDatePicker : UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    enum PSDatePickerMode : Int {
        
        case Time // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
        case Date // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
        case DateAndTime // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
        case CountDownTimer // Displays hour and minute (e.g. 1 | 53)
        case MonthAndYear   // Displayes month and year (e.g. January | 2015) use case - Credit card expiry
        case DateAndMonth   // Displayes date and month (e.g. 28 | May). Use case - Anniversary
    }

    // default is UIDatePickerModeDateAndTime
    var datePickerMode: PSDatePickerMode

    private let monthArray: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    private var day: Int = 0
    private var month: Int = 0
    private var year: Int = 0
    
    override init(frame: CGRect)
    {
        self.datePickerMode = .DateAndTime
        super.init(frame:frame)
    }
    
    required init(coder aDecoder: NSCoder) {

        self.datePickerMode = .DateAndTime
        super.init(coder: aDecoder)
    }
    
    convenience init(datePickerMode pickerMode: PSDatePickerMode)
    {
        switch pickerMode {
        case .MonthAndYear:
            
            var picker: UIPickerView = UIPickerView()
            picker.tag = 1002
            var frame: CGRect = picker.frame
            self.init(frame: frame)
            initialiseDateComponents(NSDate())
            day = 0
            self.datePickerMode = .MonthAndYear
            picker.dataSource = self
            picker.delegate = self
            picker.selectRow(currentMonthIndex(), inComponent: 0, animated: true)
            picker.selectRow(currentYearIndex(), inComponent: 1, animated: true)
            self.addSubview(picker)
            
        case .DateAndMonth:

            var picker: UIPickerView = UIPickerView()
            picker.tag = 1002
            var frame: CGRect = picker.frame
            self.init(frame: frame)
            initialiseDateComponents(NSDate())
            self.datePickerMode = .DateAndMonth
            year = 0
            picker.dataSource = self
            picker.delegate = self
            picker.selectRow(todayDateIndex(), inComponent: 0, animated: true)
            picker.selectRow(currentMonthIndex(), inComponent: 1, animated: true)
            self.addSubview(picker)
            
        default:
            
            var picker: UIDatePicker = UIDatePicker()
            var frame: CGRect = picker.frame
            self.init(frame: frame)
            picker.tag = 1002
            picker.datePickerMode = getUIDatePickerMode(pickerMode)
            self.addSubview(picker)
        }
    }
    
    convenience override init()
    {
        self.init(datePickerMode: .DateAndTime)
    }
    
    func description() -> String
    {
        var dateString = ""
        if self.datePickerMode == .DateAndMonth || self.datePickerMode == .MonthAndYear
        {
            if year != 0 {
                dateString += (dateString == "") ? "\(year)" : "-\(year)"
            }
            if month != 0 {
                var monthString: String = (month < 10) ? "0\(month)" : "\(month)"
                dateString += (dateString == "") ? monthString : "-\(monthString)"
            }
            if day != 0 {
                var dayString: String = (day < 10) ? "0\(day)" : "\(day)"
                dateString += (dateString == "") ? dayString : "-\(dayString)"
            }
            

        }else {
            var datePicker: UIDatePicker = self.viewWithTag(1002) as UIDatePicker
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            dateString = datePicker.date.description
        }
        return dateString
    }
    
    func initialiseDateComponents(date: NSDate!){

        //getting date components for today's date
        let gregorianCalender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let flags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay
        let dateComponents: NSDateComponents = gregorianCalender.components(flags, fromDate: NSDate())
        
        day = dateComponents.day
        month = dateComponents.month
        year = dateComponents.year

    }
    //MARK: - UIPickerViewDataSource
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 2
    }
    
    // returns the number of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        var number: Int = 0
        if self.datePickerMode == .DateAndMonth
        {
            if component == 0
            {
                number = [31,29,31,30,31,30,31,31,30,31,30,31][month]
            }else
            {
                number = 12     // 12 months
            }
        }else if self.datePickerMode == .MonthAndYear
        {
            if component == 0
            {
                number = 12     //12 months
            }else
            {
                number = 10000  //10000 year. Same as default UIDatePicker if maximum and minimum date is not set
            }
        }
        return number
    }

    //
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){

        if self.datePickerMode == .DateAndMonth
        {
            if(component == 0)
            {
                //Date component is at 0
                day = row+1
                
            }else{
                //Month component is at 1
                month = row+1
                pickerView.reloadAllComponents()
            }
            
        }else if (self.datePickerMode == .MonthAndYear){
            if(component == 0)
            {
                //Month component is at 0
                month = row+1
            }else{
                //Year component is at 1
                year = row+1
            }

        }
    }
    
    //MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        switch self.datePickerMode {
            
        case .DateAndMonth:
            return component == 0 ? "\(row+1)" : self.monthArray[row]
        case .MonthAndYear:
            return component == 0 ? self.monthArray[row] : "\(row+1)"
        default:
            return ""
        }
    }
    
    //MARK: - Helper methods
    func todayDateIndex() -> Int
    {
        let gregorianCalender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let flags: NSCalendarUnit = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth
        let dateComponents: NSDateComponents = gregorianCalender.components(flags, fromDate: NSDate())
        return dateComponents.day-1
    }
    
    func currentMonthIndex() -> Int
    {
        let gregorianCalender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let flags: NSCalendarUnit = NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear
        let dateComponents: NSDateComponents = gregorianCalender.components(flags, fromDate: NSDate())
        return dateComponents.month-1
    }
    
    func currentYearIndex() -> Int
    {
        let gregorianCalender: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let flags: NSCalendarUnit = NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear
        let dateComponents: NSDateComponents = gregorianCalender.components(flags, fromDate: NSDate())
        return dateComponents.year-1
    }
    
    func getUIDatePickerMode(datePickerMode: PSDatePickerMode) -> UIDatePickerMode {
        switch (datePickerMode) {
        case .Time:
            return UIDatePickerMode.Time
        case .Date:
            return UIDatePickerMode.Date
        case .DateAndTime:
            return UIDatePickerMode.DateAndTime
        case .CountDownTimer:
            return UIDatePickerMode.CountDownTimer
        default:
            return UIDatePickerMode.Date
        }
    }
    
    // if animated is YES, animate the wheels of time to display the new date
    func setDate(date: NSDate, animated: Bool){
        
    }

}