import UIKit

class PickViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    var dotViewIndex = 1
    
    var oldPt = CGPoint(x: -1, y: -1)
    var firstPt = CGPoint(x: -1, y: -1)
    var pts: [CGPoint] = []
    
    @IBOutlet weak var doc_img: UIImageView!
    @IBOutlet weak var resultPageBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        doc_img.isUserInteractionEnabled = true
        doc_img.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showResultView))
        resultPageBtn.addGestureRecognizer(tapGesture)
        resultPageBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func removeDotViews(_ sender: Any) {
        for i in 1..<dotViewIndex {
            let dotView = doc_img.viewWithTag(i)
            dotView?.removeFromSuperview()
        }
        dotViewIndex = 1
        
        doc_img.layer.sublayers = nil
        oldPt = CGPoint(x: -1, y: -1)
        pts.removeAll()
    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 2.5
        shapeLayer.lineDashPattern = [7, 3]

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    @objc func showResultView() {
        self.performSegue(withIdentifier: "resultPage", sender: self)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let dotSize = 16
        let cgpoint = tapGestureRecognizer.location(in: doc_img)
        
        if (dotViewIndex > 4) {
            let alert = UIAlertController(title: "Sorry", message: "You can draw only 4 dots.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            if (dotViewIndex == 1) {
                firstPt = cgpoint
            }
            
            let dotView = UIView()
            
            dotView.tag = dotViewIndex
            dotView.frame = CGRect(x: Int(cgpoint.x) - dotSize / 2, y: Int(cgpoint.y) - dotSize / 2, width: dotSize, height: dotSize)
            dotView.backgroundColor = UIColor(red: 255.0 / 255, green: 192.0 / 255, blue: 192.0 / 255, alpha: 0.9)
            dotView.layer.cornerRadius = 8
            pts.append(cgpoint)
            
            doc_img.addSubview(dotView)
            
            if oldPt != CGPoint(x: -1, y: -1) {
                drawDottedLine(start: oldPt, end: cgpoint, view: doc_img)
                if (dotViewIndex == 4) {
                    drawDottedLine(start: cgpoint, end: firstPt, view: doc_img)
                }
            }
            oldPt = cgpoint
            dotViewIndex += 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ResultViewController {
            let vc = segue.destination as? ResultViewController
            vc?.doc_img = doc_img.image!
            vc?.pts = pts
            vc?.resizing_width = doc_img.frame.width
            vc?.resizing_height = doc_img.frame.height
        }
    }
}

extension PickViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        self.doc_img.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
}
