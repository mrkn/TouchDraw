//
//  ViewController.swift
//  TouchDraw
//
//  Created by Kenta Murata on 1/2/16.
//  Copyright © 2016 Kenta Murata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var touchDrawView: TouchDrawView!

    var screenImage: CGImage! = nil
    var drawingPoints: [CGPoint]! = nil
    var beginningOfPrediction: Int = 0
    var lastPoint: CGPoint! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        initImageView()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let point = touch.locationInView(touchDrawView)
        drawingPoints = [point]
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first,
                  event = event else {
            return
        }
        
        if drawingPoints.count > beginningOfPrediction {
            drawingPoints.removeRange(beginningOfPrediction..<drawingPoints.count)
        }

        if let coalescedTouches = event.coalescedTouchesForTouch(touch) {
            for coalescedTouch in coalescedTouches {
                let point = coalescedTouch.locationInView(touchDrawView)
                drawingPoints.append(point)
            }
        }
        else {
            let point = touch.locationInView(touchDrawView)
            drawingPoints.append(point)
        }

        beginningOfPrediction = drawingPoints.count

        if let predictedTouches = event.predictedTouchesForTouch(touch) {
            for predictedTouch in predictedTouches {
                let point = predictedTouch.locationInView(touchDrawView)
                drawingPoints.append(point)
            }
        }

        touchDrawView.setNeedsDisplay()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
                return
        }

        let point = touch.locationInView(touchDrawView)
        drawingPoints.append(point)
        
        commitDrawingLine()
        drawingPoints = nil
        touchDrawView.setNeedsDisplay()
    }

    private func initImageView() {
        self.imageView.image = createBlankScreenImage()
    }

    private func createBlankScreenImage() -> UIImage! {
        UIGraphicsBeginImageContext(self.view.bounds.size)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetRGBFillColor(ctx, 0.9, 0.9, 0.9, 1.0)
        UIRectFill(self.view.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    private func commitDrawingLine() {
        guard let currentImage = imageView.image else {
            return
        }
        UIGraphicsBeginImageContext(self.view.bounds.size)
        let ctx: CGContext! = UIGraphicsGetCurrentContext()
        currentImage.drawAtPoint(CGPointZero)
        drawDrawingLine(ctx)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    func drawDrawingLine(ctx: CGContext, red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0) {
        if drawingPoints == nil {
            return
        }

        CGContextSaveGState(ctx)

        CGContextSetLineCap(ctx, CGLineCap.Round)
        CGContextSetLineWidth(ctx, 2.0)
        CGContextSetRGBStrokeColor(ctx, red, green, blue, 1)

        CGContextBeginPath(ctx)
        for (i, point) in drawingPoints.enumerate() {
            if i == 0 {
                CGContextMoveToPoint(ctx, point.x, point.y)
            }
            else {
                CGContextAddLineToPoint(ctx, point.x, point.y)
            }
        }
        CGContextStrokePath(ctx)

        CGContextRestoreGState(ctx)
    }
}

