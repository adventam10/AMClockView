# AMClockView

![Pod Platform](https://img.shields.io/cocoapods/p/AMClockView.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/AMClockView.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/AMClockView.svg?style=flat)](http://cocoapods.org/pods/AMClockView)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`AMClockView` is a view can select time.

## Demo

![amclock](https://user-images.githubusercontent.com/34936885/34641894-0adbf71a-f34e-11e7-892a-86e5f3e51256.gif)

## Usage

Create clockView.

```swift
let clockView = AMClockView(frame: view.bounds)

// customize here

clockView.delegate = self
view.addSubview(clockView)
```

Conform to the protocol in the class implementation.

```swift
func clockView(_ clockView: AMClockView, didChangeDate date: Date) { 
    // use selected date here
}
```

The hour hand moves when you dragged inside of central circle.

The minute hand moves when you draged outside of central circle.

### Customization
`AMClockView` can be customized via the following properties.

```swift
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
@IBInspectable public var isShowSelectedTime: Bool = false
public var clockType = AMCVClockType.arabic
public var selectedDate: Date?
```

<img width="373" alt="amclock" src="https://user-images.githubusercontent.com/34936885/34641906-29d09d4c-f34e-11e7-8fb8-0e9637f1092d.png">

## Installation

### CocoaPods

Add this to your Podfile.
```ogdl
pod 'AMClockView'
```

### Carthage

Add this to your Cartfile.

```ogdl
github "adventam10/AMClockView"
```

## License

MIT

