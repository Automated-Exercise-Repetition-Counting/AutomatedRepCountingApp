# Pūioio

An app to automatically count exercise repetitions, built on top of Google's ML Kit.

This app contains a git submodule containing the optical flow plugin, [native_opencv](https://github.com/Automated-Exercise-Repetition-Counting/native_opencv). This must be initialised when cloning the repo by executing:

1. `git submodule init`
2. `git submodule update`

Once initialised, change into the native_opencv subdirectory. From here, download the Android SDK from [Source forge](https://sourceforge.net/projects/opencvlibrary/files/4.5.5/opencv-4.5.5-android-sdk.zip/download).

With this installed, note the path that the unzipped sdk is located at. Paste this path into the [`CMakeLists.txt`](native_opencv\android\CMakeLists.txt) file in the `android` folder, on line `6`.