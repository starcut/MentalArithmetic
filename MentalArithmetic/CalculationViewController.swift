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
    // タイマー
    var timeUpdate : Timer!
    // 問題番号
    var questionNumber : Int!
    // 正答数
    var correctAnwerCount : Int!
    // 現在の問題番号
    var currentQuestionNumber : Int!
    // セル番号
    var indexPathNumber : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionNumber = 1
        self.correctAnwerCount = 0
        self.currentQuestionNumber = 1
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setQuestionCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.headerView = CalcStatusView(frame: CGRect(x: 0, y: 0, width: 300, height: CalcStatusView.viewHeight()))
        self.headerView.calcStatusInit(time: 300, hiScore: 0, score: 0)
        
        // タイマーセット
        timeUpdate = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(self.updateStatusPerSecond),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timeUpdate.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // セルのxibファイルをキャッシュに登録
    private func setQuestionCell() {
        let questionNib = UINib(nibName: QUESTION_CELL_NIB, bundle: nil)
        self.tableView.register(questionNib, forCellReuseIdentifier: QUESTION_CELL_IDENTIFIER)
        let checkPointNib = UINib(nibName: CHECK_POINT_CELL_NIB, bundle: nil)
        self.tableView.register(checkPointNib, forCellReuseIdentifier: CHECK_POINT_CELL_IDENTIFIER)
    }
    
    //MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 1セクション毎のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    // ヘッダーの高さを設定する
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CalcStatusView.viewHeight()
    }
    
    // セルの高さを設定する
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 11 == 10 {
            return CheckPointCell.cellHeight()
        }
        return QuestionCell.cellHeight()
    }
    
    // MARK: UITableViewDataSource
    // セルの内容を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 11 == 10 {
            let checkPointCell : CheckPointCell = tableView.dequeueReusableCell(withIdentifier: CHECK_POINT_CELL_IDENTIFIER, for: indexPath) as! CheckPointCell
            checkPointCell.setCheckPointLabelString(questionNumber: (indexPath.row / 11 + 1) * 10)
            return checkPointCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: QUESTION_CELL_IDENTIFIER, for: indexPath) as! QuestionCell
        cell.createCalcQuestion()
        cell.tag = questionNumber
        questionNumber! += 1
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
        
        let currentQuestionView : QuestionCell = self.tableView!.viewWithTag(currentQuestionNumber) as! QuestionCell
        if buttonTag <= PushedButtonKey.ButtonKeyNine.rawValue {
            currentQuestionView.answerLabel.text?.append(buttonTag.description)
        }
        else if buttonTag == PushedButtonKey.ButtonKeyDelete.rawValue {
            if currentQuestionView.answerLabel.text!.count > 0 {
                currentQuestionView.answerLabel.text?.remove(at: (currentQuestionView.answerLabel.text?.index((currentQuestionView.answerLabel.text?.startIndex)!, offsetBy: (currentQuestionView.answerLabel.text?.count)! - 1))!)
            }
        } else if buttonTag == PushedButtonKey.ButtonKeyCheat.rawValue {
            currentQuestionView.answerLabel.text? = currentQuestionView.resultLabel.text!
        }
        
        if currentQuestionView.answerLabel.text?.count == currentQuestionView.resultLabel.text?.count {
            currentQuestionView.judgeCalcResult(inputAnswer: currentQuestionView.answerLabel.text!,
                                                calcResult: currentQuestionView.resultLabel.text!)
            self.focusNextQuestion()
        }
    }
    
    func focusNextQuestion() {
        let prevQuestionView : QuestionCell = self.tableView!.viewWithTag(currentQuestionNumber) as! QuestionCell
        prevQuestionView.backgroundColor
            = UIColor.clear
        
        currentQuestionNumber! += 1
        // 10の倍数番目の問題が終わった時、チェックポイントのセル分余計に動く
        var focusNextQuestionAnimation : CGFloat = QuestionCell.cellHeight()
        if currentQuestionNumber > 10 && currentQuestionNumber % 10 == 3 {
            focusNextQuestionAnimation += CheckPointCell.cellHeight()
        }
        // 最初は例外的な動きをする
        if currentQuestionNumber > 2 {
            tableView.setContentOffset(CGPoint.init(x: tableView.contentOffset.x,
                                                    y: tableView.contentOffset.y + focusNextQuestionAnimation),
                                                    animated: true)
        }
        
        // 現在の問題のセルの色を変える
        let currentQuestionView : QuestionCell = self.tableView!.viewWithTag(currentQuestionNumber) as! QuestionCell
        currentQuestionView.backgroundColor
            = UIColor.cyan
    }
}
