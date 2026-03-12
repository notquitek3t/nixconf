# Pontiac G5 Pi AUX Unit (i dont know wtf to name this thing)

if [ -z ${SSH_CLIENT+x} ]; then echo "not running over ssh"; else exit; fi

clear
cat <<EOF
██╗  ██╗██████╗ ████████╗██╗  ██╗██╗   ██╗███████╗    ██████╗ ███████╗██╗   ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗███╗   ██╗████████╗
██║ ██╔╝╚════██╗╚══██╔══╝╚██╗██╔╝╚██╗ ██╔╝╚══███╔╝    ██╔══██╗██╔════╝██║   ██║██╔════╝██║     ██╔═══██╗██╔══██╗████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
█████╔╝  █████╔╝   ██║    ╚███╔╝  ╚████╔╝   ███╔╝     ██║  ██║█████╗  ██║   ██║█████╗  ██║     ██║   ██║██████╔╝██╔████╔██║█████╗  ██╔██╗ ██║   ██║
██╔═██╗  ╚═══██╗   ██║    ██╔██╗   ╚██╔╝   ███╔╝      ██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║     ██║   ██║██╔═══╝ ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║
██║  ██╗██████╔╝   ██║██╗██╔╝ ██╗   ██║   ███████╗    ██████╔╝███████╗ ╚████╔╝ ███████╗███████╗╚██████╔╝██║     ██║ ╚═╝ ██║███████╗██║ ╚████║   ██║
╚═╝  ╚═╝╚═════╝    ╚═╝╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝
EOF

# Functions
logger() {
    local message="$*"
    local timestamp=$(date '+%b %e %H:%M:%S')  # e.g., Mar  8 14:35:22
    local hostname=$(hostname)
    local pid=$$  # PID of the current script
    echo "$timestamp g5pi[$pid]: $message"
}

# bluetooth network loop
netloop() {
  # Exit if already locked
  [[ -e /dev/shm/netloop ]] && return 0
  touch /dev/shm/netloop

  while :; do
    # Check if "Pixel 6a Network" is active
    if ! nmcli -t -f NAME connection show --active | grep -qx "Pixel 6a Network"; then
      #echo "Connecting to Pixel 6a Network..."
      nmcli connection up "Pixel 6a Network"
    fi
    sleep 5
  done
}
echo "$(date) [g5pi] starting up.."
journalctl -f &
# bump up that aux to the highest it can be
pactl set-sink-volume alsa_output.platform-fe00b840.mailbox.stereo-fallback 100%

# Bluetooth preparation
bluetoothctl <<EOF
power on
agent NoInputNoOutput
default-agent
system-alias "Pontiac G5"
discoverable on
pairable on
EOF

netloop &
tail
