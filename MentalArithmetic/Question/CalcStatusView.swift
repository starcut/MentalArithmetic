//
//  CalcStatusView.swift
//  MentalArithmetic
//
//  Created by stardust on 2018/02/10.
//  Copyright © 2018年 stardust. All rights reserved.
//

import UIKit

class CalcStatusView: UIView {
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var timeMeter : UILabel!
    @IBOutlet var timeMeterBackground : UILabel!
    @IBOutlet var scoreLabel : UILabel!
    @IBOutlet var hiScoreLabel : UILabel!
    
    var maxTime : Int!
    var nowTime : Int!
    
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
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CalcStatusView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
    }
    
    // 表示を初期化する
    func calcStatusInit (time : Int, hiScore : Float!, score : Float!) {
        self.maxTime = time
        self.nowTime = time
        self.timeMeter.frame.size.width = self.timeMeterBackground.frame.size.width
        self.setTime(time: time)
        self.setHiScore(score: score, hiScore: hiScore)
        self.setScore(score: score)
    }
    
    // 残り時間を設定する
    private func setTime(time : Int) {
        self.timeLabel.text = "\(time)"
    }
    
    // 残り時間を1秒減らす
    func minusTime() {
        let maxLength : CGFloat = self.timeMeterBackground.frame.size.width
        let remainingTime : CGFloat = CGFloat(self.nowTime!)
        let maxTime : CGFloat = CGFloat(self.maxTime)
        let meterLength : CGFloat = maxLength * remainingTime / maxTime
        self.nowTime = self.nowTime - 1
        self.timeLabel.text = "\(self.nowTime!)"
        self.timeMeter.frame.size = CGSize.init(width: meterLength,
                                                height: self.timeMeter.frame.size.height)
    }
    
    // ハイスコアを設定する
    func setHiScore (score : Float!, hiScore : Float!) {
        if score > hiScore {
            self.hiScoreLabel.text = "\(score!)"
        }
        else {
            self.hiScoreLabel.text = "\(hiScore!)"
        }
    }
    
    // スコアを設定する
    func setScore (score : Float!) {
        self.scoreLabel.text = "\(score!)"
    }
    
    // セルの高さを返す
    static func viewHeight () -> CGFloat {
        return 150.0
    }
}
