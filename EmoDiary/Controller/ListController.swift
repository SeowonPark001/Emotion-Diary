//
//  ListController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/31.
//

import UIKit
import RealmSwift

class ListController: UIViewController {
    
    var realm: Realm!
    var load: Results<DiaryData>?
    var dataList: Results<DiaryData>?
    
    let searchController = UISearchController()
    var searchText: String = ""
    
    // ListView (X) >> UITableView 선언 (O)
    private let tableView = UITableView()


    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        load = realm!.objects(DiaryData.self).sorted(byKeyPath: "date", ascending: false)
        
        view.backgroundColor = .white
        
        setNavigationBar()
        setupSearchBar()
        
        setConstraints()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 화면이 나타날 때마다 데이터 불러오기
        loadData()
    }
    
    // Realm Data -> Tableview loading
    func loadData() {
        realm = try! Realm()
        // DiaryData 데이터 가져오기 - 날짜기준 내림차순
        load = realm!.objects(DiaryData.self).sorted(byKeyPath: "date", ascending: false)
        dataList = load
        
        tableView.reloadData()
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
    
    func setConstraints() { // Table View 설정
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120 // Cell의 높이 설정
        
        tableView.register(ListView.self, forCellReuseIdentifier: "DiaryCell")
    }
    
}

//MARK: - Searchbar
extension ListController : UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // Cancel 버튼을 눌렀을 때
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataList = load
        tableView.reloadData()
    }
    
    // 검색(Search) 버튼을 눌렀을때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = (searchController.searchBar.text?.lowercased())! // 검색바 텍스트
        print("검색 단어: \(searchText)")
        
        dataList = load!.filter("review CONTAINS[c] '\(searchText)'")
        print(dataList)
        tableView.reloadData()
    }
    
    // 서치바에서 글자가 바뀔 때마다 소문자로 변환하기 (= 대문자 입력 막기)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.lowercased()
    }
    
    //MARK: - Table View
    
    // 1) Table View에 몇개의 데이터를 표시할 것인지 (= 셀이 몇개인지)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return dataList!.count
    }
    
    // 2) 셀의 구성 (표시하고자 하는 데이터)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! ListView
    
        if dataList != nil {
            let ymd = dataList![indexPath.row].date.split(separator: ".")
            
            if ymd[1].prefix(1) == "0" { // 01 ~ 09월
                cell.mmDate.text = "\(ymd[1].suffix(1))월"
            } else { // 10 ~ 12월
                cell.mmDate.text = "\(ymd[1])월"
            }
            if ymd[2].prefix(1) == "0" { // 01 ~ 09일
                cell.ddDate.text = "\(ymd[2].suffix(1))"
            } else { // 10 ~31일
                cell.ddDate.text = "\(ymd[2])"
            }
            cell.emoji.image = UIImage(named: (dataList?[indexPath.row].emotion)!)
            cell.review.text = dataList?[indexPath.row].review
            cell.selectionStyle = .none
        }
        return cell
    }
    
    // 3) 셀이 선택이 되었을 때 어떤 동작을 할 것인지 => 다음 화면으로 이동!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("nofi: \(indexPath)")
        
        let detailVC = PostController()
        detailVC.realmData = load?[indexPath.row]
        print("nofi: \(indexPath.row)")
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
