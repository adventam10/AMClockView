//
//  ViewController.swift
//  SampleAMClock
//
//  Created by am10 on 2018/01/06.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cView1: AMClockView!
    @IBOutlet weak var cView2: AMClockView!
    @IBOutlet weak var cView3: AMClockView!
    @IBOutlet weak var cView4: AMClockView!
    
    @IBOutlet weak var cView5: AMClockView!
    @IBOutlet weak var cView6: AMClockView!
    
    @IBOutlet weak var timeLabel: UILabel!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cView1.delegate = self
        cView2.delegate = self
        cView3.delegate = self
        cView4.delegate = self
        cView5.delegate = self
        cView6.delegate = self
        cView1.timeZone = TimeZone(identifier: "America/Toronto")
        cView2.timeZone = TimeZone(identifier: "Europe/Moscow")
        cView3.timeZone = TimeZone(identifier: "Asia/Tokyo")
        cView4.timeZone = TimeZone(identifier: "GMT")
        cView5.timeZone = TimeZone(identifier: "Africa/Cairo")
        cView6.timeZone = TimeZone(identifier: "Australia/Sydney")
        
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        cView3.selectedDate = dateFormatter.date(from: "2018/01/01 10:10")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: AMClockViewDelegate {
    func clockView(_ clockView: AMClockView, didChangeDate date: Date) {
        if let timeZone = clockView.timeZone {
             dateFormatter.timeZone = timeZone
        }
        timeLabel.text = "selected time: " + dateFormatter.string(from: date);
    }
}
