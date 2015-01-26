//
//  ViewController.swift
//  PSDatePicker
//
//  Created by Pawan Kumar Singh on 17/01/15.
//  Copyright (c) 2015 Pawan Kumar Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dateMonthPicker: PSDatePicker? = nil
    var monthYearPicker: PSDatePicker? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Date And Month - Ideal for anniversary
        dateMonthPicker = PSDatePicker(datePickerMode: .DateAndMonth)
        dateMonthPicker?.center = CGPointMake(self.view.center.x, self.view.center.y-150.0)
        self.view.addSubview(dateMonthPicker!)
        
        //Month and Year - Ideal for Card or service Expiry
        monthYearPicker = PSDatePicker(datePickerMode: .MonthAndYear)
        monthYearPicker?.center = CGPointMake(self.view.center.x, self.view.center.y+150.0)
        self.view.addSubview(monthYearPicker!)
        
        let nextButton:UIButton = UIButton.buttonWithType(.Custom) as UIButton
        nextButton.frame = CGRect(x: 0, y: 0, width: 280, height: 34)
        nextButton.center = self.view.center
        nextButton.backgroundColor = UIColor(red: 0.10, green: 0.423, blue: 0.17, alpha: 1.0)
        nextButton.setTitle("Print Date", forState: .Normal)
        nextButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        nextButton.addTarget(self, action: "printDateButton_Action:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(nextButton)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIButton Action -
    func printDateButton_Action(sender: UIButton!) {
        NSLog(dateMonthPicker!.description)
        NSLog(monthYearPicker!.description)
    }
}


