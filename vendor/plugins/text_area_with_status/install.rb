require 'fileutils'

# this should be set by Rails, but just in case, we're checking it too
rails_root ||= FileUtils.pwd
directory ||= File.join(rails_root, 'vendor', 'plugins', 'text_area_with_status')

# init paths
file = '/public/javascripts/limit_chars.js'
src  = File.join(directory, file)
dst  = File.join(rails_root, file)

# copy javascript and display README
begin 
  unless File.exists?(dst)
    FileUtils.cp(src, dst) 
    puts "Installed plugin's .js: #{dst}\n\n"
    puts IO.read(File.join(directory, 'README'))
  else
    puts "Plugin's .js file is already installed. Nothing to do..."
  end
rescue Exception => e
  puts "Problems encountered while copying the .js:\n\n\t#{e.message}\n\n"
end
