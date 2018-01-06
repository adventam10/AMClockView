//
//  ViewController.swift
//  SampleAMClock
//
//  Created by am10 on 2018/01/06.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AMClockViewDelegate {
    
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

        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        cView6.selectedDate = dateFormatter.date(from: "2018/01/01 10:10")
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func clockView(clockView: AMClockView, didChangeDate date: Date) {
        
        timeLabel.text = dateFormatter.string(from: date);
    }
}

