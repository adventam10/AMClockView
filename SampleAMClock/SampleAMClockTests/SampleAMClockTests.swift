//
//  SampleAMClockTests.swift
//  SampleAMClockTests
//
//  Created by am10 on 2019/10/12.
//  Copyright © 2019 am10. All rights reserved.
//

import XCTest
@testable import SampleAMClock

class SampleAMClockTests: XCTestCase {

    private let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.locale = .init(identifier: "ja_JP")
        df.dateFormat = "yyyyMMddHHmmss"
        return df
    }()
    private let accuracy: Float = 0.00001
    private let anglePerMinute = Float((2 * Double.pi) / 60)
    private let anglePerHour = Float((2 * Double.pi) / 12)
    private let angle270 = Float(Double.pi/2 + Double.pi)
    private let radius: CGFloat = 1.0
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurrentMinuteAngle() {
        let model = AMClockModel()
        model.currentDate = dateFormatter.date(from: "20191210120000")!
        XCTAssertEqual(cosf(model.currentMinuteAngle), 0.0, accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191210121500")!
        XCTAssertEqual(cosf(model.currentMinuteAngle), 1.0, accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191210123000")!
        XCTAssertEqual(cosf(model.currentMinuteAngle), 0.0, accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191210124500")!
        XCTAssertEqual(cosf(model.currentMinuteAngle), -1.0, accuracy: accuracy)
        
        model.currentDate = dateFormatter.date(from: "20191215121300")!
        XCTAssertEqual(cosf(model.currentMinuteAngle), cosf(angle270 + anglePerMinute*13), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191215122200")!
        XCTAssertEqual(cosf(model.currentMinuteAngle), cosf(angle270 + anglePerMinute*22), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191215123600")!
        XCTAssertEqual(cosf(model.currentMinuteAngle), cosf(angle270 + anglePerMinute*36), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191215125200")!
        XCTAssertEqual(cosf(model.currentMinuteAngle), cosf(angle270 + anglePerMinute*52), accuracy: accuracy)
    }
    
    func testCurrentHourAngle() {
        let model = AMClockModel()
        model.currentDate = dateFormatter.date(from: "20191210120000")!
        XCTAssertEqual(cosf(model.currentHourAngle), 0.0, accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191210030000")!
        XCTAssertEqual(cosf(model.currentHourAngle), 1.0, accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191210060000")!
        XCTAssertEqual(cosf(model.currentHourAngle), 0.0, accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191210090000")!
        XCTAssertEqual(cosf(model.currentHourAngle), -1.0, accuracy: accuracy)
        
        model.currentDate = dateFormatter.date(from: "20191215010000")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(angle270 + anglePerHour*1), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191215040000")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(angle270 + anglePerHour*4), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191215070000")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(angle270 + anglePerHour*7), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191215110000")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(angle270 + anglePerHour*11), accuracy: accuracy)
        
        model.currentDate = dateFormatter.date(from: "20191210124040")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(reviseAngle(Float(Double.pi/2 + Double.pi), byMinute: 40)), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191210031540")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(reviseAngle(0, byMinute: 15)), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191210063040")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(reviseAngle(Float(Double.pi/2), byMinute: 30)), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191210094540")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(reviseAngle(Float(Double.pi), byMinute: 45)), accuracy: accuracy)
        
        model.currentDate = dateFormatter.date(from: "20191215021325")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(reviseAngle(angle270 + anglePerHour*2, byMinute: 13)), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191215052230")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(reviseAngle(angle270 + anglePerHour*5, byMinute: 22)), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191215073655")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(reviseAngle(angle270 + anglePerHour*7, byMinute: 36)), accuracy: accuracy)
        model.currentDate = dateFormatter.date(from: "20191215115244")!
        XCTAssertEqual(cosf(model.currentHourAngle), cosf(reviseAngle(angle270 + anglePerHour*11, byMinute: 52)), accuracy: accuracy)
    }
    
    func testFormattedTime() {
        let model = AMClockModel()
        model.currentDate = dateFormatter.date(from: "20191210123322")!
        XCTAssertEqual(model.formattedTime, "12:33")
    }
    
    func testCurrentMinute() {
        let model = AMClockModel()
        model.currentDate = dateFormatter.date(from: "20191210120022")!
        XCTAssertEqual(model.currentMinute, 0)
        model.currentDate = dateFormatter.date(from: "20191210121522")!
        XCTAssertEqual(model.currentMinute, 15)
        model.currentDate = dateFormatter.date(from: "20191210123022")!
        XCTAssertEqual(model.currentMinute, 30)
        model.currentDate = dateFormatter.date(from: "20191210124522")!
        XCTAssertEqual(model.currentMinute, 45)
        
        model.currentDate = dateFormatter.date(from: "20191210121222")!
        XCTAssertEqual(model.currentMinute, 12)
        model.currentDate = dateFormatter.date(from: "20191210122222")!
        XCTAssertEqual(model.currentMinute, 22)
        model.currentDate = dateFormatter.date(from: "20191210123722")!
        XCTAssertEqual(model.currentMinute, 37)
        model.currentDate = dateFormatter.date(from: "20191210125322")!
        XCTAssertEqual(model.currentMinute, 53)
    }
    
    func testUpdateCurrentDateWithMinuteMethod() {
        let model = AMClockModel()
        model.currentDate = dateFormatter.date(from: "20191210120022")!
        model.updateCurrentDate(minute: 30)
        XCTAssertEqual(model.currentDate, dateFormatter.date(from: "20191210123022"))
        model.currentDate = dateFormatter.date(from: "20191210120022")!
        model.updateCurrentDate(minute: 65)
        XCTAssertEqual(model.currentDate, dateFormatter.date(from: "20191210130522"))
    }
    
    func testAppendHourMethod() {
        let model = AMClockModel()
        model.currentDate = dateFormatter.date(from: "20191210120022")!
        model.appendHour(1)
        XCTAssertEqual(model.currentDate, dateFormatter.date(from: "20191210130022"))
        model.currentDate = dateFormatter.date(from: "20191210120022")!
        model.appendHour(-1)
        XCTAssertEqual(model.currentDate, dateFormatter.date(from: "20191210110022"))
    }
    
    func testCalculateHourAngleWithPointMethod() {
        let model = AMClockModel()
        model.currentDate = dateFormatter.date(from: "20191210120000")!
        var angle = model.calculateHourAngle(point: .init(x: radius, y: 0.0), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270), accuracy: accuracy)
        angle = model.calculateHourAngle(point: .init(x: radius*2, y: radius), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 3), accuracy: accuracy)
        angle = model.calculateHourAngle(point: .init(x: radius, y: radius*2), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 6), accuracy: accuracy)
        angle = model.calculateHourAngle(point: .init(x: 0.0, y: radius), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 9), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 1), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 2), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 3), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 4), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 6), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 1), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 7), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 1), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 8), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 1), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 9), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 1), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 11), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 2), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 12), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 2), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 13), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 2), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 14), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 2), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 16), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 3), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 17), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 3), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 18), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 3), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 19), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 3), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 21), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 4), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 22), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 4), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 23), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 4), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 24), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 4), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 26), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 5), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 27), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 5), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 28), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 5), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 29), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 5), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 31), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 6), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 32), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 6), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 33), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 6), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 34), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 6), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 36), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 7), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 37), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 7), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 38), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 7), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 39), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 7), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 41), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 8), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 42), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 8), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 43), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 8), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 44), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 8), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 46), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 9), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 47), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 9), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 48), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 9), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 49), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 9), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 51), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 10), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 52), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 10), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 53), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 10), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 54), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 10), accuracy: accuracy)
        
        angle = model.calculateHourAngle(point: point(minute: 56), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 11), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 57), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 11), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 58), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 11), accuracy: accuracy)
        angle = model.calculateHourAngle(point: point(minute: 59), radius: radius)
        XCTAssertEqual(cosf(angle), cosf(angle270 + anglePerHour * 11), accuracy: accuracy)
    }
    
    func testCalculateMinuteWithPointMethod() {
        let model = AMClockModel()
        XCTAssertEqual(model.calculateMinute(point: .init(x: radius, y: 0.0), radius: radius), 0)
        XCTAssertEqual(model.calculateMinute(point: .init(x: radius*2, y: radius), radius: radius), 15)
        XCTAssertEqual(model.calculateMinute(point: .init(x: radius, y: radius*2), radius: radius), 30)
        XCTAssertEqual(model.calculateMinute(point: .init(x: 0.0, y: radius), radius: radius), 45)
 
        XCTAssertEqual(model.calculateMinute(point: point(minute: 1), radius: radius), 1)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 2), radius: radius), 2)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 3), radius: radius), 3)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 4), radius: radius), 4)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 5), radius: radius), 5)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 6), radius: radius), 6)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 7), radius: radius), 7)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 8), radius: radius), 8)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 9), radius: radius), 9)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 10), radius: radius), 10)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 11), radius: radius), 11)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 12), radius: radius), 12)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 13), radius: radius), 13)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 14), radius: radius), 14)
        
        XCTAssertEqual(model.calculateMinute(point: point(minute: 16), radius: radius), 16)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 17), radius: radius), 17)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 18), radius: radius), 18)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 19), radius: radius), 19)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 20), radius: radius), 20)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 21), radius: radius), 21)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 22), radius: radius), 22)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 23), radius: radius), 23)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 24), radius: radius), 24)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 25), radius: radius), 25)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 26), radius: radius), 26)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 27), radius: radius), 27)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 28), radius: radius), 28)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 29), radius: radius), 29)
        
        XCTAssertEqual(model.calculateMinute(point: point(minute: 31), radius: radius), 31)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 32), radius: radius), 32)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 33), radius: radius), 33)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 34), radius: radius), 34)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 35), radius: radius), 35)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 36), radius: radius), 36)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 37), radius: radius), 37)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 38), radius: radius), 38)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 39), radius: radius), 39)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 40), radius: radius), 40)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 41), radius: radius), 41)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 42), radius: radius), 42)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 43), radius: radius), 43)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 44), radius: radius), 44)
        
        XCTAssertEqual(model.calculateMinute(point: point(minute: 46), radius: radius), 46)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 47), radius: radius), 47)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 48), radius: radius), 48)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 49), radius: radius), 49)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 50), radius: radius), 50)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 51), radius: radius), 51)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 52), radius: radius), 52)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 53), radius: radius), 53)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 54), radius: radius), 54)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 55), radius: radius), 55)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 56), radius: radius), 56)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 57), radius: radius), 57)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 58), radius: radius), 58)
        XCTAssertEqual(model.calculateMinute(point: point(minute: 59), radius: radius), 59)
    }
    
    func testRevisedByAcrossHourWithStartAngleMethod() {
        let model = AMClockModel()
        model.currentDate = dateFormatter.date(from: "20191210120022")!
        model.revisedByAcrossHour(startAngle: anglePerMinute * 55,
                                  endAngle: anglePerMinute * 5)
        XCTAssertEqual(model.currentDate, dateFormatter.date(from: "20191210130022"))
        model.currentDate = dateFormatter.date(from: "20191210120022")!
        model.revisedByAcrossHour(startAngle: anglePerMinute * 5,
                                  endAngle: anglePerMinute * 55)
        XCTAssertEqual(model.currentDate, dateFormatter.date(from: "20191210110022"))
    }
    
    func testCalculateElapsedTimeWithStartAngleMethod() {
        let model = AMClockModel()
        var hour = model.calculateElapsedTime(startAngle: anglePerMinute * 5,
                                              endAngle: anglePerMinute * 10)
        XCTAssertEqual(hour, 1)
        hour = model.calculateElapsedTime(startAngle: anglePerMinute * 5,
                                          endAngle: anglePerMinute * 8)
        XCTAssertEqual(hour, 0)
        hour = model.calculateElapsedTime(startAngle: anglePerMinute * 10,
                                          endAngle: anglePerMinute * 5)
        XCTAssertEqual(hour, -1)
        hour = model.calculateElapsedTime(startAngle: anglePerMinute * 8,
                                          endAngle: anglePerMinute * 5)
        XCTAssertEqual(hour, 0)
        hour = model.calculateElapsedTime(startAngle: anglePerMinute * 55,
                                          endAngle: anglePerMinute * 1)
        XCTAssertEqual(hour, 1)
        hour = model.calculateElapsedTime(startAngle: anglePerMinute * 5,
                                          endAngle: anglePerMinute * 59)
        XCTAssertEqual(hour, -1)
    }
    
    private func reviseAngle(_ angle: Float, byMinute minute: Float) -> Float {
        return angle + (minute / 60.0) * anglePerHour
    }
    
    private func angle(minute: Int) -> CGFloat {
        let angle = (Float(minute) + 0.001) * anglePerMinute + angle270
        return CGFloat(angle)
    }

    private func point(minute: Int) -> CGPoint {
        return .init(x: radius + cos(angle(minute: minute)) * radius,
                     y: radius + sin(angle(minute: minute)) * radius)
    }
}
