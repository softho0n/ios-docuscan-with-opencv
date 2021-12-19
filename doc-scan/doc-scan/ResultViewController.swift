import UIKit

class ResultViewController: UIViewController {
    var pts: [CGPoint] = []
    var doc_img: UIImage = UIImage()
    var resizing_width:CGFloat = 0
    var resizing_height:CGFloat = 0
    
    @IBOutlet weak var scan_img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scan_img.image = OpenCVWrapper.docuscan(doc_img, resizing_width, resizing_height, scan_img.frame.width, scan_img.frame.height, &pts)
    }
    
    @IBAction func save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(scan_img.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                let ac = UIAlertController(title: "실패했어요 :(", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "확인", style: .default))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "저장 완료!", message: "갤러리에 정상적으로 저장되었습니다.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in 
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                present(ac, animated: true)
            }
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
