#!/bin/bash

# GYFOOYA January 2026
# version : 1.0
# mkarchiso-buildbot

# sudo pacman -Syu archiso
# baseline and releng profile location : 
# /usr/share/archiso/configs/
#
# Exit on error
set -e

# =====================
# Configuration
# =====================
BASE_DIR="/home/noname/DEVEL/TEMPO_BUILD"
WORKING_DIR="$BASE_DIR/WORKING"
ISO_DIR="$BASE_DIR/ISO"
AIROOTFS="$WORKING_DIR/x86_64/airootfs"
PROFILE_DIR="releng"

LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/build_$(date +%Y%m%d_%H%M%S).log"

# =====================
# Colors (bright)
# =====================
RED='\033[1;31m'      # bright red
GREEN='\033[1;32m'    # bright green
YELLOW='\033[1;33m'   # bright yellow
BLUE='\033[1;94m'     # bright/light blue
NC='\033[0m'          # No Color

# =====================
# Logging setup
# =====================
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

# =====================
# Helper functions
# =====================
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# =====================
# Start timer
# =====================
START_TIME=$(date +%s)

# =====================
# Script start
# =====================
info "Log file: $LOG_FILE"
info "Starting cleanup process..."

# Unmount filesystems (ignore errors if not mounted)
warn "Unmounting filesystems (if mounted)..."
sudo umount "$AIROOTFS/proc" 2>/dev/null || warn "proc not mounted"
sudo umount "$AIROOTFS/sys"  2>/dev/null || warn "sys not mounted"
sudo umount "$AIROOTFS/dev"  2>/dev/null || warn "dev not mounted"
sudo umount "$AIROOTFS/run"  2>/dev/null || warn "run not mounted"

# Remove old directories
info "Removing old build directories..."
sudo rm -rf "$ISO_DIR"
sudo rm -rf "$WORKING_DIR"
success "Old directories removed."

# Recreate directories
info "Creating fresh directories..."
mkdir -p "$ISO_DIR"
mkdir -p "$WORKING_DIR"
success "Directories created."

# =====================
# mkarchiso prompt
# =====================
echo
read -rp "$(echo -e "${BLUE}Run mkarchiso now? (y/n): ${NC}")" answer

case "$answer" in
    y|Y|yes|YES)
        info "Running mkarchiso..."
        sudo mkarchiso -v -w "$WORKING_DIR/" -o "$ISO_DIR/" "$PROFILE_DIR/"
        success "mkarchiso completed successfully."
        ;;
    *)
        warn "mkarchiso execution skipped."
        ;;
esac

# =====================
# End timer and show duration
# =====================
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

hours=$((DURATION / 3600))
minutes=$(( (DURATION % 3600) / 60 ))
seconds=$((DURATION % 60))

success "Script finished in ${hours}h ${minutes}m ${seconds}s."
