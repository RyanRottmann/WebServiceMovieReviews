//
//  SettingsViewController.swift
//  Movie Reviews
//
//  Created by Ryan on 11/13/19.
//  Copyright © 2019 Tech Innovator. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    
    @IBOutlet weak var criticsPickSwitch: UISwitch!
    @IBOutlet weak var dateFilterSwitch: UISwitch!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    @IBOutlet weak var disableEndDateSwitch: UISwitch!
    
    
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {//occurs first
        super.viewDidLoad()
        if(firstLoad == 0){
            criticsPickSwitch.isOn = false
            dateFilterSwitch.isOn = false
            disableEndDateSwitch.isOn = false
            firstLoad += 1
            print("firstLoad")
            criticsPickVariable = "n"
        }else{
            criticsPickSwitch.isOn = criticsPickHolder
            dateFilterSwitch.isOn = dateFilterHolder
            disableEndDateSwitch.isOn = disableEndDateHolder
        }
        print(firstLoad)
        print(startDateHolder)
        print(endDateHolder)

        
        dateFormatter.dateFormat = "yyyy-dd-MM"
        
        
//        startDateText = dateFormatter.string(from: startDateHolder)
//        endDateText = dateFormatter.string(from: endDateHolder)
        
        print(startDateText)
        print(endDateText)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {//occurs second
        if (firstLoad == 1){
            firstLoad += 1
        } else {
            startDate.date = startDateHolder
            endDate.date = endDateHolder
        }
        
        print(startDateHolder)
        print(endDateHolder)
        criticsPickSwitch.isOn = criticsPickHolder
        dateFilterSwitch.isOn = dateFilterHolder
        disableEndDateSwitch.isOn = disableEndDateHolder
        if (dateFilterHolder == false){
            startDate.isEnabled = false
            endDate.isEnabled = false
            disableEndDateSwitch.isEnabled = false
        } else {
            startDate.isEnabled = true
            endDate.isEnabled = true
            disableEndDateSwitch.isEnabled = true
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {//occurs third
        
        print(startDateHolder)
        print(endDateHolder)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        criticsPickHolder = criticsPickSwitch.isOn
        dateFilterHolder = dateFilterSwitch.isOn
        disableEndDateHolder = disableEndDateSwitch.isOn
        startDateHolder = startDate.date
        endDateHolder = endDate.date
    }
    
    @IBAction func criticsPickSwitchPressed(_ sender: Any) {
            //print("Switch Pressed")
        if(criticsPickSwitch.isOn == true){
            criticsPickVariable = "y"
            //print("ShouldBeYes")
            print(criticsPickVariable)
        } else{
            criticsPickVariable = "n"
            //print("ShouldBeNo")
            //print(criticsPickVariable)
        }
    }

    @IBAction func dateFilterSwitchPressed(_ sender: Any) {
        dateFilterHolder = dateFilterSwitch.isOn
        startDateHolder = startDate.date
        endDateHolder = endDate.date
        startDateText = dateFormatter.string(from: startDateHolder)
        endDateText = dateFormatter.string(from: endDateHolder)
        
        if (dateFilterHolder == false){
            startDate.isEnabled = false
            endDate.isEnabled = false
            disableEndDateSwitch.isEnabled = false
        } else {
            startDate.isEnabled = true
            endDate.isEnabled = true
            disableEndDateSwitch.isEnabled = true
            if(disableEndDateHolder == true){
                endDate.isEnabled = false
            } else {
                endDate.isEnabled = true
            }
        }
    }
    
    @IBAction func disableEndDateSwitchPressed(_ sender: Any) {
        disableEndDateHolder = disableEndDateSwitch.isOn
        if(disableEndDateHolder == true){
            endDate.isEnabled = false
        } else {
            endDate.isEnabled = true
        }
        
    }
    
    
    @IBAction func moviesAfterThisDateChanged(_ sender: Any) {
        startDateHolder = startDate.date
        print(startDate.date)
        print(startDateHolder)

        startDateText = dateFormatter.string(from: startDateHolder)
        print(startDateText)
        
    }
    @IBAction func moviesBeforeThisDateChanged(_ sender: Any) {
        endDateHolder = endDate.date
        print(endDateHolder)
        
        
        endDateText = dateFormatter.string(from: endDateHolder)
        print(endDateText)
    }
    
}
