# SubscriptionPrompt
SubscriptionPrompt is a UIViewController with a carousel at the top and a number of rows at the bottom. Written in Swift, works for Objective-C as well.

<img alt="SubscriptionPrompt screenshot" src="https://raw.githubusercontent.com/Binur/SubscriptionPrompt/master/assets/Simulator Screen Shot May 4, 2016, 12.29.13 PM.png" width="375">

# Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `SubscriptionPrompt` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'SubscriptionPrompt'
```

To get the full benefits import `SubscriptionPrompt` wherever you import UIKit

``` swift
import UIKit
import SubscriptionPrompt
```

#### Manually
1. Download and drop ```/SubscriptionPrompt```folder in your project.  
2. Congratulations!  

# Usage

Just initialize the SubscriptionViewontroller with the following constructor, 
you can omit some parameters since they have default values:

```swift
init(title: String? = nil, slides: [Slide], options: [Option],
	cancelMessage: String? = nil, restoreButtonTitle: String? = nil)
```

and present it.

`Slide` and `Option` are structs, use the following inits to create them:

```swift
init(image: UIImage?, title: String?, subtitle: String?)
init(title: String?, checked: Bool = false)
```

To get the index of tapped rows, implement the SubscriptionViewControllerDelegate.

```swift
override func viewDidLoad() {
      super.viewDidLoad()
      subscriptionViewController.delegate = self
}

func subscriptionViewControllerRowTapped(atIndex index: Int) {
    print("tapped index: \(index)")
}
```

`animateDraggingToTheRight(duration:)` - animates a little drag to the right and back with the given duration 
[ux hint for the user that the carousel is draggable]

# TODO

1. Fonts customizations.
2. Colors customziations.
3. Add closure-based delegation API. Example:

```swift
subscriptionVC.rowTapped { idx in
	print("tapped index: \(idx)")
}
```
