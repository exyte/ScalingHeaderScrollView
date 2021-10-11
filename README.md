<img src="https://github.com/exyte/ScalingHeaderScrollView/blob/master/Assets/header.png">
<img align="right" src="https://raw.githubusercontent.com/exyte/ScalingHeaderScrollView/master/Assets/demo.gif" width="480" />

<p><h1 align="left">Scaling Header View</h1></p>

<p><h4>Scaling Header View library written with SwiftUI</h4></p>

___

<p> We are a development agency building
  <a href="https://clutch.co/profile/exyte#review-731233?utm_medium=referral&utm_source=github.com&utm_campaign=phenomenal_to_clutch">phenomenal</a> apps.</p>

</br>

<a href="https://exyte.com/contacts"><img src="https://i.imgur.com/vGjsQPt.png" width="134" height="34"></a> <a href="https://twitter.com/exyteHQ"><img src="https://i.imgur.com/DngwSn1.png" width="165" height="34"></a>

</br></br>

[![Twitter](https://img.shields.io/badge/Twitter-@exyteHQ-blue.svg?style=flat)](http://twitter.com/exyteHQ)
[![Version](https://img.shields.io/cocoapods/v/ScalingHeaderScrollView.svg?style=flat)](http://cocoapods.org/pods/ScalingHeaderScrollView)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-0473B3.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/ScalingHeaderScrollView.svg?style=flat)](http://cocoapods.org/pods/ScalingHeaderScrollView)
[![Platform](https://img.shields.io/cocoapods/p/ScalingHeaderScrollView.svg?style=flat)](http://cocoapods.org/pods/ScalingHeaderScrollView)

# Usage
1. Put your header and content bodies code into a ScalingHeaderView constructor.
2. Set the necessary modifiers, see below.
```swift
struct ContentView: View {

    var body: some View {
       ScalingHeaderView { height in
            ZStack {
                Rectangle()
                    .fill(.gray.opacity(0.15))
                Image(uiImage: image)
            }
        } content: {
            Text("↓ Pull to refresh ↓")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
```

### Required parameters 
`header` - `@ViewBuilder` for your header  
`content` - `@ViewBuilder` for your content  

### Available modifiers, optional  
allows set up callback and `isLoading` state for pull-to-refresh action  
```swift
.pullToRefresh(isLoading: Binding<Bool>, perform: @escaping () -> Void)
```
 allows content scroll reset, need to change Binding to `true`  
```swift
.scrollToTop(resetScroll: Binding<Bool>)
```
 changes min and max heights of Header, default `min = 150.0` and `max = 350.0`  
```swift
.height(min: CGFloat = 150.0, max: CGFloat = 350.0)
```
when scrolling up - switch between actual header collapse and simply moving it up  
```swift
.allowsHeaderCollapse(_ value: Bool)
```
when scrolling down - enable/disable header scale    
```swift
.allowsHeaderScale(_ value: Bool)
```
enable/disable header snap (once you lift your finger header snaps either to min or max height automatically)     
```swift
.allowsHeaderSnap(_ value: Bool)
```

## Examples

To try ScalingHeaderView examples:
- Clone the repo `https://github.com/exyte/ScalingHeaderScrollView.git`
- Open terminal and run `cd <ScalingHeaderViewRepo>/Example/`
- Run `pod install` to install all dependencies
- Run open `Example.xcworkspace/` to open project in the Xcode
- Try it!

## Installation

### [CocoaPods](http://cocoapods.org)

To install `ScalingHeaderView`, simply add the following line to your Podfile:

```ruby
pod 'ScalingHeaderView'
```

### [Carthage](http://github.com/Carthage/Carthage)

To integrate `ScalingHeaderView` into your Xcode project using Carthage, specify it in your `Cartfile`

```ogdl
github "Exyte/ScalingHeaderScrollView"
```

### [Swift Package Manager](https://swift.org/package-manager/)

```swift
dependencies: [
    .package(url: "https://github.com/exyte/ScalingHeaderScrollView.git", from: "1.0.0")
]
```

## Requirements

* iOS 14+
* Xcode 12+ 
