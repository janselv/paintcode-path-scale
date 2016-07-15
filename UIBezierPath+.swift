import UIKit

extension CGRect{
    var center: CGPoint {
        return CGPoint( x: self.size.width/2.0,y: self.size.height/2.0)
    }
}
extension CGPoint{
    func vector(p1:CGPoint) -> CGVector{
        return CGVector(dx: p1.x-self.x, dy: p1.y-self.y)
    }
}

extension UIBezierPath{
    func moveCenter(to to:CGPoint) -> Self{
        let bound  = CGPathGetBoundingBox(self.CGPath)
        let center = bounds.center
        
        let zeroedTo = CGPoint(x: to.x-bound.origin.x, y: to.y-bound.origin.y)
        let vector = center.vector(zeroedTo)
        
        offset(CGSize(width: vector.dx, height: vector.dy))
        return self
    }

    func offset(offset:CGSize) -> Self{
        let t = CGAffineTransformMakeTranslation(offset.width, offset.height)
        applyCenteredTransform(t)
        return self
    }
    
    func fit(into into:CGRect) -> Self{
        let bounds = CGPathGetBoundingBox(self.CGPath)
        
        let sw     = into.size.width/bounds.width
        let sh     = into.size.height/bounds.height
        let factor = min(sw, max(sh, 0.0))
        
        return scale(factor, factor)
    }
    
    func scale(sx:CGFloat,_ sy:CGFloat) -> Self{
        let scale = CGAffineTransformMakeScale(sx, sy)
        applyCenteredTransform(scale)
        return self
    }
    
    
    func applyCenteredTransform(@autoclosure transform:() -> CGAffineTransform) -> Self{
        let bound  = CGPathGetBoundingBox(self.CGPath)
        let center = CGPoint(x: bound.midX, y: bound.midY)
        var xform  = CGAffineTransformIdentity
        
        xform = CGAffineTransformConcat(xform, CGAffineTransformMakeTranslation(-center.x, -center.y))
        xform = CGAffineTransformConcat(xform, transform())
        xform = CGAffineTransformConcat(xform, CGAffineTransformMakeTranslation(center.x, center.y))
        applyTransform(xform)
        return self
    }
}
