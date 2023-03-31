//
//  ViewController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/15.
//

import UIKit
import RealmSwift


class CalendarController : UIViewController {
    
    let calView = CalendarView()
    
    //MARK: - Load View
    
    override func loadView() {
        view = calView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTarget()
        
        // 실행시 스플래시 화면 먼저 출력
        let nextVC = SplashController()
        self.navigationController?.pushViewController(nextVC, animated: true)
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
        //nextVC.delegate = self
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
}
