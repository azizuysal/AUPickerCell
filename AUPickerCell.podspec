Pod::Spec.new do |s|
s.name             = "AUPickerCell"
s.version          = "1.0.0.0"
s.summary          = "Embedded picker view for table cells"
s.description      = "A UITableViewCell with an embedded UIPickerView for dates or strings."
s.homepage         = "https://github.com/azizuysal/AUPickerCell"
s.license          = { :type => "MIT", :file => "LICENSE.md" }
s.author           = { "Aziz Uysal" => "azizuysal@gmail.com" }
s.social_media_url = 'https://twitter.com/azizuysal'
s.source           = { :git => "https://github.com/azizuysal/AUPickerCell.git", :tag => s.version.to_s }
s.platform         = :ios, '10.0'
s.swift_version    = '4.0'
s.source_files     = 'AUPickerCell/AUPickerCell/*.{swift}'
end
