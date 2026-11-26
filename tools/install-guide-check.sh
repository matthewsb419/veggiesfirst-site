#!/bin/zsh
# install-guide-check.sh — put the daily guide job (tools/guide-daily.sh) on this Mac's
# launchd, 6:00 AM local every day (the Mac mini is always on). Re-run after moving the
# repo. Remove with:
#   launchctl bootout gui/$(id -u)/com.matthewsb419.veggies-guides
set -eu
S=$(cd "$(dirname "$0")" && pwd)
LABEL=com.matthewsb419.veggies-guides
PLIST=~/Library/LaunchAgents/$LABEL.plist
LOGS=~/Library/Logs/VeggiesFirst; mkdir -p $LOGS
cat > $PLIST <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key><array>
    <string>/bin/zsh</string><string>$S/guide-daily.sh</string>
  </array>
  <key>StartCalendarInterval</key><dict><key>Hour</key><integer>6</integer><key>Minute</key><integer>0</integer></dict>
  <key>EnvironmentVariables</key><dict><key>PATH</key><string>/opt/homebrew/bin:$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string></dict>
  <key>StandardOutPath</key><string>$LOGS/guides.out</string>
  <key>StandardErrorPath</key><string>$LOGS/guides.err</string>
</dict></plist>
PL
launchctl bootout gui/$(id -u)/$LABEL 2>/dev/null || true
launchctl bootstrap gui/$(id -u) $PLIST
launchctl print gui/$(id -u)/$LABEL | grep -E "state|program|run interval|calendar" | head -5
echo "installed: $PLIST"
