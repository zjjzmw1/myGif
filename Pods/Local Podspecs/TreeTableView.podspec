

Pod::Spec.new do |s|
  s.name     = 'TreeTableView'
  s.version  = '0.0.2'
  s.platform = :ios
  s.license  = 'MIT'
  s.summary  = '可以展开合上的tableView类似扣扣列表'
  s.homepage = 'https://github.com/zjjzmw1/TreeTableView'
  s.author   = { '张明炜' => 'zjjzmw1@163.com' }
  s.source   = { :git => 'https://github.com/zjjzmw1/TreeTableView.git', :tag => s.version.to_s }

  s.description = '可以展开合上的tableView类似扣扣列表'

  s.source_files = 'TreeTableView/*.{h,m}'
  s.requires_arc = true
end

