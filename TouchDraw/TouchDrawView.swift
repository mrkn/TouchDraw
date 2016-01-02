//
//  TouchDrawView.swift
//  TouchDraw
//
//  Created by Kenta Murata on 1/2/16.
//  Copyright © 2016 Kenta Murata. All rights reserved.
//

import UIKit

class TouchDrawView: UIView {
    @IBOutlet weak var viewController: ViewController!

    override func drawRect(rect: CGRect) {
        let ctx: CGContext! = UIGraphicsGetCurrentContext()
        viewController.drawDrawingLine(ctx, red: 1)
    }
}
