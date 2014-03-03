#!/usr/bin/env ruby

require 'erb'

$supported_packages = [:bash, :tmux, :git, :emacs, :ssh]
$platform = RUBY_PLATFORM
$linux = 'linux'
$osx = 'darwin'

def stow(package)
  unless $supported_packages.include? package
    puts "No package called #{package}"
    return
  end

  if package == :git
    erb = ERB.new(File.read('git/.gitconfig.erb'))
    email = ($platform.include? $osx) ? 'nrcopty@gmail.com' : 'ncopty@appnexus.com'
    namespace = OpenStruct.new(:git_email => email)
    result = erb.result(namespace.instance_eval { binding })
    File.write('git/.gitconfig', result)
  end

  if package == :ssh and platform.include? $osx
    return
  end

  unless system("stow #{package.to_s}")
    puts "There was an error stowing #{package}."
  end
end

def stow_packages(packages=nil)
  unless packages
    $supported_packages.each do |pkg|
      stow pkg.to_sym
    end
  else
    packages.each do |pkg|
      stow pkg.to_sym
    end
  end
end

if __FILE__ == $0
  stow_packages ARGV
end
