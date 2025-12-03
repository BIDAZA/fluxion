#!/usr/bin/env bash

# FLUXION System Verification Script
# Checks if all dependencies and system requirements are met

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PASS="${GREEN}✓${NC}"
FAIL="${RED}✗${NC}"
WARN="${YELLOW}⚠${NC}"

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     FLUXION System Verification            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Track overall status
ALL_OK=true

# Check if running as root
echo -e "${YELLOW}Checking root privileges...${NC}"
if [[ $EUID -eq 0 ]]; then
    echo -e "$PASS Running as root"
else
    echo -e "$FAIL Not running as root (required for wireless operations)"
    ALL_OK=false
fi
echo ""

# Check critical dependencies
echo -e "${YELLOW}Checking critical dependencies...${NC}"

CRITICAL_DEPS=(
    "aircrack-ng"
    "bc"
    "awk"
    "curl"
    "hostapd"
    "lighttpd"
    "iwconfig"
    "macchanger"
    "mdk4"
    "nmap"
    "openssl"
    "php-cgi"
    "xterm"
    "rfkill"
    "unzip"
)

for dep in "${CRITICAL_DEPS[@]}"; do
    if command -v $dep &> /dev/null; then
        echo -e "$PASS $dep - installed"
    else
        echo -e "$FAIL $dep - not found"
        ALL_OK=false
    fi
done
echo ""

# Check optional but recommended tools
echo -e "${YELLOW}Checking recommended tools...${NC}"

RECOMMENDED_DEPS=(
    "hcxdumptool"
    "hcxpcapngtool"
    "hashcat"
    "john"
    "reaver"
    "bully"
    "pixiewps"
    "cowpatty"
)

for dep in "${RECOMMENDED_DEPS[@]}"; do
    if command -v $dep &> /dev/null; then
        echo -e "$PASS $dep - installed"
    else
        echo -e "$WARN $dep - not found (optional)"
    fi
done
echo ""

# Check Python and dependencies
echo -e "${YELLOW}Checking Python environment...${NC}"

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    echo -e "$PASS Python 3 - version $PYTHON_VERSION"
    
    # Check Python modules
    if python3 -c "import scapy" &> /dev/null; then
        echo -e "$PASS Python scapy module - installed"
    else
        echo -e "$FAIL Python scapy module - not found"
        echo -e "     Install with: pip3 install scapy"
        ALL_OK=false
    fi
    
    if python3 -c "import pyric" &> /dev/null; then
        echo -e "$PASS Python pyric module - installed"
    else
        echo -e "$WARN Python pyric module - not found (recommended)"
        echo -e "     Install with: pip3 install pyric"
    fi
else
    echo -e "$FAIL Python 3 - not found"
    ALL_OK=false
fi
echo ""

# Check wireless interfaces
echo -e "${YELLOW}Checking wireless interfaces...${NC}"

WIRELESS_INTERFACES=$(iw dev 2>/dev/null | awk '$1=="Interface"{print $2}')

if [ -z "$WIRELESS_INTERFACES" ]; then
    echo -e "$FAIL No wireless interfaces found"
    echo -e "     Make sure your wireless adapter is connected"
    ALL_OK=false
else
    echo -e "$PASS Wireless interfaces found:"
    for iface in $WIRELESS_INTERFACES; do
        echo "     - $iface"
        
        # Check if monitor mode is supported
        if iw phy phy$(iw dev $iface info | grep wiphy | awk '{print $2}') info 2>/dev/null | grep -q "monitor"; then
            echo -e "       $PASS Monitor mode supported"
        else
            echo -e "       $WARN Monitor mode support unknown"
        fi
    done
fi
echo ""

# Check X server
echo -e "${YELLOW}Checking X server...${NC}"

if [ -n "$DISPLAY" ]; then
    echo -e "$PASS X server detected (DISPLAY=$DISPLAY)"
    
    if command -v xdpyinfo &> /dev/null; then
        if xdpyinfo &> /dev/null; then
            echo -e "$PASS X server accessible"
        else
            echo -e "$FAIL X server not accessible"
            ALL_OK=false
        fi
    else
        echo -e "$WARN xdpyinfo not found (cannot verify X server)"
    fi
else
    echo -e "$FAIL No X server detected"
    echo -e "     FLUXION requires a graphical environment"
    ALL_OK=false
fi
echo ""

# Check system capabilities
echo -e "${YELLOW}Checking system capabilities...${NC}"

# Check if iptables is available
if command -v iptables &> /dev/null; then
    echo -e "$PASS iptables - available"
else
    echo -e "$FAIL iptables - not found"
    ALL_OK=false
fi

# Check if ip command is available
if command -v ip &> /dev/null; then
    echo -e "$PASS ip command - available"
else
    echo -e "$FAIL ip command - not found"
    ALL_OK=false
fi

# Check if dhcpd is available
if command -v dhcpd &> /dev/null; then
    echo -e "$PASS DHCP server - available"
else
    echo -e "$WARN DHCP server - not found (may be required for some attacks)"
fi
echo ""

# Final summary
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
if [ "$ALL_OK" = true ]; then
    echo -e "${GREEN}║     System verification PASSED ✓           ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Your system is ready to run FLUXION!${NC}"
    echo ""
    echo "Run: sudo ./fluxion.sh"
    exit 0
else
    echo -e "${RED}║     System verification FAILED ✗           ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}Some critical dependencies are missing.${NC}"
    echo ""
    echo "To install dependencies, run:"
    echo "  sudo ./scripts/setup.sh"
    echo ""
    echo "Or install manually based on the errors above."
    exit 1
fi
