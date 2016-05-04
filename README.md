# SubscriptionPrompt
SubscriptionPrompt is a UIViewController with a carousel at the top and a number of options at the bottom.

# Installation

SubscriptionPrompt is available via CocoaPods just write:

`pod 'SubscriptionPrompt'`

in your Pofile.

You may alternatively just copy the contents of the SubscriptionPrompt folder into your project.

# Usage

Just initialize the SubscriptionViewontroller with the following constructor:

```
init(title: String, images: [UIImage], commentTexts: [String], 
      commentSubtitleTexts: [String], subscribeOptionsTexts: [String], 
      cancelOptionText: String)
```

`animateDraggingToTheRight(duration:)` - animates a little drag to the right and back with the given duration [ux hint for the user that the carousel is draggable]

# TODO

1. Fonts customizations.
2. Colors customziations.
3. Contents customizations.



