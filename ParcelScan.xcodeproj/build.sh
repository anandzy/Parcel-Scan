#!/bin/bash

# ParcelScan Auto-Build Script
# This script automates building and installing the app to your connected iPhone

set -e  # Exit on error

echo "🚀 ParcelScan Auto-Build Script"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Find the .xcodeproj file
echo -e "${BLUE}📁 Looking for Xcode project...${NC}"
XCODEPROJ=$(find . -maxdepth 2 -name "*.xcodeproj" | head -n 1)

if [ -z "$XCODEPROJ" ]; then
    echo -e "${RED}❌ No .xcodeproj file found!${NC}"
    echo "Please make sure you're running this script from your project directory."
    exit 1
fi

PROJECT_NAME=$(basename "$XCODEPROJ" .xcodeproj)
echo -e "${GREEN}✓ Found project: $PROJECT_NAME${NC}"
echo ""

# Check if xcodebuild is available
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ xcodebuild not found. Please install Xcode Command Line Tools.${NC}"
    exit 1
fi

# Get the scheme name (usually same as project name)
SCHEME=$PROJECT_NAME

# List connected devices
echo -e "${BLUE}📱 Looking for connected devices...${NC}"
DEVICE_ID=$(xcrun xctrace list devices 2>&1 | grep -i "iphone" | grep -v "Simulator" | head -n 1 | sed 's/.*(\([^)]*\)).*/\1/')

if [ -z "$DEVICE_ID" ]; then
    echo -e "${YELLOW}⚠️  No iPhone detected via USB${NC}"
    echo "Please:"
    echo "  1. Connect your iPhone via USB"
    echo "  2. Unlock your device"
    echo "  3. Trust this computer if prompted"
    echo "  4. Run this script again"
    exit 1
fi

echo -e "${GREEN}✓ Found iPhone (ID: ${DEVICE_ID})${NC}"
echo ""

# Add LocationManager.swift to project if not already added
echo -e "${BLUE}📄 Checking project files...${NC}"
if [ -f "LocationManager.swift" ]; then
    echo -e "${GREEN}✓ LocationManager.swift exists${NC}"
else
    echo -e "${RED}❌ LocationManager.swift not found${NC}"
    exit 1
fi

# Check for Info.plist
if [ -f "Info.plist" ]; then
    echo -e "${GREEN}✓ Info.plist exists${NC}"
else
    echo -e "${YELLOW}⚠️  Info.plist not found in root directory${NC}"
fi
echo ""

# Clean build folder
echo -e "${BLUE}🧹 Cleaning build folder...${NC}"
xcodebuild clean -project "$XCODEPROJ" -scheme "$SCHEME" -quiet
echo -e "${GREEN}✓ Build folder cleaned${NC}"
echo ""

# Build the app
echo -e "${BLUE}🔨 Building app for device...${NC}"
echo "This may take a minute..."

xcodebuild build \
    -project "$XCODEPROJ" \
    -scheme "$SCHEME" \
    -destination "id=$DEVICE_ID" \
    -configuration Debug \
    CODE_SIGN_STYLE=Automatic \
    | xcpretty 2>/dev/null || cat

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo -e "${RED}❌ Build failed!${NC}"
    echo ""
    echo "Common issues:"
    echo "  1. Code signing not configured - Open project in Xcode and select your Team"
    echo "  2. Files not added to target - Add LocationManager.swift in Xcode"
    echo "  3. Missing permissions in Info.plist"
    echo ""
    echo "Run 'open $XCODEPROJ' to fix these issues in Xcode."
    exit 1
fi

echo -e "${GREEN}✓ Build successful!${NC}"
echo ""

# Install and run on device
echo -e "${BLUE}📲 Installing app on iPhone...${NC}"

xcodebuild install \
    -project "$XCODEPROJ" \
    -scheme "$SCHEME" \
    -destination "id=$DEVICE_ID" \
    | xcpretty 2>/dev/null || cat

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo -e "${YELLOW}⚠️  Automatic installation failed${NC}"
    echo "The app was built successfully, but couldn't be automatically installed."
    echo "Please open Xcode and press the Run button to install it manually."
    echo ""
    echo "Opening Xcode..."
    open "$XCODEPROJ"
    exit 0
fi

echo ""
echo -e "${GREEN}🎉 SUCCESS!${NC}"
echo ""
echo "✓ App built successfully"
echo "✓ App installed on your iPhone"
echo ""
echo "Next steps on your iPhone:"
echo "  1. Launch the ParcelScan app"
echo "  2. Tap 'Allow' for Camera access"
echo "  3. Tap 'Allow While Using App' for Location access"
echo "  4. Point camera at a barcode to test"
echo ""
echo "📍 Location will update every 60 seconds automatically!"
echo ""
