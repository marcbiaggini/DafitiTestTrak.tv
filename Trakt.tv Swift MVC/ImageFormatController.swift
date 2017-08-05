//
//  ImagesController.swift
//  Trakt.tv Swift MVC
//
//  Created by Juan Villa .
//


import UIKit

class ImagesController: NSObject {

    // MARK: - Other Methods
    public func setClippingImageView(imgView : UIImageView)
    {
        
        let startPoint = CGPoint(x:133, y:0)
        let endPoint = CGPoint(x:0, y:200)
        let thirdPoint = CGPoint(x:133, y:200)
        
        let triangle = UIBezierPath(cgPath: CGPath(rect: CGRect(x: 0, y: 0, width: 133, height: 200), transform: nil))
        triangle.move(to: startPoint)
        triangle.addLine(to: endPoint)
        triangle.addLine(to: thirdPoint)
        triangle.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = imgView.frame;
        maskLayer.path = triangle.cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.backgroundColor = UIColor.clear.cgColor
        
        imgView.layer.mask = maskLayer;
        
    }
    
}
