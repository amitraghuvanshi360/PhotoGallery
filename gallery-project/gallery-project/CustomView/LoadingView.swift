//
//  LoadingView.swift
//  gallery-project
//
//  Created by Ankush Sharma on 27/04/23.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commit()
        stopAnimation()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadingImageView.rotate()
    }

    func commit(){
        Bundle.main.loadNibNamed("LoadingView", owner: self)
        outerView.frame = self.bounds
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(outerView)
        
        outerView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
    }

    func stopAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
            loadingImageView.imageSlideToNext()
        }
    }
}

extension UIImageView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func imageSlideToNext(){
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
