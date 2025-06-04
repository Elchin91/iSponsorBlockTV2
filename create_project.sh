#!/bin/bash

# Скрипт для создания базового Xcode проекта iSponsorBlockTV
# Создан для использования в GitHub Actions

echo "Создание базового Xcode проекта..."

# Создаем структуру папок
mkdir -p iSponsorBlockTV
mkdir -p iSponsorBlockTV/Base.lproj
mkdir -p iSponsorBlockTV/Assets.xcassets/AppIcon.appiconset
mkdir -p iSponsorBlockTV/Assets.xcassets/AccentColor.colorset

# Создаем исходные файлы Swift
cat > iSponsorBlockTV/AppDelegate.swift << 'EOF'
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
EOF

cat > iSponsorBlockTV/ViewController.swift << 'EOF'
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "iSponsorBlockTV"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
EOF

# Создаем storyboard файлы
cat > iSponsorBlockTV/Base.lproj/Main.storyboard << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="21701" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES" initialViewController="BYZ-38-t0r">
    <device id="retina6_12" orientation="portrait" appearance="light"/>
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="21679"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="System colors in document" minToolsVersion="11.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <scenes>
        <scene sceneID="tne-QT-ifu">
            <objects>
                <viewController id="BYZ-38-t0r" customClass="ViewController" customModule="iSponsorBlockTV" customModuleProvider="target" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="8bC-Xf-vdC">
                        <rect key="frame" x="0.0" y="0.0" width="393" height="852"/>
                        <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                        <viewLayoutGuide key="safeArea" id="6Tk-OE-BBY"/>
                        <color key="backgroundColor" systemColor="systemBackgroundColor"/>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="dkx-z0-nzr" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="132" y="4"/>
        </scene>
    </scenes>
    <resources>
        <systemColor name="systemBackgroundColor">
            <color white="1" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
        </systemColor>
    </resources>
</document>
EOF

cat > iSponsorBlockTV/Base.lproj/LaunchScreen.storyboard << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="21701" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES" initialViewController="01J-lp-oVM">
    <device id="retina6_12" orientation="portrait" appearance="light"/>
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="21679"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="System colors in document" minToolsVersion="11.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <scenes>
        <scene sceneID="EHf-IW-A2E">
            <objects>
                <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
                        <rect key="frame" x="0.0" y="0.0" width="393" height="852"/>
                        <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                        <viewLayoutGuide key="safeArea" id="6Tk-OE-BBY"/>
                        <color key="backgroundColor" systemColor="systemBackgroundColor"/>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="iYj-Kq-Ea1" userLabel="First Responder" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="53" y="375"/>
        </scene>
    </scenes>
    <resources>
        <systemColor name="systemBackgroundColor">
            <color white="1" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
        </systemColor>
    </resources>
</document>
EOF

# Создаем Assets.xcassets
cat > iSponsorBlockTV/Assets.xcassets/Contents.json << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

cat > iSponsorBlockTV/Assets.xcassets/AppIcon.appiconset/Contents.json << 'EOF'
{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

cat > iSponsorBlockTV/Assets.xcassets/AccentColor.colorset/Contents.json << 'EOF'
{
  "colors" : [
    {
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Устанавливаем xcodegen если его нет
if ! command -v xcodegen &> /dev/null; then
    echo "Устанавливаем xcodegen..."
    brew install xcodegen
fi

# Создаем project.yml для xcodegen
cat > project.yml << 'EOF'
name: iSponsorBlockTV
options:
  bundleIdPrefix: com.elchin91
  deploymentTarget:
    iOS: 14.0
targets:
  iSponsorBlockTV:
    type: application
    platform: iOS
    sources:
      - iSponsorBlockTV
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.elchin91.isponsorblockTV
      CODE_SIGN_STYLE: Manual
      CODE_SIGNING_REQUIRED: NO
      CODE_SIGNING_ALLOWED: NO
      CODE_SIGN_IDENTITY: ""
      DEVELOPMENT_TEAM: ""
      PROVISIONING_PROFILE_SPECIFIER: ""
      INFOPLIST_FILE: iSponsorBlockTV/Info.plist
      MARKETING_VERSION: 1.0
      CURRENT_PROJECT_VERSION: 1
      TARGETED_DEVICE_FAMILY: "1,2"
      SWIFT_VERSION: 5.0
schemes:
  iSponsorBlockTV:
    build:
      targets:
        iSponsorBlockTV: all
    run:
      config: Debug
    archive:
      config: Release
EOF

# Генерируем проект с помощью xcodegen
echo "Генерируем Xcode проект..."
xcodegen generate

# Делаем скрипт исполняемым
chmod +x create_project.sh

echo "Базовый Xcode проект создан успешно!" 