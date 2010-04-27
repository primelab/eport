spec = Gem::Specification.new do |s| 
  s.name = "eport"
  s.version = "0.0.1"
  s.author = "Alexander Lomakin, Dmitry Andreev"
  s.email = "d.g.andreev@gmail.com"
  s.homepage = ""
  s.platform = Gem::Platform::RUBY
  s.summary = "e-port.ru"
  s.files = Dir["lib/*.*"]
  s.require_path = "lib"
  s.autorequire = "eport"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
end
