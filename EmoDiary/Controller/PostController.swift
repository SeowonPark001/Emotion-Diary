//
//  PostController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/22.
//

import UIKit

class PostController : UIViewController {
    
    let postView = PostView()   // 연결할 View 이름
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네이게이션 바
        self.navigationItem.title = "감정 일기 작성하기"
        let navi = UINavigationBarAppearance()
        navi.backgroundColor = UIColor(named: "Medium")
        let naviCtrl = navigationController?.navigationBar
        naviCtrl!.standardAppearance = navi
        naviCtrl!.scrollEdgeAppearance = navi
    }
    
    override func loadView() {
        view = postView // 실행 시 해당 뷰로 연결
    }

}
