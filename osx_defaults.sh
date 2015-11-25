#!/usr/bin/env bash

#
# General
#

# Disable the "reopen windows when logging back in" option
# This works, although the checkbox will still appear to be checked.
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2
# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
# Disable 'smart' quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
# Set the login window to name and password
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true
# Turn off Gatekeeper Message
sudo spctl --master-disable
# Turn off Automatic updates
sudo softwareupdate --schedule off
# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"
# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# Disable “Application Downloaded from the internet” message
defaults write com.apple.LaunchServices LSQuarantine -bool NO
# Finally disable opening random Apple photo applications when plugging in devices
# https://twitter.com/stroughtonsmith/status/651854070496534528
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

#
# Finder
#

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true
# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true
# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: 'icnv', 'clmv', 'Flwv', 'Nlsv'
defaults write com.apple.finder FXPreferredViewStyle -string "Flmv"
# Allow text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true
# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool false

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Finder: new window location set to $HOME. Same as Finder > Preferences > New Finder Windows show
# For other path use "PfLo" and "file:///foo/bar/"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Default to local files instead of iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

# Should remove downloaded from the internet warnings
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Show the ~/Library folder
chflags nohidden ~/Library



#
# Displays
#

# Show displays in menu bar
defaults write com.apple.airplay showInMenuBarIfPresent -bool false
# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
# Run the screensaver if we're in the bottom-left hot corner.
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0



#
# Dock
#

# Enable spring loading for all Dock items
defaults write enable-spring-load-actions-on-all-items -bool false
# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false



#
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
#

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

defaults write com.apple.driver.AppleHIDMouse Button2 -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string TwoButton
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 1



#
# Terminal
#

# Disable leading [ on prompt lines (which is totally broken in anything curses)
# https://twitter.com/UINT_MIN/status/652142001932996609
defaults write com.apple.Terminal AutoMarkPromptLines -bool false
defaults write com.apple.Terminal ShowLineMarks -bool false
