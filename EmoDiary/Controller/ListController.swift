//
//  ListController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/31.
//

import UIKit
import RealmSwift

class ListController: UIViewController, UISearchBarDelegate {
    
    let searchController = UISearchController()
    
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setNavigationBar()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 화면이 나타날 때마다 데이터 불러오기
    }
    
    func setNavigationBar() {
        title = "일기 모아보기"
        
        let navi = UINavigationBarAppearance() // 네비게이션바 모양 초기화
        navi.configureWithOpaqueBackground() // 현재 테마에 적합한 불투명한 색상 세트로 막대 모양 개체 구성
        navi.backgroundColor = UIColor(named: "Bright") // 배경색
        navi.titleTextAttributes = [.foregroundColor: UIColor.white] // 타이틀 글자색

        let naviCtrl = navigationController?.navigationBar
        naviCtrl?.standardAppearance = navi // 표준 높이 설정
        naviCtrl?.scrollEdgeAppearance = navi // 스크롤 후 내용의 모서리가 네비게이션바에 닿으면 해당 프로퍼티의 크기 설정 적용?
        naviCtrl?.compactAppearance = navi // << 작은 화면일 때 작은 높이 설정
        naviCtrl?.tintColor = .white // << ??
        
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false // 반투명X
        
        navigationItem.scrollEdgeAppearance = navi
        navigationItem.standardAppearance = navi
        navigationItem.compactAppearance = navi
    }
    
    func setupSearchBar() {

        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.backgroundColor = .white
        navigationItem.searchController?.searchBar.tintColor = .gray
        navigationItem.hidesSearchBarWhenScrolling = false
    
        searchController.searchBar.delegate = self
    }
    
    
}
