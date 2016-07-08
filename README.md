# SubscriptionPrompt
SubscriptionPrompt is a UIViewController with a carousel at the top and a number of rows at the bottom. Written in Swift, works for Objective-C as well.

<img alt="SubscriptionPrompt screenshot" src="https://raw.githubusercontent.com/Binur/SubscriptionPrompt/master/assets/Simulator Screen Shot May 4, 2016, 12.29.13 PM.png" width="375">

# Installation

SubscriptionPrompt is available via CocoaPods just write:

```ruby
pod 'SubscriptionPrompt'
```

in your Podfile.

You may alternatively just copy the contents of the SubscriptionPrompt folder into your project.

# Usage

Just initialize the SubscriptionViewontroller with the following constructor:

```swift
init(title: String, images: [UIImage], commentTexts: [String], 
      commentSubtitleTexts: [String], subscribeOptionsTexts: [String], 
      cancelOptionText: String)
```

and present it.

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

`animateDraggingToTheRight(duration:)` - animates a little drag to the right and back with the given duration [ux hint for the user that the carousel is draggable]

# TODO

1. Fonts customizations.
2. Colors customziations.
3. Contents customizations.
4. Get rid of SnapKit dependency.
5. Documentation.



