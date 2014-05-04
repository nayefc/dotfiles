#!/usr/bin/env ruby
# Utility helper functions for bootstrap.

module Stow
  def self.stow_packages(packages)
    if packages.empty?
      $supported_packages.each do |pkg, platform|
        puts "Stowing #{pkg}"
        Stow::stow pkg.to_sym
      end
    else
      packages.each do |pkg, platform|
        puts "Stowing #{pkg}"
        stow pkg.to_sym
      end
    end
  end

  def self.template(template_file, variable_hash, result_file)
    erb = ERB.new(File.read(template_file))
    namespace = OpenStruct.new(variable_hash)
    result = erb.result(namespace.instance_eval { binding })
    File.write(result_file, result)
  end
end
