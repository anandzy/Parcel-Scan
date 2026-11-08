#!/bin/bash

# Setup Script - Prepares the Xcode project for location tracking

set -e

echo "🔧 ParcelScan Setup Script"
echo "=========================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Find Xcode project
XCODEPROJ=$(find . -maxdepth 2 -name "*.xcodeproj" | head -n 1)

if [ -z "$XCODEPROJ" ]; then
    echo -e "${RED}❌ No .xcodeproj file found!${NC}"
    exit 1
fi

PROJECT_NAME=$(basename "$XCODEPROJ" .xcodeproj)
echo -e "${GREEN}✓ Found project: $PROJECT_NAME${NC}"

# Check required files
echo ""
echo -e "${BLUE}📄 Checking required files...${NC}"

FILES=("ParcelScanApp.swift" "ContentView.swift" "BarcodeScanner.swift" "LocationManager.swift")
ALL_EXIST=true

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file ${RED}(MISSING)${NC}"
        ALL_EXIST=false
    fi
done

if [ "$ALL_EXIST" = false ]; then
    echo ""
    echo -e "${RED}❌ Some required files are missing!${NC}"
    exit 1
fi

# Check Info.plist permissions
echo ""
echo -e "${BLUE}📝 Checking Info.plist...${NC}"

# Find Info.plist in common locations
INFOPLIST=$(find . -name "Info.plist" -not -path "*/Build/*" -not -path "*/DerivedData/*" | head -n 1)

if [ -z "$INFOPLIST" ]; then
    echo -e "${YELLOW}⚠️  Info.plist not found${NC}"
    echo "You may need to add permissions manually in Xcode"
else
    echo -e "${GREEN}✓ Found Info.plist: $INFOPLIST${NC}"
    
    # Check for required keys
    if grep -q "NSCameraUsageDescription" "$INFOPLIST"; then
        echo -e "${GREEN}✓${NC} Camera permission exists"
    else
        echo -e "${YELLOW}⚠️${NC}  Camera permission missing"
    fi
    
    if grep -q "NSLocationWhenInUseUsageDescription" "$INFOPLIST"; then
        echo -e "${GREEN}✓${NC} Location permission exists"
    else
        echo -e "${YELLOW}⚠️${NC}  Location permission missing"
    fi
fi

# Check for connected devices
echo ""
echo -e "${BLUE}📱 Checking for connected devices...${NC}"

DEVICES=$(xcrun xctrace list devices 2>&1 | grep -i "iphone" | grep -v "Simulator")

if [ -z "$DEVICES" ]; then
    echo -e "${YELLOW}⚠️  No iPhone connected${NC}"
    echo "Please connect your iPhone via USB"
else
    echo -e "${GREEN}✓ iPhone(s) connected:${NC}"
    echo "$DEVICES" | sed 's/^/  /'
fi

# Check code signing
echo ""
echo -e "${BLUE}🔐 Code Signing Status...${NC}"
echo "Opening Xcode to configure signing..."
echo ""
echo "In Xcode:"
echo "  1. Select your project in the navigator"
echo "  2. Select your target"
echo "  3. Go to 'Signing & Capabilities'"
echo "  4. Choose your Team from the dropdown"
echo "  5. Enable 'Automatically manage signing'"
echo ""

# Summary
echo ""
echo -e "${BLUE}📋 Setup Summary${NC}"
echo "================"
echo ""
if [ "$ALL_EXIST" = true ]; then
    echo -e "${GREEN}✓ All Swift files present${NC}"
else
    echo -e "${RED}✗ Missing Swift files${NC}"
fi

if [ -n "$INFOPLIST" ]; then
    echo -e "${GREEN}✓ Info.plist found${NC}"
else
    echo -e "${YELLOW}⚠️  Info.plist needs attention${NC}"
fi

if [ -n "$DEVICES" ]; then
    echo -e "${GREEN}✓ iPhone connected${NC}"
else
    echo -e "${YELLOW}⚠️  No iPhone connected${NC}"
fi

echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Open project: ${YELLOW}open \"$XCODEPROJ\"${NC}"
echo "  2. Configure code signing (select your Team)"
echo "  3. Ensure LocationManager.swift is in your target"
echo "  4. Verify Info.plist has camera & location permissions"
echo "  5. Run: ${YELLOW}./build.sh${NC} (or press Play in Xcode)"
echo ""
echo "Or open Xcode automatically:"
echo "  ${YELLOW}./setup.sh && open \"$XCODEPROJ\"${NC}"
echo ""
