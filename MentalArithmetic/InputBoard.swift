//
//  InputBoard.swift
//  MentalArithmetic
//
//  Created by stardust on 2018/02/25.
//  Copyright © 2018年 stardust. All rights reserved.
//

import UIKit

class InputBoard: UIView {
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("InputBoard", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func pushedNumberButton(_ sender: Any) {
        NSLog("押された")
    }
}
