iOS7-Lockscreen
===============

A prototyped lockscreen for any iOS7 application. Has the proper logic and saves the entered passcode to the NSUserDefaults of the device.
The info button at the upper right of the lock screen is for "cheat access" in order to bypass/reset code. Should be removed in any real application.
After 5 failed passcode attempts, there is an alert presented to notify the user that if they aren't the phone's owner they shouldn't be trying to use it.


![Preview](https://raw.github.com/jpwidmer/iOS7-Lockscreen/master/Preview.png)

Todo: 
- Add new passcode verification
- Take a picture of the user after 5 failed attempts and present it upon successful login
