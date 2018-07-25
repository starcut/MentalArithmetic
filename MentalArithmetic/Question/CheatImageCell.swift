//
//  CheatImageCell.swift
//  MentalArithmetic
//
//  Created by stardust on 2018/07/17.
//  Copyright © 2018年 stardust. All rights reserved.
//

import UIKit

class CheatImageCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        instance()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instance()
    }
    
    private func instance() {
        
    }
}
