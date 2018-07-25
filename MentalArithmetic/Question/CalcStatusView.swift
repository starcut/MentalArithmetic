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
    @IBOutlet var timeMeter : UILabel!
    @IBOutlet var timeMeterBackground : UILabel!
    @IBOutlet var scoreLabel : UILabel!
    @IBOutlet var hiScoreLabel : UILabel!
    @IBOutlet var cheatArea : UICollectionView!
    
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
        let maxLength : CGFloat = self.timeMeterBackground.frame.size.width
        let remainingTime : CGFloat = CGFloat(self.nowTime!)
        let maxTime : CGFloat = CGFloat(self.maxTime)
        let meterLength : CGFloat = maxLength * remainingTime / maxTime
        self.nowTime = self.nowTime - 1
        self.timeLabel.text = "\(self.nowTime!)"
        self.timeMeter.frame.size = CGSize.init(width: meterLength,
                                                height: self.timeMeter.frame.size.height)
        print("\(self.timeMeter.frame)")
        self.setNeedsLayout()
        self.layoutIfNeeded()
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
