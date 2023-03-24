//
//  ViewController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/15.
//

import UIKit

protocol UpdateDelegate { // 작성 페이지 내용을 그대로 가져와서 출력
    func updateDiary(emojiIndex: Int, str: String)
}

class CalendarController : BaseController {
    
    let calView = CalendarView()
    
    override func loadView() {
        view = calView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTarget()
    }
    
    func setNavigationBar() {
        title = "감정 일기"
        
        let navi = UINavigationBarAppearance()
        navi.configureWithOpaqueBackground()
        navi.backgroundColor = UIColor(named: "Medium")
        navi.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let naviCtrl = navigationController?.navigationBar
        naviCtrl?.standardAppearance = navi
        naviCtrl?.scrollEdgeAppearance = navi
    
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navi
        navigationItem.standardAppearance = navi
        navigationItem.compactAppearance = navi
    }
    
    func setTarget() {
        calView.addBtn.addTarget(self, action: #selector(tapAddBtn), for: .touchUpInside)
    }
    
    @objc func tapAddBtn(){
        let nextVC = PostController()
        nextVC.delegate = self
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
}

extension CalendarController : UpdateDelegate {
    // 감정 이모티콘 업데이트
    func updateDiary(emojiIndex: Int, str: String) {
        calView.review.text = str
        
        switch emojiIndex {
        case 0:
            calView.emotion1.image = #imageLiteral(resourceName: "Neutral")
            calView.emotion2.image = #imageLiteral(resourceName: "Neutral")
        case 1:
            calView.emotion1.image = #imageLiteral(resourceName: "Happy")
            calView.emotion2.image = #imageLiteral(resourceName: "Happy")
        case 2:
            calView.emotion1.image = #imageLiteral(resourceName: "Touched")
            calView.emotion2.image = #imageLiteral(resourceName: "Touched")
        case 3:
            calView.emotion1.image = #imageLiteral(resourceName: "Sad")
            calView.emotion2.image = #imageLiteral(resourceName: "Sad")
        case 4:
            calView.emotion1.image = #imageLiteral(resourceName: "Hopeless")
            calView.emotion2.image = #imageLiteral(resourceName: "Hopeless")
        case 5:
            calView.emotion1.image = #imageLiteral(resourceName: "Angry")
            calView.emotion2.image = #imageLiteral(resourceName: "Angry")
        default: print("해당 날짜의 감정 없음")
        }
        print("해당 날짜의 감정, 일기 데이터 불러옴")
    }
}
