//
//  TELayerAniamtion.swift
//  TextKitStudy
//
//  Created by steven on 3/16/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

typealias completionClosure = (_ finished:Bool)->()

private let textAnimationGroupKey = "textAniamtionGroupKey"

class TELayerAniamtion: NSObject {
    
    var completionBLK:completionClosure? = nil
    var textLayer:CALayer?
    
    class func textLayerAnimation(_ layer:CALayer, durationTime duration:TimeInterval, delayTime delay:TimeInterval,animationClosure effectAnimation:effectAnimatableLayerColsure?, completion finishedClosure:completionClosure?) -> Void
    {
        let animationObjc = TELayerAniamtion()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            
            let olderLayer = animationObjc.animatableLayerCopy(layer)
            var newLayer:CALayer?
            var animationGroup:CAAnimationGroup?
            animationObjc.completionBLK = finishedClosure
            if let effectAnimationClosure = effectAnimation {
                //改变Layer的properties，同时关闭implicit animation
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                newLayer = effectAnimationClosure(layer)
                CATransaction.commit()
            }
            animationGroup = animationObjc.groupAnimationWithLayerChanges(old: olderLayer, new: newLayer!)
            
            if let textAniamtionGroup = animationGroup
            {
                animationObjc.textLayer = layer
                textAniamtionGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                textAniamtionGroup.beginTime = CACurrentMediaTime()
                textAniamtionGroup.duration = duration
                textAniamtionGroup.delegate = animationObjc as? CAAnimationDelegate
                layer.add(textAniamtionGroup, forKey: textAnimationGroupKey)
            }else
            {
                if let completion = finishedClosure
                {
                    completion(true)
                }
            }
        }
        
        
    }
    
    
    func groupAnimationWithLayerChanges(old olderLayer:CALayer, new newLayer:CALayer) -> CAAnimationGroup?
    {
        var animationGroup:CAAnimationGroup?
        var animations:[CABasicAnimation] = [CABasicAnimation]()
        
        if !olderLayer.position.equalTo(newLayer.position) {
            let basicAnimation = CABasicAnimation()
            basicAnimation.fromValue =  NSValue(cgPoint: olderLayer.position)
            basicAnimation.toValue = NSValue(cgPoint:newLayer.position)
            basicAnimation.keyPath = "position"
            animations.append(basicAnimation)
        }
        
        if !CATransform3DEqualToTransform(olderLayer.transform, newLayer.transform) {
            let basicAnimation = CABasicAnimation(keyPath: "transform")
            basicAnimation.fromValue = NSValue(caTransform3D: olderLayer.transform)
            basicAnimation.toValue = NSValue(caTransform3D: newLayer.transform)
            animations.append(basicAnimation)
        }
        
        if !olderLayer.frame.equalTo(newLayer.frame)
        {
            let basicAnimation = CABasicAnimation(keyPath: "frame")
            basicAnimation.fromValue = NSValue(cgRect: olderLayer.frame)
            basicAnimation.toValue = NSValue(cgRect: newLayer.frame)
            animations.append(basicAnimation)
        }
        
        if !olderLayer.bounds.equalTo(olderLayer.bounds)
        {
            let basicAnimation = CABasicAnimation(keyPath: "bounds")
            basicAnimation.fromValue = NSValue(cgRect: olderLayer.bounds)
            basicAnimation.toValue = NSValue(cgRect: newLayer.bounds)
            animations.append(basicAnimation)
        }
        
        if olderLayer.opacity != newLayer.opacity
        {
            let basicAnimation = CABasicAnimation(keyPath: "opacity")
            basicAnimation.fromValue = olderLayer.opacity
            basicAnimation.toValue = newLayer.opacity
            animations.append(basicAnimation)

        }
        
        if animations.count > 0 {
            animationGroup = CAAnimationGroup()
            animationGroup!.animations = animations
        }
        return animationGroup
    }
    
    
    func animatableLayerCopy(_ layer:CALayer)->CALayer
    {
        let layerCopy = CALayer()
        layerCopy.opacity = layer.opacity
        layerCopy.bounds = layer.bounds
        layerCopy.transform = layer.transform
        layerCopy.position = layer.position
        return layerCopy
    }
    
    
    //MARK:animationDelegate
    
     func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let tempCompletionBLK = self.completionBLK
        {
            self.textLayer?.removeAnimation(forKey: textAnimationGroupKey)
            tempCompletionBLK(flag)
        }
    }
    
    
}
