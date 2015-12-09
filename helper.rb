require 'fileutils'
require 'open3'

DOTFILES = File.dirname(__FILE__)
HOME = Dir.home
HOMEBREW_PREFIX = '/usr/local'
HOMEBREW_REPO = 'https://github.com/Homebrew/install'

module Tty extend self
    def blue; bold 34; end
    def grey; bold 30; end
    def white; bold 39; end
    def red; underline 31; end
    def reset; escape 0; end
    def bold n; escape "1;#{n}" end
    def underline n; escape "4;#{n}" end
    def escape n; "\033[#{n}m" if STDOUT.tty? end
end

class Array
  def shell_s
    cp = dup
    first = cp.shift
    cp.map{ |arg| arg.gsub " ", "\\ " }.unshift(first) * " "
  end
end

def ohai *args
  puts "#{Tty.blue}==>#{Tty.white} #{args.shell_s}#{Tty.reset}"
end

def warn warning
  puts "#{Tty.red}Warning#{Tty.reset}: #{warning.chomp}"
end

def system *args
  abort "Failed during: #{args.shell_s}" unless Kernel.system(*args)
end

def sudo *args
  ohai "/usr/bin/sudo", *args
  system "/usr/bin/sudo", *args
end

def getc  # NOTE only tested on OS X
  system "/bin/stty raw -echo"
  if STDIN.respond_to?(:getbyte)
    STDIN.getbyte
  else
    STDIN.getc
  end
ensure
  system "/bin/stty -raw echo"
end

def wait_for_user
  puts "Press RETURN to continue or any other key to abort"
  c = getc
  # we test for \r and \n because some stuff does \r instead
  abort unless c == 13 or c == 10
end

class Version
  include Comparable
  attr_reader :parts

  def initialize(str)
    @parts = str.split(".").map { |i| i.to_i }
  end

  def <=>(other)
    parts <=> self.class.new(other).parts
  end
end

def macos_version
  @macos_version ||= Version.new(`/usr/bin/sw_vers -productVersion`.chomp[/10\.\d+/])
end

def git
  @git ||= if ENV['GIT'] and File.executable? ENV['GIT']
    ENV['GIT']
  elsif Kernel.system '/usr/bin/which -s git'
    'git'
  else
    exe = `xcrun -find git 2>/dev/null`.chomp
    exe if $? && $?.success? && !exe.empty? && File.executable?(exe)
  end

  return unless @git
  # Github only supports HTTPS fetches on 1.7.10 or later:
  # https://help.github.com/articles/https-cloning-errors
  `#{@git} --version` =~ /git version (\d\.\d+\.\d+)/
  return if $1.nil? or Version.new($1) < "1.7.10"

  @git
end

def chmod?(d)
  File.directory?(d) && !(File.readable?(d) && File.writable?(d) && File.executable?(d))
end

def chown?(d)
  !File.owned?(d)
end

def chgrp?(d)
  !File.grpowned?(d)
end

def install_homebrew
  if Dir["#{HOMEBREW_PREFIX}/.git/*"].empty?
    ohai "Homebrew"
    if !Kernel.system '/usr/bin/which -s brew'
      puts "homebrew install"
      Kernel.system 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
      Kernel.system 'brew tap Homebrew/bundle'
      Kernel.system "brew bundle --file=#{File.dirname(__FILE__)}/private/Brewfile"
    end
  end
end

def install_symlinks
  files = []
  Dir.glob('**/*.symlink', File::FNM_DOTMATCH).each do |f|
      files << File.expand_path(f)
  end

  unless files.empty?
      ohai "The following symlinks have been created:"
      files.each { |x|
          source = "#{File.dirname(x.sub('/.dotfiles','').sub('/private',''))}/#{File.basename(x, '.*' )}"
          destination = "#{x}"
          link_file(source, destination)
      }
      puts
  end
end

def install_zsh
  ohai "Installing zsh"
  stdout, stdeerr, status = Open3.capture3("tail -n 1 /etc/shells")
  if stdout.chomp.eql?("/bin/zsh")
    stdout, stdeerr, status = Open3.capture3("sudo sh -c \"echo '/usr/local/bin/zsh' >> /etc/shells\"")
  end
  stdout, stdeerr, status = Open3.capture3("sudo chsh -s $(which zsh) $LOGNAME")
end

def link_file(src, dst)
    if !File.directory? File.dirname(src)
        FileUtils.mkdir_p File.dirname(src)
    end
    puts "\t#{Tty.white}#{src.sub(HOME,'~')} #{Tty.grey}-->#{Tty.white} #{dst.sub(HOME,'~')}#{Tty.reset}"
    FileUtils.ln_s dst, src, :force => true
end

def osx_defaults
  ohai "Installing OS X defaults"
  Kernel.system "#{File.dirname(__FILE__)}/osx_defaults.sh"
end
