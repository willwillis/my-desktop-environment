#!/bin/bash

# Check if running as root
if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root. Use 'sudo bash <script_name>'."
  exit 1
fi

# Define the mount point directories
mount_points=("/run/media/tower" "/run/media/hd1" "/run/media/hd2")

# Create mount point directories if they don't exist
echo "Checking and creating mount point directories..."
for dir in "${mount_points[@]}"; do
  if [[ ! -d "$dir" ]]; then
    echo "Creating directory: $dir"
    mkdir -p "$dir" # Use -p to create parent directories if needed
    if [[ $? -ne 0 ]]; then
      echo "Error creating directory: $dir"
    fi
  else
    echo "Directory already exists: $dir"
  fi
done

# essential packages
packages_file="manjaro-essential-packages.txt"

# Check if the packages file exists
if [[ ! -f "$packages_file" ]]; then
  echo "Error: Package list file '$packages_file' not found."
  exit 1
fi

# Install essential packages from the file
echo ""
echo "Installing essential packages from '$packages_file'..."
while IFS= read -r package; do
  # Skip empty lines and lines starting with '#' (comments)
  if [[ -n "$package" && "$package" != \#* ]]; then
    echo "Installing: $package"
    pacman -S --noconfirm "$package"
    if [[ $? -ne 0 ]]; then
      echo "Error installing package: $package"
    fi
  fi
done < "$packages_file"


# Define the lines to append to /etc/fstab
fstab_lines=(
  "tower_ip_address:/mnt/user/media /run/media/tower nfs defaults,timeo=990,retrans=5,_netdev 0 0"
  "UUID=77ba10c3-7641-40ec-bbe2-c8a2a9962e1b /run/media/hd1 btrfs defaults,noatime 0 2"
  "UUID=f00af31d-d3e3-430e-8a82-8ad7ba025990 /run/media/hd2 btrfs defaults,noatime 0 2"
)

# Append the lines to /etc/fstab
echo ""
echo "Appending entries to /etc/fstab..."
# TODO: buggy, doesn't account for tabs
for line in "${fstab_lines[@]}"; do
  grep -qF "$line" /etc/fstab || echo "$line" >> /etc/fstab
  if [[ $? -ne 0 ]]; then
    echo "Error appending line to /etc/fstab: $line"
  fi
done

echo "enabling and starting services required to mount over nfs"
systemctl enable rpc-statd.service
systemctl enable rpcbind.service
systemctl start rpc-statd.service
systemctl start rpcbind.service
systemctl daemon-reload
mount -a
# a reboot was needed first try

echo ""
echo "Setup complete."
