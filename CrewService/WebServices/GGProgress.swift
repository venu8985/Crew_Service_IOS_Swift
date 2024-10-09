
import UIKit
import MBProgressHUD
class GGProgress: NSObject {
    
    static var shared: GGProgress = GGProgress()
    
    var viewHub:UIView?
    
    func showProgress(with title: String = "", file: String = #function){
        DispatchQueue.main.async {
            if self.viewHub == nil {
                
                self.viewHub = UIView(frame: UIApplication.shared.keyWindow!.frame)
                let img = UIImageView()
                img.image = UIImage(named: "roundimage")
                img.translatesAutoresizingMaskIntoConstraints = false
                
                let imgHr = UIImageView()
                imgHr.image = UIImage(named: "appLogo")
                imgHr.translatesAutoresizingMaskIntoConstraints = false
                
                self.rotate2(imageView: img, aCircleTime: 1)
                
                self.viewHub?.addSubview(img)
                self.viewHub?.addSubview(imgHr)
                self.viewHub?.backgroundColor = .clear
                
                UIApplication.shared.keyWindow!.addSubview(self.viewHub!)
                let constraint =  NSLayoutConstraint(item: img,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 120)
                img.addConstraint(constraint)
                let constraint1 = NSLayoutConstraint(item: img,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 120)
                img.addConstraint(constraint1)
                let constraint2 =  NSLayoutConstraint(item: self.viewHub!,
                                                      attribute: .centerX,
                                                      relatedBy: .equal,
                                                      toItem: img,
                                                      attribute: .centerX,
                                                      multiplier: 1,
                                                      constant: 0)
                self.viewHub!.addConstraint(constraint2)
                let constraint3 = NSLayoutConstraint(item:self.viewHub!,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: img,
                                                     attribute: .centerY,
                                                     multiplier: 1,
                                                     constant: 0)
                self.viewHub!.addConstraint(constraint3)
                
                let constraint4 =  NSLayoutConstraint(item: imgHr,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 90)
                imgHr.addConstraint(constraint4)
                let constraint5 = NSLayoutConstraint(item: imgHr,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 90)
                imgHr.addConstraint(constraint5)
                let constraint6 =  NSLayoutConstraint(item: self.viewHub!,
                                                      attribute: .centerX,
                                                      relatedBy: .equal,
                                                      toItem: imgHr,
                                                      attribute: .centerX,
                                                      multiplier: 1,
                                                      constant: 0)
                self.viewHub!.addConstraint(constraint6)
                let constraint7 = NSLayoutConstraint(item:self.viewHub!,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: imgHr,
                                                     attribute: .centerY,
                                                     multiplier: 1,
                                                     constant: 0)
                self.viewHub!.addConstraint(constraint7)
            }else{
                self.viewHub!.isHidden = false
            }
     
        }
    }
    
    func hideProgress(_ file: String = #function){
        if viewHub != nil {
            self.viewHub!.isHidden = true
            self.viewHub = nil
            debugPrint("GGProgress : \(file) end")
        }
    }
    func rotate2(imageView: UIView, aCircleTime: Double) { //UIView
            
            UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }, completion: { finished in
                UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
                }, completion: { finished in
                    self.rotate2(imageView: imageView, aCircleTime: aCircleTime)
                })
            })
    }
}
