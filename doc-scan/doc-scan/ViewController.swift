import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var cvVersionLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var nxtPageBtn: UIImageView!
    
    let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "doc-scan-python", ofType: "mov")!))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvVersionLabel.text = OpenCVWrapper.openCVVersionString()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLocalDeviceGalleryView))
        nxtPageBtn.addGestureRecognizer(tapGesture)
        nxtPageBtn.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layer = AVPlayerLayer(player: player)
        layer.frame = videoView.bounds
        layer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(layer)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
        }
        
        player.volume = 0
        player.play()
        player.rate = 1.55
    }
    
    @objc func openLocalDeviceGalleryView() {
        self.performSegue(withIdentifier: "nxtPage", sender: self)
    }
}

