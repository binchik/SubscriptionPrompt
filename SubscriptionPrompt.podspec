Pod::Spec.new do |spec|
  spec.name = "SubscriptionPrompt"
  spec.version = "0.0.1"
  spec.summary = "Subscription View Controller like the Tinder uses."
  spec.homepage = "https://github.com/Binur/SubscriptionPrompt"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Your Name" => 'your-email@example.com' }
  spec.social_media_url = "http://twitter.com/thoughtbot"

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/Binur/SubscriptionPrompt.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "SubscriptionPrompt/**/*.{h,swift}"

  spec.dependency "SnapKit", "~> 0.20"
end