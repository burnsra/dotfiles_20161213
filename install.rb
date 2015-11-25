require 'fileutils'
require 'socket'

require_relative 'helper'

# Invalidate sudo timestamp before exiting
at_exit { Kernel.system "/usr/bin/sudo", "-k" }

Kernel.system "clear"
ohai "This will install dotfiles to your home directory (#{HOME})"
wait_for_user if STDIN.tty?

puts
ohai "Please enter your password to allow commands to run via sudo as needed"
Kernel.system "/usr/bin/sudo", "-v"
puts

install_homebrew

#puts Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
