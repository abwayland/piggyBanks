//
//  PBView.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 4/10/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class PBView: UIView {
    
    var fillLevel: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var drawColor: UIColor!

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        let white = UIColor.whiteColor()
        
        let pbViewRect = UIBezierPath(rect: self.bounds)
        pbViewRect.stroke()
        UIColor.lightGrayColor().setFill()
        pbViewRect.fill()
        
        println(self.frame.origin)
        
        var pigPath = UIBezierPath()
//        pigPath = CGPointMake(self.bounds.width / 2, self.bounds.height / 2)
        pigPath.moveToPoint(CGPointMake(47,-15))
        pigPath.addLineToPoint(CGPointMake(43,-15))
        pigPath.addCurveToPoint(CGPointMake(0,-48), controlPoint1: CGPointMake(40,-34), controlPoint2: CGPointMake(22,-48))
        pigPath.addCurveToPoint(CGPointMake(-11,-47), controlPoint1: CGPointMake(-3,-48), controlPoint2: CGPointMake(-7,-48))
        //Ear
        pigPath.addLineToPoint(CGPointMake(-23,-55))
        pigPath.addQuadCurveToPoint(CGPointMake(-26, -54), controlPoint: CGPointMake(-25, -56))
        pigPath.addLineToPoint(CGPointMake(-27,-39))
        
        pigPath.addCurveToPoint(CGPointMake(-40,-23), controlPoint1: CGPointMake(-33,-35), controlPoint2: CGPointMake(-38,-29))
        pigPath.addLineToPoint(CGPointMake(-48,-23))
        pigPath.addCurveToPoint(CGPointMake(-52,-19), controlPoint1: CGPointMake(-50,-23), controlPoint2: CGPointMake(-52,-21))
        pigPath.addLineToPoint(CGPointMake(-52,-2))
        pigPath.addCurveToPoint(CGPointMake(-48,1), controlPoint1: CGPointMake(-52,0), controlPoint2: CGPointMake(-50,1))
        pigPath.addLineToPoint(CGPointMake(-41,1))
        pigPath.addCurveToPoint(CGPointMake(-23,22), controlPoint1: CGPointMake(-38,10), controlPoint2: CGPointMake(-32,17))
        pigPath.addLineToPoint(CGPointMake(-23,32))
        pigPath.addCurveToPoint(CGPointMake(-21,34), controlPoint1: CGPointMake(-23,33), controlPoint2: CGPointMake(-22,34))
        pigPath.addLineToPoint(CGPointMake(-10,34))
        pigPath.addCurveToPoint(CGPointMake(-8,32), controlPoint1: CGPointMake(-9,34), controlPoint2: CGPointMake(-8,33))
        pigPath.addLineToPoint(CGPointMake(-8,28))
        pigPath.addCurveToPoint(CGPointMake(0,29), controlPoint1: CGPointMake(-5,29), controlPoint2: CGPointMake(-2,29))
        pigPath.addCurveToPoint(CGPointMake(8,28), controlPoint1: CGPointMake(3,29), controlPoint2: CGPointMake(6,29))
        pigPath.addLineToPoint(CGPointMake(8,32))
        pigPath.addCurveToPoint(CGPointMake(11,34), controlPoint1: CGPointMake(8,33), controlPoint2: CGPointMake(9,34))
        pigPath.addLineToPoint(CGPointMake(22,34))
        pigPath.addCurveToPoint(CGPointMake(24,32), controlPoint1: CGPointMake(23,34), controlPoint2: CGPointMake(24,33))
        pigPath.addLineToPoint(CGPointMake(24,22))
        pigPath.addCurveToPoint(CGPointMake(43,-5), controlPoint1: CGPointMake(34,16), controlPoint2: CGPointMake(42,6))
        pigPath.addLineToPoint(CGPointMake(47,-5))
        pigPath.addCurveToPoint(CGPointMake(51,-10), controlPoint1: CGPointMake(49,-5), controlPoint2: CGPointMake(51,-7))
        pigPath.addCurveToPoint(CGPointMake(47,-15), controlPoint1: CGPointMake(51,-13), controlPoint2: CGPointMake(49,-15))
        drawColor.setStroke()
        pigPath.lineWidth = 2
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), self.bounds.width / 2, self.bounds.height / 2) //???
        let scale: CGFloat = (self.bounds.width / pigPath.bounds.width) * 0.9
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale)
        
        pigPath.stroke()
        
//        pigPath.addClip()
        
        let orangeRectHeight = pigPath.bounds.size.height * fillLevel
        
        var orangeRect = UIBezierPath(rect: CGRectMake(pigPath.bounds.origin.x, pigPath.bounds.origin.y + pigPath.bounds.size.height, pigPath.bounds.size.width, -orangeRectHeight))
        drawColor.setFill()
        orangeRect.fill()
        
        var eyePath = UIBezierPath(ovalInRect: CGRectMake(-27, -30.5, 9, 9))
        white.setFill()
        eyePath.fill()
        eyePath.lineWidth = 2;
        eyePath.stroke()
        
        var slotPath = UIBezierPath(roundedRect: CGRectMake(-9, -43, 19, 1), cornerRadius: 0.5)
        if orangeRect.containsPoint(slotPath.bounds.origin) {
            white.setStroke()
        }
        drawColor.setFill()
        slotPath.fill()
        slotPath.lineWidth = 2;
        slotPath.stroke()
        
    }

}
