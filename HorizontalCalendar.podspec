Pod::Spec.new do |spec|

  spec.name         = "HorizontalCalendar"
  spec.version      = "0.0.1"
  spec.summary      = "Horizontal scrollable calendar for week view just like on iOS calendar."

  spec.description  = <<-DESC
This calendar shows week view and can be scrolled back and forth endlessly. You can select any date you want, it also comes with goToToday button. Another nice feature which makes it copact is collapseable and expandable form of this calendar.
                   DESC

  spec.homepage     = "https://github.com/salmaanahmed/HorizontalCalendar"
  spec.screenshots  = "https://raw.githubusercontent.com/salmaanahmed/HorizontalCalendar/master/Calendar.png"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Salmaan Ahmed" => "salmaan.ahmed@hotmail.com" }
  spec.social_media_url   = "https://twitter.com/salmaanahmed91"

  spec.ios.deployment_target = "11.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/salmaanahmed/HorizontalCalendar.git", :tag => "#{spec.version}" }
  spec.source_files  = "HorizontalCalendar/*.swift"

end