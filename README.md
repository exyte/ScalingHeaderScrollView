<img src="https://github.com/exyte/ScalingHeaderScrollView/blob/master/Assets/header.png">
<p float="left">
  <img src="https://raw.githubusercontent.com/exyte/ScalingHeaderScrollView/master/Assets/1.gif" width="200" />
  <img src="https://raw.githubusercontent.com/exyte/ScalingHeaderScrollView/master/Assets/2.gif" width="200" /> 
  <img src="https://raw.githubusercontent.com/exyte/ScalingHeaderScrollView/master/Assets/3.gif" width="200" />
</p>

</br>
<p><h1 align="left">Scaling Header View</h1></p>

<p><h4>A scroll view with a sticky header which shrinks as you scroll. Written with SwiftUI.</h4></p>

___

<p> We are a development agency building
  <a href="https://clutch.co/profile/exyte#review-731233?utm_medium=referral&utm_source=github.com&utm_campaign=phenomenal_to_clutch">phenomenal</a> apps.</p>

<a href="https://exyte.com/contacts"><img src="https://i.imgur.com/vGjsQPt.png" width="134" height="34"></a> <a href="https://twitter.com/exyteHQ"><img src="https://i.imgur.com/DngwSn1.png" width="165" height="34"></a>

</br>

[![Twitter](https://img.shields.io/badge/Twitter-@exyteHQ-blue.svg?style=flat)](http://twitter.com/exyteHQ)
[![Version](https://img.shields.io/cocoapods/v/ScalingHeaderScrollView.svg?style=flat)](http://cocoapods.org/pods/ScalingHeaderScrollView)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-0473B3.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/ScalingHeaderScrollView.svg?style=flat)](http://cocoapods.org/pods/ScalingHeaderScrollView)
[![Platform](https://img.shields.io/cocoapods/p/ScalingHeaderScrollView.svg?style=flat)](http://cocoapods.org/pods/ScalingHeaderScrollView)

# Usage
1. Put your header and content bodies code into a ScalingHeaderScrollView constructor.     
2. Set the necessary modifiers, see below.      
```swift
struct ContentView: View {

    var body: some View {
       ScalingHeaderScrollView {
            ZStack {
                Rectangle()
                    .fill(.gray.opacity(0.15))
                Image("header")
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
passes current collapse progress value into progress binding: 0 for not collapsed at all, 1 - for fully collapsed       
```swift
.collapseProgress(_ progress: Binding<CGFloat>)
```
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
when scrolling up - switch between actual header collapse and simply moving it up (by default moving up)
```swift
.allowsHeaderCollapse()
```
when scrolling down - enable (disabled by default) header scale    
```swift
.allowsHeaderGrowth()
```
enable (disabled by default) header snap (once you lift your finger header snaps either to min or max height automatically)     
```swift
.allowsHeaderSnap()
```

## Examples

To try ScalingHeaderScrollView examples:
- Clone the repo `https://github.com/exyte/ScalingHeaderScrollView.git`
- Open terminal and run `cd <ScalingHeaderScrollViewRepo>/Example/`
- Run `pod install` to install all dependencies
- Run open `Example.xcworkspace/` to open project in the Xcode
- Try it!

## Installation

### [CocoaPods](http://cocoapods.org)

To install `ScalingHeaderScrollView`, simply add the following line to your Podfile:

```ruby
pod 'ScalingHeaderScrollView'
```

### [Carthage](http://github.com/Carthage/Carthage)

To integrate `ScalingHeaderScrollView` into your Xcode project using Carthage, specify it in your `Cartfile`

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
