[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

# ❄️ Snowflake Agile Project Mobile App (iOS)

<p align="center">
  <img src="https://github.com/user-attachments/assets/06c24a4e-ade3-482f-9c49-176de9ea830c" alt="Logo" width="80" height="80">
</p>

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

## 🌟 Features

### For Hosts
- Set up games with rounds, timers, teams, tokens, and shop items.
- Manage teams, resources, and transactions in real-time.
- Control timers, send updates, and buy/reject snowflake.
- View post-game highlights in the Snowflake Gallery and Leaderboard.

### For Players
- Join teams, manage resources, and earn tokens by capturing Snowflake photos.
- Shop for items and receive real-time updates from the host.
- Celebrate achievements in the Snowflake Gallery and check team rankings on the Leaderboard.

### Shared Features
- Use session codes: Host Room Code for managing, Player Room Code for joining.
- Enjoy real-time interaction and a gamified, visually engaging experience.

### 🌐 Live API
Swagger API: https://snowflakeapi-bkd0aygebke4fscg.southeastasia-01.azurewebsites.net/swagger/index.html

### UI Preview [Host]:
<p align="center">
  <img src="https://github.com/user-attachments/assets/9d74a6d8-12f3-474e-9e66-d02f458d46d2" alt="Host Screen" width="300"/>
  <img src="https://github.com/user-attachments/assets/869aa220-31fd-48aa-a44b-7dbc55cdf6fc" alt="Setting" width="300"/>
  <img src="https://github.com/user-attachments/assets/96ffb4ba-3add-417f-ad3f-a852ef8f3531" alt="Host Timer Screen" width="300"/>
  <img src="https://github.com/user-attachments/assets/63a017fd-9d5b-40dd-b3b6-b6560219bd27" alt="Shop Timer Screen" width="300"/>
  <img src="https://github.com/user-attachments/assets/92cb75b8-db41-4abf-8b17-4cf1a5ee2099" alt="Shop" width="300"/>
  <img src="https://github.com/user-attachments/assets/09d5d303-06e2-45e8-be2f-c07a1ff50178" alt="Shop Team Details" width="300"/>
  <img src="https://github.com/user-attachments/assets/e4384e57-f9bf-438a-bf7c-bbe749f36602" alt="Leaderboard" width="300"/>
</p>

### UI Preview [Player]:
<p align="center">
  <img src="https://github.com/user-attachments/assets/96c2aec3-2052-47a3-8a57-93f84dca5bdc" alt="Join a room" width="300"/>
  <img src="https://github.com/user-attachments/assets/d008e554-01df-4553-9d02-7b897b854951" alt="Team List Joining" width="300"/>
  <img src="https://github.com/user-attachments/assets/3d81cb5a-41e4-4558-9f63-2f479a006944" alt="Player Timer Screen" width="300"/>
  <img src="https://github.com/user-attachments/assets/36598f0e-d568-4abe-9bbb-d9bddc06e09c" alt="Shop Timer Screen" width="300"/>
  <img src="https://github.com/user-attachments/assets/cec1b08c-b926-4283-9a57-4aaa60f3d2db" alt="Shop" width="300"/>
  <img src="https://github.com/user-attachments/assets/e4384e57-f9bf-438a-bf7c-bbe749f36602" alt="Leaderboard" width="300"/>
</p>

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
