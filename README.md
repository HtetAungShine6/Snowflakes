[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

# ❄️ Snowflake Agile Project Mobile App (iOS)

<p align="center">
  <a href="https://github.com/alexanderritik/Best-README-Template">
    <img src="logo.jpeg" alt="Logo" width="80" height="80">
  </a>
  <p align="center">
    This is the Snowflake Agile Project Mobile App, a tool built for iOS to help manage Agile workflows while integrating Snowflake's powerful cloud-based data handling. It’s designed to make project collaboration more interactive and engaging for both hosts and players.
  </p>
</p>

## 🖥️ Tech Stack  

### **Frontend**  
![Swift](https://img.shields.io/badge/Swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)  
- **Swift** for iOS development  
- **Xcode** for UI & development  

### **Backend**  
![C#](https://img.shields.io/badge/C%23-239120?style=for-the-badge&logo=csharp&logoColor=white)  
![ASP.NET](https://img.shields.io/badge/ASP.NET-5C2D91?style=for-the-badge&logo=dotnet&logoColor=white)  
- **C# & ASP.NET Core** for backend logic  
- **SignalR** for **real-time timer updates**  

### **Database & Storage**  
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)  
![Azure](https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)  
- **MongoDB** as NoSQL database  
- **Azure Blob Storage** for **image storage**  
- **Azure App Service** for API hosting  

---

## 📥 Frontend (iOS App)  

1. Open **Xcode**  
2. Load the `Snowflake.xcodeproj` file  
3. Run the project on the iOS simulator or device

## App Store :

You can download the Snowflake Playground app from the App Store:
[Download Snowflake Playground on the App Store](https://apps.apple.com/th/app/snowflake-playground/id6742320071)

### UI Preview:
![Host Timer Screen](![image](https://github.com/user-attachments/assets/63a017fd-9d5b-40dd-b3b6-b6560219bd27)
)
![Player Timer Screen](![image](https://github.com/user-attachments/assets/3d81cb5a-41e4-4558-9f63-2f479a006944)
)
![Leaderboard]![image](https://github.com/user-attachments/assets/e4384e57-f9bf-438a-bf7c-bbe749f36602)
)


## 🌟 Features

### For Hosts
- Set up games with rounds, timers, teams, tokens, and shop items.
- Manage teams, resources, and transactions in real-time.
- Control timers, send updates, and enable/disable shop items.
- View post-game highlights in the Snowflake Gallery and Leaderboard.

### For Players
- Join teams, manage resources, and earn tokens by capturing Snowflake photos.
- Shop for items and receive real-time updates from the host.
- Celebrate achievements in the Snowflake Gallery and check team rankings on the Leaderboard.

### Shared Features
- Use session codes: Host Room Code for managing, Player Room Code for joining.
- Enjoy real-time interaction and a gamified, visually engaging experience.

## Requirements

- iOS 18.0+
- Xcode 16.1

## Installation

### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `YourLibrary` by adding it to your `Podfile`:

```ruby
platform :ios, '18.0'
use_frameworks!
pod 'YourLibrary'
