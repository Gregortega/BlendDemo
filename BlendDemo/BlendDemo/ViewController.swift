//
//  ViewController.swift
//  BlendDemo
//
//  Created by Greg Ortega on 22/12/17.
//  Copyright © 2017 Gregorio Ortega Calderon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var blendingImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var rotateSlider: UISlider!
    @IBOutlet weak var xSlider: UISlider!
    @IBOutlet weak var ySlider: UISlider!
    @IBOutlet weak var angleLabel: UILabel!
    
    @IBAction func rotateSliderChangedValue(_ sender: Any) {
        angleLabel.text = "Angle: \(rotateSlider.value)"
        let radians = rotateSlider.value * .pi / 180
        let rotateTransform = CGAffineTransform(rotationAngle: CGFloat(radians))
        blendingImageView.transform = rotateTransform
        //updateBlendingView()
        updateBlendingView2()
    }
    
    @IBAction func xSliderChangedValue(_ sender: Any) {
        let xValue = CGFloat(xSlider.value) * mainImageView.bounds.width
        blendingImageView.center = CGPoint(x: xValue, y: blendingImageView.center.y)
        //updateBlendingView()
        updateBlendingView2()
    }
    
    @IBAction func ySliderChangedValue(_ sender: Any) {
        let yValue = CGFloat(ySlider.value) * mainImageView.bounds.height
        blendingImageView.center = CGPoint(x: blendingImageView.center.x, y: yValue)
        //updateBlendingView()
        updateBlendingView2()
    }
    
    func updateBlendingView() {
        
        guard let mainViewImage = getImageFromView(view: mainImageView) else {return}
        
        // Reset image to original state before blending
        blendingImageView.image = UIImage(named: "square")!
        guard let blendingImage = getImageFromView(view: blendingImageView) else {return}
        
        UIGraphicsBeginImageContextWithOptions(blendingImageView.bounds.size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext();return}
        
        let blendingOriginTransform = CGAffineTransform(translationX: (blendingImageView.bounds.width * 0.5), y: (blendingImageView.bounds.height * 0.5))
        
        let radians:Float = atan2f(Float(blendingImageView.transform.b), Float(blendingImageView.transform.a))
        let rotateTransform: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat(radians))
        
        let mainViewOrigin = CGPoint(x: -blendingImageView.frame.origin.x , y: -blendingImageView.frame.origin.y )
        mainViewImage.draw(at: mainViewOrigin)
        
        context.concatenate(blendingOriginTransform)
        context.concatenate(rotateTransform)
        
        
        let blendingDrawingOrigin = CGPoint(x: -blendingImageView.bounds.width * 0.5, y: -blendingImageView.bounds.height * 0.5)
        blendingImage.draw(at: blendingDrawingOrigin, blendMode: .multiply , alpha: 0.5)
        
        guard let blendedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        UIGraphicsEndImageContext()
        
        blendingImageView.image = blendedImage
    }
    
    func updateBlendingView2() {
        
        guard let mainViewImage = getImageFromView(view: mainImageView) else {return}
        
        // Reset image to original state before blending
        blendingImageView.image = UIImage(named: "square")!
        guard let blendingImage = getImageFromView(view: blendingImageView) else {return}
        
        UIGraphicsBeginImageContextWithOptions(blendingImageView.bounds.size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext();return}
        
        let blendingOriginTransform = CGAffineTransform(translationX: (blendingImageView.bounds.width * 0.5), y: (blendingImageView.bounds.height * 0.5))
        
        let radians:Float = atan2f(Float(blendingImageView.transform.b), Float(blendingImageView.transform.a))
        let rotateTransform: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat(radians))
        
        context.concatenate(blendingOriginTransform)
        context.concatenate(rotateTransform.inverted())
        
        let mainViewOrigin = CGPoint(x: -blendingImageView.frame.origin.x - (blendingImageView.bounds.width * 0.5) , y: -blendingImageView.frame.origin.y - (blendingImageView.bounds.height * 0.5))
        mainViewImage.draw(at: mainViewOrigin)
        
        // undo the rotate
        context.concatenate(rotateTransform)
    
        let blendingDrawingOrigin = CGPoint(x: -blendingImageView.bounds.width * 0.5, y: -blendingImageView.bounds.height * 0.5)
        blendingImage.draw(at: blendingDrawingOrigin, blendMode: .multiply , alpha: 0.5)
        
        guard let blendedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        UIGraphicsEndImageContext()
        blendingImageView.image = blendedImage
    }
    
    func getImageFromView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext();return nil}
        view.layer.render(in: context)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }

}

