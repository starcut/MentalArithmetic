//
//  CalculationViewController.swift
//  MentalArithmetic
//
//  Created by stardust on 2018/02/06.
//  Copyright © 2018年 stardust. All rights reserved.
//

import UIKit

class CalculationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum PushedButtonKey :Int {
        case ButtonKeyZero = 0
        case ButtonKeyOne
        case ButtonKeyTwo
        case ButtonKeyThree
        case ButtonKeyFour
        case ButtonKeyFive
        case ButtonKeySix
        case ButtonKeySeven
        case ButtonKeyEight
        case ButtonKeyNine
        case ButtonKeyDelete
        case ButtonKeyCheat
    }
    
    // 読み込むNIBファイルのクラス名
    let QUESTION_CELL_NIB = "QuestionCell"
    let CHECK_POINT_CELL_NIB = "CheckPointCell"
    
    // TableViewCellの識別子
    let QUESTION_CELL_IDENTIFIER = "QuestionCell"
    let CHECK_POINT_CELL_IDENTIFIER = "CheckPointCell"
    
    @IBOutlet var tableView : UITableView!
    
    // 時間などのステータスビュー
    var headerView : CalcStatusView!
    //
    var questionCellArray : NSMutableArray! = NSMutableArray.init()
    // タイマー
    var timeUpdate : Timer!
    // 正答数
    var correctAnwerCount : Int!
    // 現在の問題番号
    var currentQuestionNumber : Int!
    // セル番号
    var indexPathNumber : Int!
    // 点数
    var score : Float!
    // 即答の残り回数
    var cheat : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.correctAnwerCount = 0
        self.currentQuestionNumber = 0
        
        self.initHeaderSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let initQuestionNumFloat : CGFloat = (self.tableView.frame.size.height - CalcStatusView.viewHeight()) / QuestionCell.cellHeight()
        let initQuestionNum : Int = Int(initQuestionNumFloat.rounded(.up))
        
        for i in 0..<initQuestionNum {
            if i > 0 && i % 11 == 0 {
                self.questionCellArray.add(CheckPointCell.initFromNib())
            }
            else {
                self.questionCellArray.add(QuestionCell.initFromNib())
            }
        }
        self.tableView.reloadData()
    }
    
    func initHeaderSetting() {
        // ヘッダー設定
        self.headerView = CalcStatusView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CalcStatusView.viewHeight()))
        self.headerView.calcStatusInit(time: 300, hiScore: 0, score: 0)
        
        // 点数セット
        self.score = 0;
        self.headerView.setScore(score: self.score)
        
        // タイマーセット
        timeUpdate = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(self.updateStatusPerSecond),
                                          userInfo: nil,
                                          repeats: true)
        
        // 即答回数セット
        self.headerView.setCheatNum(cheatNum: 3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timeUpdate.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    // 1セクション毎のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionCellArray.count
    }
    
    // ヘッダーの高さを設定する
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CalcStatusView.viewHeight()
    }
    
    // セルの高さを設定する
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 11 == 0 && indexPath.row > 0 {
            return CheckPointCell.cellHeight()
        }
        
        return QuestionCell.cellHeight()
    }
    
    // MARK: UITableViewDataSource
    // セルの内容を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 11 == 0 && indexPath.row > 0 {
            return self.questionCellArray.object(at: indexPath.row) as! CheckPointCell
        }
        let cell : QuestionCell! = self.questionCellArray.object(at: indexPath.row) as! QuestionCell
        return cell
    }
    
    // 1秒毎に呼ばれるメソッド
    @objc func updateStatusPerSecond(tm : Timer) {
        self.headerView.minusTime()
    }
    
    /**
     答えを入力する
     */
    @IBAction func pushKeyboardButton (_ sender: Any) {
        let buttonTag : Int = (sender as! UIButton).tag
        
        let currentQuestionView : QuestionCell! = self.questionCellArray.object(at: currentQuestionNumber) as! QuestionCell
        // 数字ボタン
        if buttonTag <= PushedButtonKey.ButtonKeyNine.rawValue {
            currentQuestionView.answerLabel.text?.append(buttonTag.description)
        }
        // 削除ボタン
        else if buttonTag == PushedButtonKey.ButtonKeyDelete.rawValue {
            if currentQuestionView.answerLabel.text!.count > 0 {
                currentQuestionView.answerLabel.text?.remove(at: (currentQuestionView.answerLabel.text?.index((currentQuestionView.answerLabel.text?.startIndex)!, offsetBy: (currentQuestionView.answerLabel.text?.count)! - 1))!)
            }
        }
        // 即答ボタン
        else if buttonTag == PushedButtonKey.ButtonKeyCheat.rawValue {
            if self.headerView.cheatNum! > 0 {
                self.headerView.cheatNum! -= 1
                self.headerView.setCheatNum(cheatNum: self.headerView.cheatNum!)
                currentQuestionView.answerLabel.text? = currentQuestionView.resultLabel.text!
            }
            print("残り\(self.headerView.cheatNum!)回")
        }
        
        // 入力した桁数と答えの桁数が一致した時生後判定を行う
        if currentQuestionView.answerLabel.text?.count == currentQuestionView.resultLabel.text?.count {
            currentQuestionView.judgeCalcResult(inputAnswer: currentQuestionView.answerLabel.text!,
                                                calcResult: currentQuestionView.resultLabel.text!)
            self.focusNextQuestion()
            
            self.score = self.score + self.addScore(calcKind: currentQuestionView.calcKind)
            self.headerView.setScore(score: self.score)
        }
    }
    
    func focusNextQuestion() {
        let prevQuestionView : QuestionCell! =
            self.questionCellArray.object(at: currentQuestionNumber) as! QuestionCell
        prevQuestionView.backgroundColor
            = UIColor.clear
        
        // チェックポイントの位置に来たらチェックポイントのセルを追加する
        if self.questionCellArray.count % 11 == 0 && self.questionCellArray.count > 0 {
            let cell : CheckPointCell! = CheckPointCell.initFromNib()
            cell.setCheckPointLabelString(questionNumber: self.questionCellArray.count / 11 * 10)
            self.questionCellArray.add(cell)
        }
        
        let cell : QuestionCell! = QuestionCell.initFromNib()
        self.questionCellArray.add(cell)
        currentQuestionNumber! += 1
        if currentQuestionNumber! % 11 == 0 && currentQuestionNumber! > 0 {
            currentQuestionNumber! += 1
        }
        
        tableView.reloadData()
        
        if currentQuestionNumber > 1 {
            let indexPath : IndexPath = NSIndexPath.init(row: currentQuestionNumber! - 1, section: 0) as IndexPath
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        }
        
        // 現在の問題のセルの色を変える
        let currentQuestionView : QuestionCell! = self.questionCellArray.object(at: currentQuestionNumber) as! QuestionCell
    }
    
    func addScore(calcKind : Int) -> Float {
        var add : Float = 0
        
        switch calcKind {
            case 0:
                add = 1
            case 1:
                add = 1
            case 2:
                add = 1.5
            case 3:
                add = 1.2
            default:
                add = 0
        }
        
        return add
    }
}
