//
//  ViewController.m
//  DepthBlurFilterTest
//
//  Created by Majd Taby on 12/7/20.
//

#import "ViewController.h"
@import Photos;
@import PhotosUI;

@interface ViewController () <PHPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *scaleFactorSwitch;

@property (strong, nonatomic) NSData *imageData;
@property (assign, nonatomic) CGImagePropertyOrientation orientation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.scaleFactorSwitch.enabled = NO;
    
    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            
    }];
    
}

- (IBAction)pickPortraitPhoto:(id)sender {
    PHPickerConfiguration *config = [[PHPickerConfiguration alloc] initWithPhotoLibrary:[PHPhotoLibrary sharedPhotoLibrary]];
    
    PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers: @[results.firstObject.assetIdentifier] options:nil].firstObject;
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.scaleFactorSwitch.enabled = YES;
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.version = PHImageRequestOptionsVersionOriginal;
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:asset
                                                                    options:options
                                                              resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
        self.imageData = imageData;
        self.orientation = orientation;
        [self render];
    }];
}

- (IBAction)scaleFactorChanged:(UISwitch *)sender {
    [self render];
}

- (void)render {
    CIContext *context = [CIContext context];
    CIFilter *filter = [context depthBlurEffectFilterForImageData:self.imageData options:nil];
    
    [filter setValue:@(self.scaleFactorSwitch.on? 0.5 : 1.0) forKey:kCIInputScaleFactorKey];
    
    CIImage *orientedImage = [filter.outputImage imageByApplyingCGOrientation:self.orientation];
    CGImageRef renderedImage = [context createCGImage:orientedImage fromRect:orientedImage.extent];
    UIImage *uiimage = [UIImage imageWithCGImage:renderedImage];
    self.imageView.image = uiimage;
}

@end
    