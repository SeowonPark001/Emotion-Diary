//
//  ViewController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/15.
//

import UIKit
import RealmSwift
import FSCalendar

class CalendarController : UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    var selectedDate: Date = Date() // 기본 선택 날짜 = 오늘
    var strSelectedDate: String = ""
    let calView = CalendarView()
    
    //MARK: - Load View
    
    override func loadView() {
        view = calView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendarUI()
        setNavigationBar()
        setTarget()
        
        // 실행시 스플래시 화면 먼저 출력
        let nextVC = SplashController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 데이터 불러오기
    }
    
    //MARK: - Calendar UI
    
    func setCalendarUI() {
        // 셀 등록
        calView.calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        
        calView.calendar.delegate = self
        calView.calendar.dataSource = self
        
        calView.calendar.locale = Locale(identifier: "ko_KR")
        
        calView.calendar.backgroundColor = .white
        
        // 상단 요일을 한글로 변경
        calView.calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        calView.calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        calView.calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        calView.calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        calView.calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        calView.calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        calView.calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        // 글자 폰트 및 사이즈 지정
        calView.calendar.appearance.weekdayFont = UIFont(name: "IM_Hyemin-Regular", size: 14)
        calView.calendar.appearance.titleFont = UIFont(name: "IM_Hyemin-Regular", size: 16)
        
        // 캘린더 스크롤 가능하게 지정
        calView.calendar.scrollEnabled = true
        // 캘린더 스크롤 방향 지정
        calView.calendar.scrollDirection = .horizontal
        
        // Header dateFormat, 년도, 월 폰트(사이즈)와 색, 가운데 정렬
        calView.calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calView.calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 16)
        calView.calendar.appearance.headerTitleColor = UIColor(named: "Dark")
        calView.calendar.appearance.headerTitleAlignment = .center
        
        // 요일 날짜 색
        calView.calendar.appearance.titleDefaultColor = UIColor(named: "Dark")
        calView.calendar.appearance.titleWeekendColor = UIColor(red: 60, green: 0, blue: 0, alpha: 0.5)
        
        // 요일 글자 색
        calView.calendar.appearance.weekdayTextColor = UIColor(named: "Dark")!.withAlphaComponent(0.6)
        
        // 캘린더 날짜칸
        calView.calendar.appearance.selectionColor = UIColor(named: "Light")
        calView.calendar.appearance.todayColor = UIColor(named: "Bright")
        
        // 캘린더 header 높이 지정
        calView.calendar.headerHeight = 45
        // 캘린더의 cornerRadius 지정
        calView.calendar.layer.cornerRadius = 10
        
        // 양옆 년도, 월 지우기
        calView.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 달에 유효하지 않은 날짜의 색 지정
        calView.calendar.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0.2)
        // 달에 유효하지않은 날짜 지우기
        calView.calendar.placeholderType = .none
        
        // 캘린더 숫자와 subtitle간의 간격 조정
        calView.calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        
        calView.calendar.select(selectedDate) // 오늘 날짜 선택
    }
    
    // 특정 날짜에 이미지 세팅
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        // 데이터 불러와서 이미지 출력하기
        return nil
    }
    
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        let strSelectedDate = configureDate(date: date)
        
        // 선택한 날짜에 해당하는 데이터 => 아래 일기 카드에 출력
        
        selectedDate = date
    }
    
    // 해당 날짜 : Date -> String
    func configureDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY.MM.dd"
        dateFormatter.locale = Locale(identifier: "ko-KR") // 한국 시간 지정
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") // 한국 시간대 지정
        
        return dateFormatter.string(from: date)
    }
    
    //MARK: - 네비게이션바 & 버튼
    
    func setNavigationBar() {
        title = "감정 일기"
        
        let navi = UINavigationBarAppearance()
        navi.configureWithOpaqueBackground()
        navi.backgroundColor = UIColor(named: "Bright")
        navi.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let naviCtrl = navigationController?.navigationBar
        naviCtrl?.standardAppearance = navi
        naviCtrl?.scrollEdgeAppearance = navi
        naviCtrl?.tintColor = .white

        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navi
        navigationItem.standardAppearance = navi
        navigationItem.compactAppearance = navi
    }
    
    
    func setTarget() {
        
        calView.menuBtn.addTarget(self, action: #selector(tapMenuBtn), for: .touchUpInside)
        calView.addBtn.addTarget(self, action: #selector(tapAddBtn), for: .touchUpInside)
        calView.listBtn.addTarget(self, action: #selector(tapListBtn), for: .touchUpInside)

    }
    
    @objc func tapMenuBtn() {
        print("(+) 메뉴 버튼 클릭")
        
        calView.addBtn.layer.cornerRadius = calView.addBtn.frame.size.height / 2
        calView.addBtn.clipsToBounds = true
        calView.listBtn.layer.cornerRadius = calView.listBtn.frame.size.height / 2
        calView.listBtn.clipsToBounds = true
        
        // 버튼 누를 때마다 나타났다/사라졌다 토글 지정
        calView.addBtn.isHidden.toggle()
        calView.listBtn.isHidden.toggle()
    }
    
    @objc func tapAddBtn(){
        if calView.review.text == "오늘의 일기를 남겨보세요." { // 해당 날짜에 일기 기록이 없을 경우
            let nextVC = PostController()
            nextVC.delegate = self
            nextVC.recordDate = selectedDate
            
            navigationController?.pushViewController(nextVC, animated: true)
        }
        else { // 해당 날짜에 일기 기록이 존재하는 경우
            var alert = UIAlertController(title: "⚠️\n이미 일기 기록이 있어요!\n", message: "목록에서 일기 내용을 수정해주세요.", preferredStyle: .alert)
            let success = UIAlertAction(title: "확인", style: .default) { [self] action in
                print("확인버튼이 눌렸습니다.")
            }
            alert.addAction(success)
            self.present(alert, animated: true, completion: nil)
        }
    }

    @objc func tapListBtn(){
        let nextVC = ListController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}


// 작성 페이지와 연결된 Delegate Pattern
protocol UpdateDelegate {
    func updateDiary(date: Date)
}

extension CalendarController: UpdateDelegate {
    // 선택한 날짜 업데이트
    func updateDiary(date: Date) {
        print("기록한 날짜 전달받음")
        
        selectedDate = date
        strSelectedDate = configureDate(date: selectedDate)
        // 해당 날짜 데이터 받아오기
    }
}
