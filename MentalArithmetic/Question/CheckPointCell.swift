//
//  CheckPointCell.swift
//  MentalArithmetic
//
//  Created by stardust on 2018/02/10.
//  Copyright © 2018年 stardust. All rights reserved.
//

import UIKit

class CheckPointCell: UITableViewCell {
    @IBOutlet var checkPointLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func initFromNib() -> CheckPointCell {
        let className : String = String(describing: CheckPointCell.self)
        return Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as! CheckPointCell
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setCheckPointLabelString(questionNumber : Int) {
        self.checkPointLabel.text = "\(questionNumber)問突破"
    }
    
    class public func cellHeight() -> CGFloat {
        return 22.0
    }
}
