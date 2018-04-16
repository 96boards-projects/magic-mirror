# Carbon Rover

# Table of Contents

- [1) Hardware](#1-hardware)
   - [1.1) Hardware requirements](#11-hardware-requirements)
- [2) Software](#2-software)
   - [2.1) Build Environment Setup](#21-build-environment-setup)
   - [2.2) API-Keys](#22-api-keys)
   - [2.3) Running the Application](#23-running-the-application)
- [3) Video Demonstration](#5-video-demonstration)
- [4) Change Log](#6-change-log)

# 1) Hardware

## 1.1) Hardware Requirements

- [Dragonboard-410c](https://www.96boards.org/product/dragonboard410c/)
- Compatible HDMI Monitor

# 2) Software

## 2.1) Build Environment Setup

### Setup ZRAM Swap

Although the project itself doesn't consume much RAM, the Qt Creator IDE can be
resource hungry so to be on the safe side its better to follow [this guide](https://www.96boards.org/documentation/consumer/guides/zram_swapspace.md.html)
to prevent random lock-ups.

### Install Qt5

- Make sure your Dragonboard-410c is connected to the internet.
- ```$ sudo apt install qt-creator libqt5* qt5*```

### Setting up project in Qt Creator

- Clone this repository:
  - ```$ git clone https://github.com/96boards-projects/magic-mirror```
- Open Qt Creator
  - Menu -> Programming -> Qt Creator
- Create a new QT Quick Project
  - New Project -> Qt Quick Application Swipe -> Give it an appropriate name -> Keep pressing next and accept the default config
- Copy Magic-Mirror Source Files
  - Copy all files from the repo folder to the project folder and replace existing Files

## 2.2) API-Keys

### Generate API Keys

The application requires api-keys for live updates for weather and news. To get the
api-keys and learn how to use the api data:

- [openweathermap](http://api.openweathermap.org)
- [newsapi](http://newsapi.org)

### Place api-keys in Source

Replace the following strings after adding your api-keys

- Page2Form.ui.qml line 27
- Page3Form.ui.qml line 9

## 2.3) Running the Application

Press the green play button or use Ctrl+R to run the application and you should see an output similar to this:
![](https://i.imgur.com/a8jnAEo.png)

4) Change Log

**Rev 0.1:**
- Finalized implementation of UI

**TODO:**
- Implement control using sensor with mraa, else fall back to touch
