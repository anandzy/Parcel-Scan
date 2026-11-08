#!/bin/bash

# Quick Install Script - One command to rule them all!

set -e

echo "⚡ ParcelScan Quick Install"
echo "==========================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Make scripts executable
chmod +x setup.sh 2>/dev/null || true
chmod +x build.sh 2>/dev/null || true

# Step 1: Run setup check
echo -e "${BLUE}Step 1: Running setup check...${NC}"
echo ""
./setup.sh

# Step 2: Check if iPhone is connected
DEVICE_ID=$(xcrun xctrace list devices 2>&1 | grep -i "iphone" | grep -v "Simulator" | head -n 1 | sed 's/.*(\([^)]*\)).*/\1/')

if [ -z "$DEVICE_ID" ]; then
    echo ""
    echo -e "${RED}❌ Please connect your iPhone and run this script again${NC}"
    exit 1
fi

# Step 3: Find and open Xcode project
XCODEPROJ=$(find . -maxdepth 2 -name "*.xcodeproj" | head -n 1)

if [ -z "$XCODEPROJ" ]; then
    echo -e "${RED}❌ No Xcode project found${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: Manual step required${NC}"
echo ""
echo "I'm opening Xcode now. Please:"
echo ""
echo "  1. ${BLUE}Wait for Xcode to fully load${NC}"
echo "  2. ${BLUE}In the Project Navigator (left sidebar), right-click${NC}"
echo "  3. ${BLUE}Select 'Add Files to [Project]...'${NC}"
echo "  4. ${BLUE}Select 'LocationManager.swift' and click Add${NC}"
echo "  5. ${BLUE}Go to Signing & Capabilities tab${NC}"
echo "  6. ${BLUE}Select your Team${NC}"
echo "  7. ${BLUE}Press the ▶️ Play button${NC}"
echo ""
echo -e "Opening Xcode in 3 seconds..."
sleep 3

open "$XCODEPROJ"

echo ""
echo -e "${GREEN}✓ Xcode opened${NC}"
echo ""
echo "After adding the file and configuring signing in Xcode,"
echo "you can also build from the command line by running:"
echo ""
echo "  ${YELLOW}./build.sh${NC}"
echo ""
echo "📍 Location tracking will start automatically when the app launches!"
echo ""
