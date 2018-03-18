//
//  MyPageViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import GaugeKit
import RealmSwift

class MyPageViewController: UIViewController {

    @IBOutlet var gauge: Gauge!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var viewHashtag: UIView!
    @IBOutlet var labelHashtag: UILabel!
    @IBOutlet var viewList: UIView!
    @IBOutlet var viewCard: UIView!
    @IBOutlet var viewMeetup: UIView!
    var realm: Realm!
   
    var userInfo: UserInfo!
    var projectInfo: ProjectInfo!
    var goalListInfo: GoalListInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        viewHashtag.layer.cornerRadius = 5
        viewHashtag.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        let meetup = MyPageMeetupView.instanceFromXib()
        meetup.frame.size = viewMeetup.frame.size
        meetup.layer.cornerRadius = 5
        viewMeetup.addSubview(meetup)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
        if(self.view.subviews.last is UILabel){
            self.view.subviews.last?.removeFromSuperview()
        }
        if(viewList.subviews.count != 0){
            viewList.subviews.last?.removeFromSuperview()
        }
        if(viewCard.subviews.count != 0){
            viewCard.subviews.last?.removeFromSuperview()
        }
        
        let list = MyPageListView.instanceFromXib()
        let card = MyPageCardView.instanceFromXib()
        list.frame.size = viewList.frame.size
        card.frame.size = viewCard.frame.size
        list.layer.cornerRadius = 5
        card.layer.cornerRadius = 5
        viewList.addSubview(list)
        viewCard.addSubview(card)
        
        gauge.rate = CGFloat(gaugeRate())
        let imageData = realm.objects(UserInfo.self).last!.image
        imageView.image = UIImage(data: imageData)
        let lineWidth = gauge.lineWidth / 2
        let percent = gauge.rate * 100 / gauge.maxValue
        let radian = (percent * 18 / 5) * CGFloat.pi / 180
        let gaugePosition = gauge.frame.origin
        let centerX = gaugePosition.x + gauge.frame.width / 2
        let centerY = gaugePosition.y + gauge.frame.height / 2
        let radius = gauge.frame.width / 2
        let labelX = centerX + radius * sin(radian)
        let labelY = centerY - radius * cos(radian)
        let label = UILabel(frame: CGRect(x: labelX, y: labelY, width: 40, height: 40))
        label.frame.origin.x -= label.frame.width / 2
        label.frame.origin.y -= label.frame.height / 2
        let distanceX = label.frame.origin.x + (label.frame.width / 2) - (centerX + (radius - lineWidth) * sin(radian))
        let distanceY = label.frame.origin.y + (label.frame.height / 2) - (centerY - (radius - lineWidth) * cos(radian))
        label.frame.origin.x -= distanceX
        label.frame.origin.y -= distanceY
        label.layer.masksToBounds = false
        label.layer.cornerRadius = label.frame.height / 2
        label.clipsToBounds = true
        label.backgroundColor = gauge.startColor
        label.text = "\(Int(percent))%"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        view.addSubview(label)
        
        labelHashtag.text = getHashTags()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSetting(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyPageDetailViewController")
        present(controller, animated: true)
    }
    
    func gaugeRate() -> Int{
        realm = try! Realm()
        projectInfo = realm.objects(ProjectInfo.self).last
        let startStr = projectInfo.period
        let todayStr = projectInfo.todayDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = dateFormatter.date(from: startStr)!
        let todayDate = dateFormatter.date(from: todayStr)!
        let interval = todayDate.timeIntervalSince(startDate)
        let days = Int(interval / 86400)
        
        return days
    }
    
    func getHashTags() -> String {
        realm = try! Realm()
        let tagList = realm.objects(GoalListInfo.self).filter("todo contains '#'")
        var cnt = tagList.count-1
        var tags = ""
        var tagDict: [String:Int] = [:]
        
        for var i in 0...cnt {
            if let freq = tagDict[tagList[i].todo] {
               tagDict[tagList[i].todo] = freq+1
            } else {
                tagDict[tagList[i].todo] = 0
            }
        }
        let sortedArr = tagDict.sorted(by: { $0.1 > $1.1 })
        cnt = sortedArr.count-1
        
        for i in 0...cnt {
            tags += sortedArr[i].key + " "
        }
        return tags
    }
}
