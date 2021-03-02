//
//  FireflyScrollView.swift
//  Firefly
//
//  Created by Zachary lineman on 3/1/21.
//

import UIKit

public class FireflyScrollView: UIScrollView {
    var contentView: UIView? = nil
    var contentOffsetRatio = CGPoint(x: 0.5, y: 0.5)
    
    public override var contentOffset: CGPoint {
        didSet {
            let width = self.contentSize.width
            let height = self.contentSize.height
            let halfWidth = self.frame.size.width / 2.0
            let halfHeight = self.frame.size.height / 2.0
            let centerX = ((self.contentOffset.x + halfWidth) / width)
            let centerY = ((self.contentOffset.y + halfHeight) / height)
            self.contentOffsetRatio = CGPoint( x: centerX, y: centerY)
        }
    }
    
    public func determineNewContentOffsetForRatio(ratio: CGPoint) {
        if var frame = self.contentView?.frame {
            if frame.origin.x < 0 {
                frame = frame.offsetBy(dx: -frame.origin.x, dy: 0)
            }
            if frame.origin.y < 0 {
                frame = frame.offsetBy(dx: 0, dy: -frame.origin.y)
            }
            
            var offsetX = ((ratio.x * self.contentSize.width)
                            - (self.frame.size.width / 2.0))
            var offsetY = ((ratio.y * self.contentSize.height)
                            - (self.frame.size.height / 2.0))
            
            var fov = CGRect(x: offsetX, y: offsetY, width: self.frame.size.width, height: self.frame.size.height)
            if fov.origin.x < 0 {
                fov = fov.offsetBy(dx: -fov.origin.x, dy: 0)
            }
            if fov.origin.y < 0 {
                fov = fov.offsetBy(dx: 0, dy: -fov.origin.y)
            }
            
            let intersection = fov.intersection(frame)
            if !intersection.size.equalTo(fov.size) {
                if (fov.maxX > frame.size.width) {
                    offsetX = frame.size.width -  fov.size.width
                }
                if (fov.maxY > frame.size.height) {
                    offsetY = frame.size.height -  fov.size.height
                }
            }
            
            offsetY = offsetY > 0.0 ? offsetY : 0.0;
            offsetX = offsetX > 0.0 ? offsetX : 0.0;
            self.contentOffset = CGPoint(x: offsetX, y: offsetY)
        }
    }
    
}
