Purpose
--------------

FXImageView is a class designed to simplify the application of common visual effects such as reflections and drop-shadows to images. FXImageView includes sophisticated queuing and caching logic to maximise performance when rendering these effects in real time.

As a bonus, FXImageView includes a standalone UIImage category for cropping, scaling and applying effects directly to an image.


Supported iOS & SDK Versions
-----------------------------

* Supported build target - iOS 8.0 (Xcode 6.0, Apple LLVM compiler 6.0)
* Earliest supported deployment target - iOS 5.0
* Earliest compatible deployment target - iOS 4.3

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

As of version 1.3, FXImageView requires ARC. If you wish to use FXImageView in a non-ARC project, just add the -fobjc-arc compiler flag to the FXImageView.m class. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click FXImageView.m in the list and type -fobjc-arc into the popover.

If you wish to convert your whole project to ARC, comment out the #error line in FXImageView.m, then run the Edit > Refactor > Convert to Objective-C ARC... tool in Xcode and make sure all files that you wish to use ARC for (including FXImageView.m) are checked.


Thread Safety
--------------

FXImageView is derived from UIView and - as with all UIKit components - it should only be accessed from the main thread. FXImageView uses threads internally to avoid blocking user interaction, but FXImageView's properties should only ever be accessed from the main thread.

The UIImage(FX) category methods are all thread-safe and may safely be called concurrently from multiple threads on the same UIImage instance.


Installation
---------------

To use FXImageView, just drag the class files into your project. You can create FXImageViews programatically, or create them in Interface Builder by dragging an ordinary UIImageView into your view and setting its class to FXImageView.


UIImage extension methods
---------------------------

    - (UIImage *)imageCroppedToRect:(CGRect)rect;
    
Returns a copy of the image cropped to the specified rectangle (in image coordinates).
    
    - (UIImage *)imageScaledToSize:(CGSize)size;
    
Returns a copy of  the image scaled to the specified size. This method may change the aspect ratio of the image.
    
    - (UIImage *)imageScaledToFitSize:(CGSize)size;
    
Returns a copy of the image scaled to fit the specified size without changing its aspect ratio. The resultant image may be smaller than the size specified in one dimension if the aspect ratios do not match. No padding will be added.
    
    - (UIImage *)imageScaledToFillSize:(CGSize)size;
    
Returns a copy of the image scaled to fit the specified size without changing its aspect ratio. If the image aspect ratio does not match the aspect ratio of the size specified, the image will be cropped to fit.
    
    - (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                                 contentMode:(UIViewContentMode)contentMode
                                    padToFit:(BOOL)padToFit;
    
Returns a copy of the image scaled and/or cropped to the specified size using the specified UIViewContentMode. This method is useful for matching the effect of UIViewContentMode on an image when displayed in a UIImageView. If the padToFit argument is NO, the resultant image may be smaller than the size specified is the aspect ratios do not match. If padToFit is YES, additional transparent pixels will be added around the image to pad it out to the size specified.
    
    - (UIImage *)reflectedImageWithScale:(CGFloat)scale;
    
Returns a vertically reflected copy of the image that tapers off to transparent with a gradient. The scale parameter determines that point at which the image tapers off and should have a value between 0.0 and 1.0.
    
    - (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha;
    
Returns a copy of the image that includes a reflection with the specified scale, separation gap and alpha (opacity). The original image will be vertically centered within the new image, with he space above the image padded out with transparent pixels matching the height of the reflection below. This makes it easier to position the image within a UIImageView.
    
    - (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
    
Returns a copy of the image with a drop shadow rendered with the specified color, offset and blur. Regardless of the offset value, the original image will be vertically centered within the new image to make it easier to position the image within a UIImageView.

    - (UIImage *)imageWithCornerRadius:(CGFloat)radius;

Returns a copy of the image with the corners clipped to the specified curvature radius.

    - (UIImage *)imageWithAlpha:(CGFloat)alpha;

Returns a copy of the image with the specified alpha (opacity). The alpha is multiplied by the image's original alpha channel, so this method can only be used to make the image more transparent, not more opaque.

    - (UIImage *)imageWithMask:(UIImage *)maskImage;
    
Clips the image using the specified mask image. The mask image should be an opaque, greyscale alpha mask. If you wish to use a transparent mask image, use the `maskImageFromImageAlpha` method to convert it to the correct format.
    
    - (UIImage *)maskImageFromImageAlpha;

This method extracts the alpha channel from an image that has an embedded alpha mask and returns it as a standalone greyscale mask image, suitable for use with the `imageWithMask:` method.


FXImageView class methods
-----------------------

    + (NSOperationQueue *)processingQueue;
    
This is the shared NSOperationQueue used for queuing FXImageView images for processing. You can use this method to manipulate the `maxConcurrentOperationCount` for the queue, which may be useful when fine tuning performance. The default maximum concurrent operation count is 4.
    
    + (NSCache *)processedImageCache;
    
This is the shared NSCache used to cache processed FXImageView images for reuse. iOS automatically manages clearing this cache when iOS runs low on memory, but you may wish to manipulate the `countLimit` value, or manually clear the cache at specific points in your app.


FXImageView methods
--------------------

    - (void)setImage:(UIImage *)image;
    
This method is the setter method for the image property. See the image property documentation below.
    
    - (void)setImageWithContentsOfFile:(NSString *)file;
    
This method sets the image by loading it from the specified file. If the specified file is not an absolute path it is assumed to be a relative path within with the application bundle resources directory. If the file does not include an extension it is assumed to be a PNG. If the `asynchronous` property is set, the file will be loaded on a background thread.
    
    - (void)setImageWithContentsOfURL:(NSURL *)URL;
    
This method sets the image by loading it from the specified URL. If the `asynchronous` property is enabled, the image will be loaded on a background thread. The specified URL can be either a local or remote file, but note that loading remote URLs in synchronous mode is not recommended as it will block the main thread for an indeterminate time.


FXImageView properties
-----------------------

    @property (nonatomic, assign, getter = isAsynchronous) BOOL asynchronous;
    
The shadow and reflection effects take time to render. In many cases this will be imperceptible, but for high-performance applications such as a scrolling carousel, this rendering delay may cause stuttering in the animation. This method toggles whether the shadow and reflection effects are applied immediately on the main thread (asynchronous = NO), or rendered in a background thread (asynchronous = YES). By rendering the effects in the background, the performance issues can be avoided. Defaults to NO.

    @property (nonatomic, assign) NSTimeInterval crossfadeDuration;

This property controls the duration of the crossfade animation when the image finishes processing and is displayed, measured in seconds. The default duration is 0.25. Set the duration to zero to disable the crossfade altogether.
    
    @property (nonatomic, assign) CGFloat reflectionGap;
    
The gap between the image and its reflection, measured in pixels (or points on a Retina Display device). This defaults to zero.
    
    @property (nonatomic, assign) CGFloat reflectionScale;
    
The height of the reflection relative to the image. Should be in the range 0.0 to 1.0. Defaults to 0.0 (no reflection).
    
    @property (nonatomic, assign) CGFloat reflectionAlpha;
    
The opacity of the reflection. Should be in the range 0.0 to 1.0. Defaults to 0.0 (completely transparent).

	@property (nonatomic, strong) UIColor *shadowColor;
	
The colour of the shadow (defaults to black).
	
	@property (nonatomic, assign) CGSize shadowOffset;
	
The offset for the shadow, in points/pixels. Defaults to CGSizeZero (no shadow).

	@property (nonatomic, assign) CGFloat shadowBlur;
	
The softness of the image shadow. Defaults to zero, which creates a hard shadow.

    @property (nonatomic, assign) CGFloat cornerRadius;

The radius of the curved corner clipping. Set this to zero to disable curved corners.

    @property (nonatomic, strong) UIImage *image;
    
This property is inherited from UIImageView, but the behaviour is different. Setting this property does not set the image directly but instead applies the specified effects and then displays the processed image. If the `asynchronous` property is set, this processing happens in a background thread, so the image will not appear immediately. Accessing the image property getter will return the original, unprocessed image.

    @property (nonatomic, strong) UIImage *processedImage;

The resultant image after applying reflection and shadow effects. It can sometimes be useful to set and get this directly, for example you may wish to set a placeholder image whilst the image is being processed, or retrieve and store the processed image so it can be cached for re-use later without needing to be re-generated from the original image (note that FXImageView already includes in-memory caching of processed images).

    @property (nonatomic, copy) UIImage *(^customEffectsBlock)(UIImage *image);
    
If you want to apply a custom effect to your image, you can do your custom drawing using the `customEffectsBlock` property. The block is passed the correctly cropped and scaled image, and you code should return a new version with your custom effects applied. Your custom drawing block is applied prior to any other effects (apart from cropping and scaling).   FXImageView's caching mechanism doesn't know about your custom effects, so if your app uses multiple effects blocks, or your block relies on any external data, you should update the `customEffectsIdentifier` property so that the FXImageView cache can handle it correctly. Note that you should ensure that your block code is thread-safe if used in asynchronous mode.
     
    @property (nonatomic, copy) NSString *cacheKey;
    
FXImageView caches processed images based on the image object or URL that you specify, combined with the specific set of effects you've selected. This mechanism works effectively in most cases, but for image objects that are generated on the fly, or ones that are loaded from the ALAssets library, you don't get any benefit from the caching because the same image objects are never used twice. In these cases you can improve performance by using a custom cache key. The key can be any string, the only requirement is that is should be unique for each unique image & effects combination that you use with FXImageView. If you are displaying your images in a carousel, a string based on the carousel item index would be a good choice for the cache key. Set the cacheKey property to nil to revert to the default cache key calculation.


Release notes
----------------

Version 1.3.5

- Fixed a bug where setting the highlighted property of the FXImageView would break it (this could happen if FXImageView was placed inside a UICollectionViewCell)

Version 1.3.4

- Fixed a bug where FXImageViews could lose their styling under some circumstances

Version 1.3.3

- Fixed rendering bug on iOS 7.1
- No longer uses internal UIImageView

Version 1.3.2

- Now complies with -Weverything warning level
- Fixed KVO example

Version 1.3.1

- Added QuartzCore import to fix podspecs issue

Version 1.3

- Added crossfadeDuration property to control or disable crossfade effect
- Now requires ARC
- Now complies with -Wall and -Wextra warning levels
- Cache is now cleared in the event of a low-memory warning

Version 1.2.3

- Fixed potential crash when using custom effects block
- Replaced customEffectsIdentifier property with more generally useful cacheKey
- Fixed a compiler warning in UIImage+FX category

Version 1.2.2

- Fixed some additional caching bugs
- FXImageView is now KVO-compliant for the image and processedImage properties
- Added KVO example

Version 1.2.1

- Removed setWithBlock: method due to unresolvable caching issue
- Added some additional UIImage+FX methods
- Fixed some caching bugs

Version 1.2

- Added corner radius clipping effect
- Added custom effects block property for applying custom effects
- Added setWithContentsOfFile/URL: methods for dynamic loading/downloading
- Added setWithBlock: method for dynamic image generation or loading logic

Version 1.1.2

- Fixed potential crash when processingQueue maxConcurrentOperationCount is set to -1 (unlimited)
- Added Advanced Example

Version 1.1.1

- Performance improvements

Version 1.1

- Added LIFO queuing for process operations
- Added caching for processed images
- Fixed some bugs

Version 1.0

- Initial release