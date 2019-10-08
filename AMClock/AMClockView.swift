//
//  AMClockView.swift
//  AMClockView, https://github.com/adventam10/AMClockView
//
//  Created by am10 on 2017/12/29.
//  Copyright © 2017年 am10. All rights reserved.
//

import UIKit

public enum AMCVTimeEditType{
    case none
    case hour
    case minute
}

public enum AMCVClockType {
    case none
    case arabic
    case roman
    
    var times: [String] {
        switch self {
        case .none:
            return []
        case .arabic:
            return ["12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
        case .roman:
            return []
//            return ["Ⅻ", "Ⅰ", "Ⅱ", "Ⅲ", "Ⅳ", "Ⅴ", "Ⅵ", "Ⅶ", "Ⅷ", "Ⅸ", "Ⅹ", "Ⅺ"]
        }
    }
    
    func time(index: Int) -> String {
        switch self {
        case .none:
            return ""
        case .arabic:
            return times[index]
        case .roman:
            return ""
        }
    }
}

public protocol AMClockViewDelegate: AnyObject {
    func clockView(_ clockView: AMClockView, didChangeDate date: Date)
}

private class AMClockModel {
    
    enum AMCVDateFormat: String {
        case hour = "HH"
        case minute = "mm"
        case time = "HH:mm"
    }
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        return df
    }()
    let angle270 = Float(Double.pi + Double.pi/2)
    let angle360 = Float(Double.pi * 2)
    let angle30 = Float(Double.pi / 6)
    
    //MARK: - Calculate
    func calculateHourAngle(radian: Float) -> Float {
        let hour = (radian - angle270) / (angle360 / 12)
        let angle = (angle360 / 12) * Float(Int(hour))
        return angle + angle270
    }
    
    func caluculateMinuteAngle(radian: Float) -> Float {
        let minute = (radian - angle270) / (angle360 / 60)
        let angle = (angle360 / 60) * Float(Int(minute))
        return angle + angle270
    }
    
    func calculateRadian(point: CGPoint, radius: CGFloat) -> Float {
        // origin(view's center)
        let centerPoint = CGPoint(x: radius, y: radius)
        
        // Find difference in coordinates.Since the upper side of the screen is the Y coordinate +, the Y coordinate changes the sign.
        let x = Float(point.x - centerPoint.x)
        let y = -Float(point.y - centerPoint.y)
        
        var radian = atan2f(y, x)
        
        // To correct radian(3/2π~7/2π: 0 o'clock = 3/2π)
        radian = radian * -1
        if radian < 0 {
            radian += angle360
        }
        
        if radian >= 0 && radian < angle270 {
            radian += angle360
        }
        return radian
    }
    
    func caluculateAngle(minute: String) -> Float {
        let angle = (angle360 / 60) * Float(minute)!
        return angle + angle270
    }
    
    func caluculateAngle(hour: String) -> Float {
        var hourInt = Int(hour)!
        if hourInt > 12 {
            hourInt -= 12
        }
        
        let angle = (angle360 / 12) * Float(hourInt)
        return angle + angle270
    }
    
    func compensationHourAngle(date: Date) -> Float {
        let hourAngle = caluculateAngle(hour: hour(for: date))
        let minuteInt = Int(minute(for: date))!
        return hourAngle + ((Float(minuteInt)/60.0) * angle30)
    }
    
    func adjustFont(rect: CGRect) -> UIFont {
        let length = (rect.width > rect.height) ? rect.height : rect.width
        return .systemFont(ofSize: length * 0.8)
    }
    
    func minute(for date: Date) -> String {
        dateFormatter.dateFormat = AMCVDateFormat.minute.rawValue
        return dateFormatter.string(from: date)
    }
    
    func hour(for date: Date) -> String {
        dateFormatter.dateFormat = AMCVDateFormat.hour.rawValue
        return dateFormatter.string(from: date)
    }
    
    func time(for date: Date) -> String {
        dateFormatter.dateFormat = AMCVDateFormat.time.rawValue
        return dateFormatter.string(from: date)
    }
}

@IBDesignable public class AMClockView: UIView {
    
    @IBInspectable public var clockBorderLineWidth: CGFloat = 5.0
    @IBInspectable public var smallClockIndexWidth: CGFloat = 1.0
    @IBInspectable public var clockIndexWidth: CGFloat = 2.0
    @IBInspectable public var hourHandWidth: CGFloat = 5.0
    @IBInspectable public var minuteHandWidth: CGFloat = 3.0
    @IBInspectable public var clockBorderLineColor: UIColor = .black
    @IBInspectable public var centerCircleLineColor: UIColor = .darkGray
    @IBInspectable public var hourHandColor: UIColor = .black
    @IBInspectable public var minuteHandColor: UIColor = .black
    @IBInspectable public var selectedTimeLabelTextColor: UIColor = .black
    @IBInspectable public var timeLabelTextColor: UIColor = .black
    @IBInspectable public var smallClockIndexColor: UIColor = .black
    @IBInspectable public var clockIndexColor: UIColor = .black
    @IBInspectable public var clockColor: UIColor = .clear
    @IBInspectable public var clockImage: UIImage?
    @IBInspectable public var minuteHandImage: UIImage?
    @IBInspectable public var hourHandImage: UIImage?
    @IBInspectable public var isShowSelectedTime: Bool = false {
        didSet {
            selectedTimeLabel.isHidden = !isShowSelectedTime
        }
    }
    
    public weak var delegate: AMClockViewDelegate?
    /// watch dials
    public var clockType: AMCVClockType = .arabic
    public var selectedDate: Date? {
        didSet{
            currentDate = selectedDate ?? Date()
            redrawClock()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            redrawClock()
        }
    }
    
    private let clockSpace: CGFloat = 10
    private let clockView = UIView()
    private let clockImageView = UIImageView()
    private let minuteHandImageView = UIImageView()
    private let hourHandImageView = UIImageView()
    private let selectedTimeLabel = UILabel()
    private let calendar = Calendar(identifier: .gregorian)
    private let model = AMClockModel()
    
    private var drawLayer: CAShapeLayer?
    private var hourHandLayer: CAShapeLayer?
    private var minuteHandLayer: CAShapeLayer?
    private var panHourLayer: CAShapeLayer?
    private var panMinuteLayer: CAShapeLayer?
    private var editType: AMCVTimeEditType = .none
    private var startAngle: Float = 0.0
    private var endAngle: Float = 0.0
    private var currentDate = Date()
    private var radius: CGFloat {
        return clockView.frame.width/2
    }
    private var clockCenter: CGPoint {
        return CGPoint(x: radius, y: radius)
    }
    private var hourHandLength: CGFloat {
        return radius * 0.6
    }
    private var minuteHandLength: CGFloat {
        return radius * 0.8
    }
    
    //MARK: - Initialize
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override public func draw(_ rect: CGRect) {
        redrawClock()
    }
    
    //MARK: - Prepare View
    private func prepareClockView() {
        var length = (frame.width < frame.height) ? frame.width : frame.height
        length -= clockSpace*2
        clockView.frame = CGRect(x: frame.width/2 - length/2,
                                 y: frame.height/2 - length/2,
                                 width: length, height: length)
        addSubview(clockView)
    }
    
    private func prepareClockImageViews() {
        clockImageView.frame = clockView.bounds
        minuteHandImageView.frame = clockView.bounds
        hourHandImageView.frame = clockView.bounds
        
        clockImageView.image = clockImage
        minuteHandImageView.image = minuteHandImage
        hourHandImageView.image = hourHandImage
        
        clockView.addSubview(clockImageView)
        clockView.addSubview(hourHandImageView)
        clockView.addSubview(minuteHandImageView)
    }
    
    private func prepareSelectedTimeLabel() {
        selectedTimeLabel.frame = CGRect(x: clockCenter.x - (radius/2)/2,
                                         y: clockCenter.y - radius/3,
                                         width: radius/2, height: radius/3)
        clockView.addSubview(selectedTimeLabel)
        selectedTimeLabel.font = model.adjustFont(rect: selectedTimeLabel.frame)
        selectedTimeLabel.adjustsFontSizeToFitWidth = true
        selectedTimeLabel.textColor = selectedTimeLabelTextColor
        selectedTimeLabel.textAlignment = .center
        selectedTimeLabel.isHidden = !isShowSelectedTime
    }
    
    private func prepareTimeLabel() {
        var angle = model.angle270
        var smallRadius = radius - (radius/10 + clockBorderLineWidth)
        let length = radius/4
        smallRadius -= length/2
        
        // draw line (from center to out)
        for i in 0..<12 {
            let label = makeTimeLabel(length: length)
            label.text = clockType.time(index: i)
            label.font = model.adjustFont(rect: label.frame)
            clockView.addSubview(label)
            let point = CGPoint(x: clockCenter.x + smallRadius * CGFloat(cosf(angle)),
                                y: clockCenter.y + smallRadius * CGFloat(sinf(angle)))
            label.center = point
            angle += model.angle30
        }
    }
    
    private func makeTimeLabel(length: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: length, height: length))
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = timeLabelTextColor
        return label
    }
    
    //MARK: - Make Layer
    private func makeDrawLayer() -> CAShapeLayer {
        let drawLayer = CAShapeLayer()
        drawLayer.frame = clockView.bounds
        drawLayer.cornerRadius = radius
        drawLayer.masksToBounds = true
        if clockImage == nil {
            drawLayer.borderWidth = clockBorderLineWidth
            drawLayer.borderColor = clockBorderLineColor.cgColor
        }
        return drawLayer
    }
    
    private func makeSmallClockIndexLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = drawLayer!.bounds
        layer.strokeColor = smallClockIndexColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = smallClockIndexWidth
        
        let smallRadius = radius - (radius/20 + clockBorderLineWidth)
        var angle = model.angle270
        let path = UIBezierPath()
        // draw line (from center to out)
        for i in 0..<60 {
            if i%5 == 0 {
                angle += Float(Double.pi/30)
                continue
            }
            let startPoint = CGPoint(x: clockCenter.x + radius * CGFloat(cosf(angle)),
                                     y: clockCenter.y + radius * CGFloat(sinf(angle)))
            path.move(to: startPoint)
            let endPoint = CGPoint(x: clockCenter.x + smallRadius * CGFloat(cosf(angle)),
                                   y: clockCenter.y + smallRadius * CGFloat(sinf(angle)))
            path.addLine(to: endPoint)
            angle += Float(Double.pi/30)
        }
        layer.path = path.cgPath
        return layer
    }
    
    private func makeClockIndexLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = drawLayer!.bounds
        layer.strokeColor = clockIndexColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = clockIndexWidth
        
        let smallRadius = radius - (radius/10 + clockBorderLineWidth)
        var angle = model.angle270
        let path = UIBezierPath()
        // draw line (from center to out)
        for _ in 0..<12 {
            let startPoint = CGPoint(x: clockCenter.x + radius * CGFloat(cosf(angle)),
                                     y: clockCenter.y + radius * CGFloat(sinf(angle)))
            path.move(to: startPoint)
            let endPoint = CGPoint(x: clockCenter.x + smallRadius * CGFloat(cosf(angle)),
                                   y: clockCenter.y + smallRadius * CGFloat(sinf(angle)))
            path.addLine(to: endPoint)
            angle += model.angle30
        }
        layer.path = path.cgPath
        return layer
    }
    
    private func makeHourHandLayer() -> CAShapeLayer {
        let hourHandLayer = CAShapeLayer()
        hourHandLayer.frame = drawLayer!.bounds
        hourHandLayer.strokeColor = hourHandColor.cgColor
        hourHandLayer.fillColor = UIColor.clear.cgColor
        hourHandLayer.lineWidth = hourHandWidth
        hourHandLayer.path = makeHandPath(length: hourHandLength,
                                          angle: model.angle270).cgPath
        return hourHandLayer
    }
    
    private func makeMinuteHandLayer() -> CAShapeLayer {
        let minuteHandLayer = CAShapeLayer()
        minuteHandLayer.frame = drawLayer!.bounds
        minuteHandLayer.strokeColor = minuteHandColor.cgColor
        minuteHandLayer.fillColor = UIColor.clear.cgColor
        minuteHandLayer.lineWidth = minuteHandWidth
        minuteHandLayer.path = makeHandPath(length: minuteHandLength,
                                            angle: model.angle270).cgPath
        return minuteHandLayer
    }
    
    private func makePanMinuteLayer() -> CAShapeLayer {
        let panMinuteLayer = CAShapeLayer()
        let path = UIBezierPath(ovalIn: CGRect(x: clockCenter.x - radius,
                                               y: clockCenter.y - radius,
                                               width: radius * 2, height: radius * 2))
        panMinuteLayer.frame = drawLayer!.bounds
        panMinuteLayer.strokeColor = UIColor.clear.cgColor
        panMinuteLayer.fillColor = clockColor.cgColor
        panMinuteLayer.path = path.cgPath
        return panMinuteLayer
    }
    
    private func makePanHourLayer() -> CAShapeLayer {
        let panHourLayer = CAShapeLayer()
        let smallRadius = radius/2
        let path = UIBezierPath(ovalIn: CGRect(x: clockCenter.x - smallRadius,
                                               y: clockCenter.y - smallRadius,
                                               width: smallRadius * 2,
                                               height: smallRadius * 2))
        panHourLayer.frame = drawLayer!.bounds
        panHourLayer.strokeColor = centerCircleLineColor.cgColor
        panHourLayer.fillColor = UIColor.clear.cgColor
        panHourLayer.path = path.cgPath
        return panHourLayer
    }
    
    private func makeHandPath(length: CGFloat, angle: Float) -> UIBezierPath {
        let path = UIBezierPath()
        let point = CGPoint(x: clockCenter.x + length * CGFloat(cosf(angle)),
                            y: clockCenter.y + length * CGFloat(sinf(angle)))
        path.move(to: clockCenter)
        path.addLine(to: point)
        return path
    }
    
    //MARK: - Gesture Action
    @objc func panAction(gesture: UIPanGestureRecognizer) {
        guard let panMinuteLayer = panMinuteLayer,
            let panHourLayer = panHourLayer else {
                return
        }
        
        let point = gesture.location(in: clockView)
        if gesture.state == .began {
            /// Set edit mode
            if UIBezierPath(cgPath: panHourLayer.path!).contains(point) {
                editType = .hour
                startAngle = model.compensationHourAngle(date: currentDate)
            } else if UIBezierPath(cgPath: panMinuteLayer.path!).contains(point) {
                editType = .minute
                startAngle = model.caluculateAngle(minute: model.minute(for: currentDate))
            } else {
                editType = .none
            }
        } else {
            switch editType {
            case .none:
                /// Set edit mode
                if UIBezierPath(cgPath: panHourLayer.path!).contains(point) {
                    editType = .hour
                    startAngle = model.compensationHourAngle(date: currentDate)
                } else if UIBezierPath(cgPath: panMinuteLayer.path!).contains(point) {
                    editType = .minute
                    startAngle = model.caluculateAngle(minute: model.minute(for: currentDate))
                }
            case .hour:
                editTimeHour(point: point)
            case .minute:
                editTimeMinute(point: point)
            }
        }
    }
    
    private func editTimeHour(point: CGPoint) {
        let radian = model.calculateRadian(point: point, radius: radius)
        var angle = model.calculateHourAngle(radian: radian)
        let minuteInt = Int(model.minute(for: currentDate))
        angle += (Float(minuteInt!)/60.0) * model.angle30
        endAngle = angle
        
        if startAngle == endAngle {
            return
        }
        
        var angleGap: Float = 0.0
        if startAngle > endAngle {
            let gap = startAngle - endAngle
            if gap > model.angle270 {
                angleGap = (endAngle + model.angle360) - startAngle
            } else {
                angleGap = endAngle - startAngle
            }
        } else {
            let gap = endAngle - startAngle
            if gap > model.angle270 {
                angleGap = ((startAngle + model.angle360) - endAngle) * -1
            } else {
                angleGap = endAngle - startAngle
            }
        }
        
        var degree = Int(angleGap*360 / model.angle360)
        degree = (degree < 0) ? degree - 5 : degree + 5
        let hour: Int = degree/30
        
        drawHourHandLayer(angle: angle)
        currentDate = currentDate.addingTimeInterval(60 * 60 * TimeInterval(hour))
        changedTime()
        startAngle = angle
    }
    
    private func editTimeMinute(point: CGPoint) {
        let radian = model.calculateRadian(point: point, radius: radius)
        let minuteInt = Int((radian - model.angle270) / (model.angle360 / 60))
        if minuteInt == Int(model.minute(for: currentDate)) {
            return
        }
        
        let angle = model.caluculateMinuteAngle(radian: radian)
        endAngle = angle
        drawMinuteHandLayer(angle: angle)
        
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],
                                                 from: currentDate)
        components.minute = minuteInt
        currentDate = calendar.date(from: components)!
        
        if endAngle < startAngle {
            let gap = startAngle - endAngle
            if gap > model.angle270 {
                // case(through 12o'clock)
                currentDate = currentDate.addingTimeInterval(60 * 60)// 1 hour ago
            }
        } else {
            let gap = endAngle - startAngle
            if gap > model.angle270 {
                // case(through 12o'clock)
                currentDate = currentDate.addingTimeInterval(-60 * 60)// 1 hour later
            }
        }
        
        drawHourHandLayer(angle: model.compensationHourAngle(date: currentDate))
        changedTime()
        startAngle = angle
    }
    
    //MARK: - Draw Hand
    private func drawMinuteHandLayer(angle: Float) {
        if minuteHandImage != nil {
            let rotation = angle - model.angle270
            minuteHandImageView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
            return
        }
        
        guard let minuteHandLayer = minuteHandLayer else {
            return
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        minuteHandLayer.path = makeHandPath(length: minuteHandLength, angle: angle).cgPath
        CATransaction.commit()
    }
    
    private func drawHourHandLayer(angle: Float) {
        if hourHandImage != nil {
            clockImageView.image = clockImage
            minuteHandImageView.image = minuteHandImage
            hourHandImageView.image = hourHandImage
            let rotation = angle - model.angle270
            hourHandImageView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
            return
        }
        
        guard let hourHandLayer = hourHandLayer else {
            return
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        hourHandLayer.path = makeHandPath(length: hourHandLength, angle: angle).cgPath
        CATransaction.commit()
    }
    
    //MARK: - Shwo/Clear
    private func clear() {
        clockView.subviews.forEach { $0.removeFromSuperview() }
        selectedTimeLabel.removeFromSuperview()
        clockImageView.removeFromSuperview()
        hourHandImageView.removeFromSuperview()
        minuteHandImageView.removeFromSuperview()
        clockView.removeFromSuperview()
        drawLayer?.removeFromSuperlayer()
        minuteHandImageView.transform = CGAffineTransform.identity
        hourHandImageView.transform = CGAffineTransform.identity
        
        hourHandLayer = nil
        minuteHandLayer = nil
        panHourLayer = nil
        panMinuteLayer = nil
        drawLayer = nil
    }
    
    private func relodClock() {
        clear()
        
        prepareClockView()
        prepareClockImageViews()
        
        drawLayer = makeDrawLayer()
        clockView.layer.addSublayer(drawLayer!)
        
        if clockImage == nil {
            drawLayer!.addSublayer(makeSmallClockIndexLayer())
            drawLayer!.addSublayer(makeClockIndexLayer())
            prepareTimeLabel()
        }
        
        panMinuteLayer = makePanMinuteLayer()
        drawLayer!.insertSublayer(panMinuteLayer!, at: 0)
        panHourLayer = makePanHourLayer()
        drawLayer!.addSublayer(panHourLayer!)
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(self.panAction(gesture:)))
        clockView.addGestureRecognizer(pan)
        
        if hourHandImage == nil {
            hourHandLayer = makeHourHandLayer()
            drawLayer!.addSublayer(hourHandLayer!)
        }
        
        if minuteHandImage == nil {
            minuteHandLayer = makeMinuteHandLayer()
            drawLayer!.addSublayer(minuteHandLayer!)
        }
        
        prepareSelectedTimeLabel()
    }
    
    private func changedTime() {
        selectedTimeLabel.text = model.time(for: currentDate)
        delegate?.clockView(self, didChangeDate: currentDate)
    }
    
    public func redrawClock() {
        relodClock()
        drawMinuteHandLayer(angle: model.caluculateAngle(minute: model.minute(for: currentDate)))
        drawHourHandLayer(angle: model.compensationHourAngle(date: currentDate))
        selectedTimeLabel.text = model.time(for: currentDate)
    }
}
