//
//  NomadLifeViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RealmSwift

class NomadViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var centerView: UIView!
    @IBOutlet var labelToday: UILabel!
    @IBOutlet var labelDays: UILabel!
    @IBOutlet var underView: NomadAddView!
    var workView: NomadWorkView! = nil
    var lifeView: NomadLifeView! = nil
    
    var keyboardHeight: CGFloat = 0
    var keyboardHideCount = 0
    var keyboardShowCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //아래 두 카테고리 중 한 부분만 실행해야 한다.
        
        //일 관련일 때는 테이블뷰
//        workView = NomadWorkView.instanceFromXib() as! NomadWorkView
//        workView.frame.size = centerView.frame.size
//        centerView.addSubview(workView)
        
        //삶 관련일 때는 컬렉션뷰
        lifeView = NomadLifeView.instanceFromXib() as! NomadLifeView
        lifeView.frame.size = centerView.frame.size
        centerView.addSubview(lifeView)
        
        labelDays.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        keyboardShowCount = 0
        if(underView.layer.sublayers != nil){
            underView.layer.sublayers?.removeFirst()
        }
        if(underView.subviews.count == 1){
            underView.subviews.first?.removeFromSuperview()
        }
        let view = NomadAddView.instanceFromXib() as! NomadAddView
        view.frame.size = underView.frame.size
        if(centerView.subviews.first is NomadWorkView) {
            //분홍색 계열 (색A, 일)
            searchBar.barTintColor = UIColor(red: 243/255, green: 171/255, blue: 160/255, alpha: 1)
            view.applyGradient([UIColor(red: 251/255, green: 242/255, blue: 241/255, alpha: 1), UIColor(red: 238/255, green: 195/255, blue: 191/255, alpha: 1)])
            let rows = workView.tableView.numberOfRows(inSection: 0)
            let completeRows = { () -> Int in
                var completes = 0
                var row = 0
                while let cell = workView.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? NomadWorkCell {
                    if(cell.checkBox.on){
                        completes += 1
                    }
                    row += 1
                }
                return completes
            }()
            view.contentSummaryValue.text = "\(completeRows)/\(rows)"
            view.textField.placeholder = "할 일, #해시태그"
            if let firstContent = (workView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NomadWorkCell).content.titleLabel?.text {
                view.contentSummary.text = "\(firstContent) 외 \(rows-1)개"
            }
        } else {
            //보라색 계열 (색B, 삶)
            searchBar.barTintColor = UIColor(red: 194/255, green: 187/255, blue: 210/255, alpha: 1)
            view.applyGradient([UIColor(red: 251/255, green: 244/255, blue: 243/255, alpha: 1), UIColor(red: 201/255, green: 195/255, blue: 215/255, alpha: 1)])
            let rows = lifeView.collectionView.numberOfItems(inSection: 0) - 1
            let completeRows = { () -> Int in
                var completes = 0
                var row = 0
                while let cell = lifeView.collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? NomadLifeCell {
                    if(cell.checkBox.on){
                        completes += 1
                    }
                    row += 1
                }
                return completes
            }()
            view.contentSummaryValue.text = "\(completeRows)/\(rows)"
            view.textField.placeholder = "하고 싶은 카드를 추가해보세요"
            if let firstContent = (lifeView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! NomadLifeCell).content.text {
                view.contentSummary.text = "\(firstContent) 외 \(rows-1)개"
            }
        }
        underView.addSubview(view)
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월 d일 eeee"
        labelToday.text = "오늘 \(dateFormatter.string(from: today))"
        labelDays.applyGradient([UIColor(red: 128/255, green: 184/255, blue: 223/255, alpha: 1), UIColor(red: 178/255, green: 216/255, blue: 197/255, alpha: 1)])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if(keyboardShowCount >= 1) { return }
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.keyboardHeight = keyboardHeight
            if(centerView.subviews.first is NomadWorkView){
                workView.tableView.frame.size.height -= keyboardHeight
            } else {
                lifeView.collectionView.frame.size.height -= keyboardHeight
            }
            underView.frame.origin.y -= keyboardHeight
            self.keyboardShowCount += 1
        }
    }
    @objc func keyboardWillHide(_ notification: Notification){
        self.keyboardHideCount += 1
        if(self.keyboardHideCount == 1){
            if(centerView.subviews.first is NomadWorkView){
                workView.tableView.frame.size.height += self.keyboardHeight
                
            } else {
                lifeView.collectionView.frame.size.height += self.keyboardHeight
            }
            underView.frame.origin.y += self.keyboardHeight
        } else {
            self.keyboardHideCount = 0
        }
        self.keyboardShowCount = 0
    }
}

