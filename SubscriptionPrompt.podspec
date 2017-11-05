Pod::Spec.new do |spec|
  spec.name = "SubscriptionPrompt"
  spec.version = "1.0.0"
  spec.summary = "Subscription View Controller like the Tinder uses."
  spec.homepage = "https://github.com/Binur/SubscriptionPrompt"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Binur Konarbai" => 'binur95@gmail.com' }
  spec.social_media_url = "https://www.facebook.com/binchik"

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/Binur/SubscriptionPrompt.git", tag: "#{spec.version}", submodules: true }
  spec.source_files = "SubscriptionPrompt/**/*.{h,swift}"
end