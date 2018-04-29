//
//  QuestionCell.swift
//  MentalArithmetic
//
//  Created by stardust on 2018/02/09.
//  Copyright © 2018年 stardust. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    @IBOutlet var firstItem : UILabel!
    @IBOutlet var secondItem : UILabel!
    @IBOutlet var answerLabel : UILabel!
    @IBOutlet var calckindLabel : UILabel!
    @IBOutlet var resultLabel : UILabel!
    
    // 計算記号の種類
    let calcKindString : [String] = ["＋", "−", "×", "÷"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     計算式を作る
     */
    func createCalcQuestion() {
        // 計算の種類を決定する
        let calcKind = (Int)(arc4random_uniform(4))
        self.setCalcKind(calcKindNumber: calcKind)
        var firstNumber : Int
        var secondNumber : Int
        var anwerNumbwer : Int
        
        switch calcKind {
            // 足し算
            case 0:
                firstNumber = (Int)(arc4random_uniform(500))
                secondNumber = (Int)(arc4random_uniform(500))
                anwerNumbwer = firstNumber + secondNumber
                self.setNumberToItem(inputNumber: firstNumber, calcItem: self.firstItem)
                self.setNumberToItem(inputNumber: secondNumber, calcItem: self.secondItem)
                self.setNumberToItem(inputNumber: anwerNumbwer, calcItem: self.resultLabel)
                break;
            // 引き算
            case 1:
                firstNumber = (Int)(arc4random_uniform(1000))
                secondNumber = (Int)(arc4random_uniform((UInt32)(firstNumber + 1)))
                anwerNumbwer = firstNumber - secondNumber
                self.setNumberToItem(inputNumber: firstNumber, calcItem: self.firstItem)
                self.setNumberToItem(inputNumber: secondNumber, calcItem: self.secondItem)
                self.setNumberToItem(inputNumber: anwerNumbwer, calcItem: self.resultLabel)
                break;
            // 掛け算
            case 2:
                firstNumber = (Int)(arc4random_uniform(100))
                secondNumber = (Int)(arc4random_uniform(100))
                anwerNumbwer = firstNumber * secondNumber
                self.setNumberToItem(inputNumber: firstNumber, calcItem: self.firstItem)
                self.setNumberToItem(inputNumber: secondNumber, calcItem: self.secondItem)
                self.setNumberToItem(inputNumber: anwerNumbwer, calcItem: self.resultLabel)
                break;
            // 割り算
            case 3:
                anwerNumbwer = (Int)(arc4random_uniform(100))
                secondNumber = (Int)(arc4random_uniform(100))
                firstNumber = secondNumber * anwerNumbwer
                self.setNumberToItem(inputNumber: firstNumber, calcItem: self.firstItem)
                self.setNumberToItem(inputNumber: secondNumber, calcItem: self.secondItem)
                self.setNumberToItem(inputNumber: anwerNumbwer, calcItem: self.resultLabel)
                break;
            default:
                break;
            }
    }
    
    /**
     計算の項を設定する
     */
    func setNumberToItem (inputNumber : Int, calcItem : UILabel!) -> Void {
        calcItem.text = "\(inputNumber)"
    }
    
    /**
     計算の種類を求める
     */
    func setCalcKind (calcKindNumber : Int) -> Void {
        self.calckindLabel.text = calcKindString[calcKindNumber];
    }
    
    /**
     正誤判定処理を行う
     */
    func judgeCalcResult (inputAnswer : String, calcResult : String) {
        if inputAnswer == calcResult {
            self.resultLabel.text? = "正解"
            self.resultLabel.textColor = UIColor.blue
        }
        else {
            self.resultLabel.textColor = UIColor.red
        }
        self.resultLabel.isHidden = false;
    }
    
    /**
     問題のセルの高さを返す
     */
    class public func cellHeight() -> CGFloat {
        return 44.0
    }
}
