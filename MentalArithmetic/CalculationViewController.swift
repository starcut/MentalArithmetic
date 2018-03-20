//
//  CalculationViewController.swift
//  MentalArithmetic
//
//  Created by stardust on 2018/02/06.
//  Copyright © 2018年 stardust. All rights reserved.
//

import UIKit

class CalculationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // 読み込むNIBファイルのクラス名
    let QUESTION_CELL_NIB = "QuestionCell"
    let CHECK_POINT_CELL_NIB = "CheckPointCell"
    
    // TableViewCellの識別子
    let QUESTION_CELL_IDENTIFIER = "QuestionCell"
    let CHECK_POINT_CELL_IDENTIFIER = "CheckPointCell"
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var keyboardView : InputBoard!
    
    // 時間などのステータスビュー
    var headerView : CalcStatusView!
    // タイマー
    var timeUpdate : Timer!
    // 問題番号
    var questionNumber : Int!;
    // 正答数
    var correctAnwerCount : Int!;
    // 現在の問題番号
    var currentQuestionNumber : Int!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionNumber = 1;
        self.correctAnwerCount = 0;
        self.currentQuestionNumber = 1;
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setQuestionCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.keyboardView = InputBoard.init(frame: self.keyboardView.frame)
        
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
        // Dispose of any resources that can be recreated.
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
        return 100;
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
        
        self.focusNextQuestion()
    }
    
    func inputAnwer() {
        
    }
    
    func focusNextQuestion() {
        let prevQuestionView : QuestionCell = self.tableView!.viewWithTag(currentQuestionNumber) as! QuestionCell
        prevQuestionView.backgroundColor
            = UIColor.clear
        
        currentQuestionNumber! += 1
        
        var focusNextQuestionAnimation : CGFloat = QuestionCell.cellHeight()
        if currentQuestionNumber > 10 && currentQuestionNumber % 10 == 3 {
            focusNextQuestionAnimation += CheckPointCell.cellHeight()
        }
        if currentQuestionNumber > 2 {
            tableView.setContentOffset(CGPoint.init(x: tableView.contentOffset.x, y: tableView.contentOffset.y + focusNextQuestionAnimation), animated: true)
        }
        
        let currentQuestionView : QuestionCell = self.tableView!.viewWithTag(currentQuestionNumber) as! QuestionCell
        currentQuestionView.backgroundColor
            = UIColor.cyan
    }
}
