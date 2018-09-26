//
//  CalcStatusView.swift
//  MentalArithmetic
//
//  Created by stardust on 2018/02/10.
//  Copyright © 2018年 stardust. All rights reserved.
//

import UIKit

class CalcStatusView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var timeMeter : UIView!
    @IBOutlet var timeMeterBackground : UIView!
    @IBOutlet var scoreLabel : UILabel!
    @IBOutlet var hiScoreLabel : UILabel!
    @IBOutlet var cheatArea : UICollectionView!
    @IBOutlet var timeMeterWidth : NSLayoutConstraint!
    
    var maxTime : Int!
    var nowTime : Int!
    var cheatNum : Int!
    
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
        Utility.resizeForScreenWidth(resizeView: view)
        view.layoutIfNeeded()
        addSubview(view)
    }
    
    // 表示を初期化する
    func calcStatusInit (time : Int, hiScore : Float!, score : Float!, timer : Timer!) {
        self.maxTime = time
        self.nowTime = time
        self.timeMeterWidth.constant = self.timeMeterBackground.frame.size.width
        self.setNeedsLayout()
        self.layoutIfNeeded()
        UIView.animate(withDuration: Double(self.maxTime),
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        self.timeMeterWidth.constant = 0.0
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
        },
                       completion: {(success) in
                        if timer.isValid {
                            timer.invalidate()
                        }
        })
        
        self.setTime(time: time)
        self.setHiScore(score: score, hiScore: hiScore)
        self.setScore(score: score)
        
        self.cheatArea.delegate = self
        self.cheatArea.dataSource = self
        
        let nib : UINib = UINib.init(nibName: "CheatImageCell", bundle: nil)
        self.cheatArea.register(nib, forCellWithReuseIdentifier: "cheatImage")
    }
    
    func setCheatNum(cheatNum : Int!) {
        self.cheatNum = cheatNum
        self.cheatArea.reloadData()
    }
    
    // 残り時間を設定する
    private func setTime(time : Int) {
        self.timeLabel.text = "\(time)"
    }
    
    // 残り時間を1秒減らす
    func minusTime() {
        self.nowTime = self.nowTime - 1
        self.timeLabel.text = "\(self.nowTime!)"
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
    
    // ステータスビューの高さを返す
    static func viewHeight () -> CGFloat {
        return 105.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cheatNum!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CheatImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cheatImage", for: indexPath) as! CheatImageCell
        cell.frame.size.height = 29
        return cell
    }
}
