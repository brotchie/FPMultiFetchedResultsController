Pod::Spec.new do |s|
  s.name         = "FPMultiFetchedResultsController"
  s.version      = "0.0.4"
  s.summary      = "An extended NSFetchResultsController that supports multiple underlying NSFetchRequests."
  s.homepage     = "https://github.com/brotchie/FPMultiFetchedResultsController"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "James Brotchie" => "brotchie@gmail.com" }
  s.source       = { :git => "https://github.com/brotchie/FPMultiFetchedResultsController.git", :tag => "#{s.version}" }
  s.platform     = :ios, '5.1'
  s.source_files = 'FPMultiFetchedResultsController/*.{h,m}'
  s.requires_arc = true
  s.frameworks = 'CoreData'
end
