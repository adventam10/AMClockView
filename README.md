# AMClockView

`AMClockView` is a view can select time.

## Demo

![amclock](https://user-images.githubusercontent.com/34936885/34641894-0adbf71a-f34e-11e7-892a-86e5f3e51256.gif)

## Usage


```swift
let clockView = AMClockView(frame: view.bounds)

// customize here

clockView.delegate = self
view.addSubview(clockView)
```

The hour hand moves  when you dragged inside of central circle.
The minute hand moves  when you draged outside of central circle.

## Variety

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

