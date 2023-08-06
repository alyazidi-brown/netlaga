//
//  RadioWaveView.swift
//  Netlaga
//
//  Created by Scott Brown on 07/06/2023.
//

import UIKit

class AnimatedWaveView: UIView {
    
    private let baseRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    // MARK: - Lifecycle
    
   
    
    public func makeWaves() {
        DispatchQueue.main.async {
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.addAnimatedWave), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func addAnimatedWave() {
        let waveLayer = self.buildWave(rect: baseRect)
        self.layer.addSublayer(waveLayer)
        self.animateWave(waveLayer: waveLayer)
    }
    
    private func buildWave(rect: CGRect) -> CAShapeLayer {
        let center = CGPoint(x: 0, y: 0)
        let circlePath = UIBezierPath(ovalIn: rect)
        let waveLayer = CAShapeLayer()
        waveLayer.bounds = rect
        waveLayer.frame = rect
        waveLayer.position = self.center
        waveLayer.strokeColor = UIColor.blue.cgColor
        waveLayer.fillColor = UIColor.clear.cgColor
        waveLayer.lineWidth = 2.0
        waveLayer.path = circlePath.cgPath
        waveLayer.strokeStart = 0
        waveLayer.strokeEnd = 1
        return waveLayer
    }
    
    private let scaleFactor: CGFloat = 1.5
    
    private func animateWave(waveLayer: CAShapeLayer) {
        // Scaling animation
        let finalRect = self.bounds.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let finalPath = UIBezierPath(ovalIn: finalRect)
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = waveLayer.path
        animation.toValue = finalPath.cgPath
        
        // Bounds animation
        let posAnimation = CABasicAnimation(keyPath: "bounds")
        posAnimation.fromValue = waveLayer.bounds
        posAnimation.toValue = finalRect
        
        // Group
        let scaleWave = CAAnimationGroup()
        scaleWave.animations = [animation, posAnimation]
        scaleWave.duration = 10
        scaleWave.setValue(waveLayer, forKey: "waveLayer")
        scaleWave.delegate = self
        scaleWave.isRemovedOnCompletion = true
        waveLayer.add(scaleWave, forKey: "scale_wave_animation")
    }
}

extension AnimatedWaveView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let waveLayer = anim.value(forKey: "waveLayer") as? CAShapeLayer {
            waveLayer.removeFromSuperlayer()
        }
    }
}
