# ios-docuscan-with-opencv
<em>Simple iOS App for Document Scanning Using OpenCV Library</em> 
> OpenCV-Python에서 벗어나 OpenCV-C++ 학습 및 클라이언트 서비스(iOS) 상에서 OpenCV를 활용하는 법을 터득하기 위한 Toy Project임.


## 개발 환경
### Tool & Machine
-	M1 Macbook Air
-	Xcode
-	Swift, Objective-C

### Library
* OpenCV
  
### Core Functions (So Simple)  

> [OpenCVWrapper.mm](https://github.com/softho0n/ios-docuscan-with-opencv/blob/main/doc-scan/OpenCVWrapper/OpenCVWrapper.mm)  
1. [`reindexing_points_by_direction_order`](https://github.com/softho0n/ios-docuscan-with-opencv/blob/main/doc-scan/OpenCVWrapper/OpenCVWrapper.mm/#L16)
```objc
// 1. User가 선택한 이미지로부터 네 개의 점을 선택합니다.
// 2. 네 개의 점을 배열 형태로 받아와서 추후 Perspective Trasform을 진행해야합니다.
// 3. Top-Left, Top-Right, Bottom-Right, Bottom-Left 순서대로 입력이 들어올 수 있지만 순서가 유지되지 않은채 입력될 수도 있습니다.
// 4. Top-Left, Top-Right, Bottom-Right, Bottom-Left 순서대로 입력의 순서를 바꿔주는 역할을 아래 함수가 수행합니다.
+(void) reindexing_points_by_direction_order: (CGPoint *) pts {
    std::vector<std::pair<int, int>> xplusy;
    std::vector<std::pair<int, int>> xminusy;
    
    for (int i=0; i<4; i++) {
        std::cout << pts[i].x << " " << pts[i].y << std::endl;
        xplusy.push_back({pts[i].x + pts[i].y, i});
        xminusy.push_back({pts[i].x - pts[i].y, i});
    }
    
    std::sort(xplusy.begin(), xplusy.end());
    std::sort(xminusy.begin(), xminusy.end());
    
    CGPoint topLeft;
    CGPoint bottomRight;
    CGPoint topRight;
    CGPoint bottomLeft;
    
    topLeft = pts[xplusy[0].second];
    bottomRight = pts[xplusy[3].second];
    topRight = pts[xminusy[3].second];
    bottomLeft = pts[xminusy[0].second];

    pts[0] = topLeft;
    pts[1] = topRight;
    pts[2] = bottomRight;
    pts[3] = bottomLeft;
}
```
2. [`docuscan`](https://github.com/softho0n/ios-docuscan-with-opencv/blob/main/doc-scan/OpenCVWrapper/OpenCVWrapper.mm/#L45)
```objc
// 입력받은 네 개의 좌표를 바탕으로 Perpective Transform을 적용하고 생성된 이미지를 UIImage 객체로 반환합니다.
// Parameter image           : 변환을 수행하기 위한 소스 이미지
// Parameter resizing_width  : 이미지 width를 ImageView width로 바꾸어주기 위한 resizing value
// Parameter resizing_height : 이미지 height를 ImageView height로 바꾸어주기 위한 resizing value
// Parameter scan_img_width  : Perspective 변환을 거진 출력 영상의 width를 Output ImageView width로 바꾸어주기 위한 value
// Parameter scan_img_height : Perspective 변환을 거진 출력 영상의 height를 Output ImageView height로 바꾸어주기 위한 value
+(UIImage *) docuscan : (UIImage *) image : (CGFloat) resizing_width : (CGFloat) resizing_height : (CGFloat) scan_img_width : (CGFloat) scan_img_height : (CGPoint []) pts {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::resize(src, src, cv::Size(resizing_width, resizing_height));
    
    auto dw = scan_img_width;
    auto dh = scan_img_height;
    
    [self reindexing_points_by_direction_order:pts];
    
    std::vector<cv::Point2f> srcQuad, dstQuad;
    
    srcQuad.push_back(cv::Point2f(pts[0].x, pts[0].y));
    srcQuad.push_back(cv::Point2f(pts[1].x, pts[1].y));
    srcQuad.push_back(cv::Point2f(pts[2].x, pts[2].y));
    srcQuad.push_back(cv::Point2f(pts[3].x, pts[3].y));
    
    dstQuad.push_back(cv::Point2f(0,    0));
    dstQuad.push_back(cv::Point2f(dw-1, 0));
    dstQuad.push_back(cv::Point2f(dw-1, dh-1));
    dstQuad.push_back(cv::Point2f(0,    dh-1));
    
    auto pers = cv::getPerspectiveTransform(srcQuad, dstQuad);
    
    std::cout << pers << std::endl;
    cv::Mat dst;
    cv::warpPerspective(src, dst, pers, cv::Size(dw, dh));
    return MatToUIImage(dst);
}
```

### Example

<p align="center"><img width="40%" src="https://user-images.githubusercontent.com/42256738/146643200-d3949659-c330-47d4-ae04-e70ea8fe81ce.gif"/></p>  
