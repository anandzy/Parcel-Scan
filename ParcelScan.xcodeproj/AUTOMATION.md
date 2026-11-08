# 🚀 Automated Installation Guide

## ⚡ Quick Start (Easiest Method)

Just run this one command in Terminal:

```bash
chmod +x install.sh && ./install.sh
```

This will:
- ✅ Check all required files
- ✅ Verify your iPhone is connected
- ✅ Open Xcode automatically
- ✅ Guide you through the final steps

---

## 📋 Three Automated Scripts

I've created three scripts to help you:

### 1. **install.sh** - One Command Install (Recommended)
The easiest way to get started.

```bash
chmod +x install.sh
./install.sh
```

### 2. **setup.sh** - Check Everything
Verifies your project is ready to build.

```bash
chmod +x setup.sh
./setup.sh
```

### 3. **build.sh** - Build & Install to iPhone
Builds and installs the app (after Xcode setup is done).

```bash
chmod +x build.sh
./build.sh
```

---

## 🎯 Complete Step-by-Step Process

### Method A: Automated Script (Fastest)

1. **Open Terminal** and navigate to your project folder:
   ```bash
   cd /path/to/your/ParcelScan
   ```

2. **Run the install script**:
   ```bash
   chmod +x install.sh && ./install.sh
   ```

3. **In Xcode** (which will open automatically):
   - Add `LocationManager.swift` to your target (File → Add Files)
   - Select your Team in Signing & Capabilities
   - Press ▶️ Play button

4. **On your iPhone**:
   - Allow Camera access
   - Allow Location access

### Method B: Manual Xcode Method

1. **Open your project**:
   ```bash
   open ParcelScan.xcodeproj
   ```

2. **Add LocationManager.swift**:
   - Right-click in Project Navigator
   - "Add Files to ParcelScan..."
   - Select `LocationManager.swift`
   - Ensure target is checked
   - Click "Add"

3. **Update Info.plist**:
   - Find your Info.plist in the project
   - Add these keys:
     - `NSCameraUsageDescription`: "We need camera access to scan barcodes and QR codes for parcel tracking."
     - `NSLocationWhenInUseUsageDescription`: "We need your location to track where parcel scans occur."

4. **Configure Signing**:
   - Select project → Target → Signing & Capabilities
   - Choose your Team
   - Enable "Automatically manage signing"

5. **Select your iPhone** from the device dropdown

6. **Press ▶️ Play** button (or Cmd+R)

---

## 🔍 Troubleshooting Script Errors

### "Permission denied" error
```bash
chmod +x install.sh setup.sh build.sh
```

### "No .xcodeproj file found"
Make sure you're in the correct directory:
```bash
ls -la *.xcodeproj
```

### "No iPhone detected"
1. Connect your iPhone via USB
2. Unlock your device
3. Trust this computer when prompted
4. Run the script again

### "xcodebuild not found"
Install Xcode Command Line Tools:
```bash
xcode-select --install
```

---

## ✅ Verification

After the app installs, you should see:

- 📷 Camera view with barcode scanner
- 📍 Green location icon with coordinates
- 🕐 Location updates every 60 seconds in Xcode console

In Xcode's console, look for:
```
📍 Location updated: 37.3349, -122.0090
```

---

## 🎯 What Each Script Does

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `install.sh` | All-in-one setup | First time setup |
| `setup.sh` | Verify configuration | Check if everything is ready |
| `build.sh` | Build and install | After Xcode is configured |

---

## 📱 Expected Behavior

Once installed:

1. **App launches** → Asks for Camera permission
2. **After allowing camera** → Asks for Location permission
3. **After allowing location** → Location tracking starts automatically
4. **Every 60 seconds** → New location is captured
5. **Scan a barcode** → Location is included in the data sent to server

---

## 💡 Pro Tips

- **First time?** Use `install.sh` - it does everything
- **Already configured?** Use `build.sh` to rebuild quickly
- **Check status?** Use `setup.sh` to verify everything
- **See logs?** Keep Xcode open to see location updates in the console

---

## 🆘 Still Need Help?

If automation fails, the manual method in Xcode always works:
1. Open project in Xcode
2. Add `LocationManager.swift` to target
3. Update Info.plist with permissions
4. Select Team for signing
5. Press Play button

The code is 100% ready - you just need to add the file to Xcode and build!

---

**Ready? Open Terminal and run:**

```bash
chmod +x install.sh && ./install.sh
```

🎉 Your app will be running in minutes!
