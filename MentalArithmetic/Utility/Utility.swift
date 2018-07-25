//
//  Utility.swift
//  MentalArithmetic
//
//  Created by stardust on 2018/07/16.
//  Copyright © 2018年 stardust. All rights reserved.
//

import UIKit

class Utility: NSObject {
    class func resizeForScreenWidth(resizeView : UIView) {
        var resizedFrame : CGRect = resizeView.frame
        resizedFrame.size.width = UIScreen.main.bounds.size.width
        resizeView.frame = resizedFrame
    }
}
