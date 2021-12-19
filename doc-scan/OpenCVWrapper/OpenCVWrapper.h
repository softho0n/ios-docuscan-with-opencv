#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject
+(NSString *) openCVVersionString;
+(UIImage *) docuscan : (UIImage *) image : (CGFloat) resizing_width : (CGFloat) resizing_height : (CGFloat) scan_img_width : (CGFloat) scan_img_height : (CGPoint []) pts;
@end

NS_ASSUME_NONNULL_END
