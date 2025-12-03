#!/usr/bin/env bash

# FLUXION Quick Setup Script
# Installs all dependencies for the latest version

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     FLUXION Quick Setup - Dec 2024         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run as root${NC}" 
   echo "Please run: sudo $0"
   exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
else
    echo -e "${RED}Error: Cannot detect OS${NC}"
    exit 1
fi

echo -e "${GREEN}Detected OS: $OS $VER${NC}"
echo ""

# Function to install packages based on OS
install_dependencies() {
    echo -e "${YELLOW}Installing dependencies...${NC}"
    
    case $OS in
        kali|debian|ubuntu)
            echo -e "${BLUE}Using apt package manager${NC}"
            apt update
            apt install -y \
                aircrack-ng \
                bc \
                gawk \
                curl \
                cowpatty \
                isc-dhcp-server \
                p7zip-full \
                hostapd \
                lighttpd \
                wireless-tools \
                macchanger \
                mdk4 \
                dsniff \
                nmap \
                openssl \
                php-cgi \
                xterm \
                rfkill \
                unzip \
                net-tools \
                psmisc \
                reaver \
                bully \
                pixiewps \
                python3 \
                python3-pip \
                iw \
                ethtool
            
            # Install hcxtools if available
            echo -e "${YELLOW}Installing hcxtools...${NC}"
            apt install -y hcxdumptool hcxpcapngtool 2>/dev/null || {
                echo -e "${YELLOW}hcxtools not available in repos, skipping...${NC}"
            }
            
            # Install hashcat
            echo -e "${YELLOW}Installing hashcat...${NC}"
            apt install -y hashcat 2>/dev/null || {
                echo -e "${YELLOW}hashcat not available in repos, skipping...${NC}"
            }
            
            # Install john
            echo -e "${YELLOW}Installing john...${NC}"
            apt install -y john 2>/dev/null || {
                echo -e "${YELLOW}john not available in repos, skipping...${NC}"
            }
            ;;
            
        arch|manjaro)
            echo -e "${BLUE}Using pacman package manager${NC}"
            pacman -Syu --noconfirm
            pacman -S --noconfirm \
                aircrack-ng \
                bc \
                gawk \
                curl \
                cowpatty \
                dhcp \
                p7zip \
                hostapd \
                lighttpd \
                wireless_tools \
                macchanger \
                mdk4 \
                dsniff \
                nmap \
                openssl \
                php-cgi \
                xterm \
                rfkill \
                unzip \
                net-tools \
                psmisc \
                reaver \
                bully \
                pixiewps \
                python \
                python-pip \
                iw \
                ethtool \
                hashcat \
                john
            ;;
            
        fedora|rhel|centos)
            echo -e "${BLUE}Using dnf/yum package manager${NC}"
            if command -v dnf &> /dev/null; then
                PKG_MGR=dnf
            else
                PKG_MGR=yum
            fi
            
            $PKG_MGR update -y
            $PKG_MGR install -y \
                aircrack-ng \
                bc \
                gawk \
                curl \
                dhcp-server \
                p7zip \
                hostapd \
                lighttpd \
                wireless-tools \
                macchanger \
                nmap \
                openssl \
                php-cgi \
                xterm \
                rfkill \
                unzip \
                net-tools \
                psmisc \
                python3 \
                python3-pip \
                iw \
                ethtool
            ;;
            
        *)
            echo -e "${RED}Unsupported OS: $OS${NC}"
            echo "Please install dependencies manually"
            exit 1
            ;;
    esac
}

# Install Python dependencies
install_python_deps() {
    echo -e "${YELLOW}Installing Python dependencies...${NC}"
    python3 -m pip install --upgrade pip
    python3 -m pip install scapy pyric
}

# Main installation
main() {
    echo -e "${GREEN}Starting installation...${NC}"
    echo ""
    
    install_dependencies
    echo ""
    
    install_python_deps
    echo ""
    
    echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     Installation Complete!                 ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Run: ./fluxion.sh"
    echo "2. Select your wireless interface"
    echo "3. Choose your attack method"
    echo ""
    echo -e "${BLUE}For help, see:${NC}"
    echo "- README.md"
    echo "- docs/ENHANCEMENTS.md"
    echo "- https://github.com/FluxionNetwork/fluxion/wiki"
    echo ""
    echo -e "${YELLOW}Note: Make sure your wireless card supports monitor mode!${NC}"
    echo ""
}

# Run main installation
main
