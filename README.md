# CIDepthBlurEffect-iOS14-bug

This repository demonstrates a regression with CIDepthBlurEffect on iOS 14 when rendering images captured using iPhone 12 Pro and 12 Pro Max.

There are two primary issues we have identified:

1. When initializing the filter using CIContext's [fully expressive initializer](https://developer.apple.com/documentation/coreimage/cicontext/3600105-depthblureffectfilter), which we need in order to manipulate the blur, the resulting blur does not match the system-standard blur.  

2. When using the [imageData variant](https://developer.apple.com/documentation/coreimage/cicontext/3020629-depthblureffectfilter) of the CIContext API, the blur does work correclty, however, manipulating practically any of the properties causes the blur to fail completely.

This sample app demonstrates the second point (since the first point is difficult to demonstrate with arbitrary photo libraries). It ought to be fairly self explanatory, but to demonstrate the issue,
we have also provided a video you can watch at the following URL: [https://www.dropbox.com/s/zg9tc1blj4mxqkp/Blur%20Test.MP4](https://www.dropbox.com/s/zg9tc1blj4mxqkp/Blur%20Test.MP4)
