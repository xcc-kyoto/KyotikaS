//
//  TreasureAnnotationView.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/10.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import MapKit

class TreasureAnnotationView: MKAnnotationView {
    
    var blinker: CALayer!
    var locker: CALayer!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isOpaque = false
        initFrameSize()
        initBlinker()
        initLocker()
        startAnimation()
    }
    
    private func initFrameSize() {
        frame.size.width = 48
        frame.size.height = 48
    }
    
    private func initBlinker() {
        if blinker != nil {
            blinker.removeFromSuperlayer()
        }
        blinker = CALayer()
        blinker.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        blinker.contents = UIImage(named: "Shines")?.cgImage
        blinker.contentsRect = animationRects()[0]

        layer.cornerRadius = frame.size.width / 2
        layer.addSublayer(blinker)
    }
    
    private func initLocker() {
        if locker != nil {
            locker.removeFromSuperlayer()
        }
        locker = CALayer()
        locker.contentsScale = UIScreen.main.scale
        locker.frame = layer.bounds
        locker.contents = UIImage(named: "Lock")?.cgImage
        locker.contentsGravity = .center
    }
    
    func startAnimation() {
        let ta = self.annotation as! TreasureAnnotation
        if ta.passed {
            if blinker != nil {
                blinker.removeFromSuperlayer()
            }
            if locker != nil {
                locker.removeFromSuperlayer()
            }
            image = UIImage(named: "Landmark")
            return
        }
        else {
            image = nil
        }
        
        let ka = CAKeyframeAnimation(keyPath: "contentsRect")
        ka.values = animationRectValues()
        ka.calculationMode = .discrete
        ka.duration = 1
        ka.repeatCount = Float.infinity
        ka.isRemovedOnCompletion = false
        blinker.add(ka, forKey: "blinker")
        
        if ta.locking {
            layer.addSublayer(locker)
        }
        else {
            locker?.removeFromSuperlayer()
        }
    }
    
    private func animationRectValues() -> [NSValue] {
        return animationRects().map { NSValue(cgRect: $0) }
    }
    
    private func animationRects() -> [CGRect] {
        return [
            CGRect(x: 0.0, y: 0, width: 0.2, height: 1),
            CGRect(x: 0.2, y: 0, width: 0.2, height: 1),
            CGRect(x: 0.4, y: 0, width: 0.2, height: 1),
            CGRect(x: 0.6, y: 0, width: 0.2, height: 1),
            CGRect(x: 0.8, y: 0, width: 0.2, height: 1),
        ]
    }
}
