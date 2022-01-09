//
//  DiaryViewController.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/07.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import UIKit
import VACalendar

class DiaryViewController: UIViewController {
    // Draggable Animator
    private var animator: DraggableTransitionDelegate?
    
    // Calendar
    private var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .short, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    var calendarView: VACalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupBottomSheet()
        setupCalendar()
        setupUIs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY,
                width: view.frame.width,
                height: view.frame.height - weekDaysView.frame.maxY
            )
            calendarView.setup()
        }
    }
    
    func setupNavigationItems() {
    }
    
    func setupBottomSheet() {
        // Bottom Sheet
        let addMealViewController = AddMealViewController()
        animator = DraggableTransitionDelegate(viewControllerToPresent: addMealViewController, presentingViewController: self)
        addMealViewController.transitioningDelegate = animator
        addMealViewController.modalPresentationStyle = .custom
        present(addMealViewController, animated: true) {
            print("completed Presentation")
        }
    }
    
    func setupCalendar() {
        weekDaysView = VAWeekDaysView(frame: .zero)
        weekDaysView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weekDaysView)
        
        weekDaysView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        weekDaysView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        weekDaysView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        weekDaysView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyy"
        
        let startDate = formatter.date(from: "01.01.2020")!
        let endDate = formatter.date(from: "01.01.2023")!
        
        let calendar = VACalendar(
            startDate: startDate,
            endDate: endDate,
            calendar: defaultCalendar
        )
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = false
        calendarView.selectionStyle = .single
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .vertical
        calendarView.setSupplementaries([
            (Date().addingTimeInterval(-(60 * 60 * 70)), [VADaySupplementary.bottomDots([.red, .magenta])]),
            (Date().addingTimeInterval((60 * 60 * 110)), [VADaySupplementary.bottomDots([.red])]),
            (Date().addingTimeInterval((60 * 60 * 370)), [VADaySupplementary.bottomDots([.blue, .darkGray])]),
            (Date().addingTimeInterval((60 * 60 * 430)), [VADaySupplementary.bottomDots([.orange, .purple, .cyan])])
            ])
        view.addSubview(calendarView)
    }
    
    func setupUIs() {
        view.backgroundColor = .white
    }
}

extension DiaryViewController: VAMonthViewAppearanceDelegate {
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .black
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
    func verticalMonthDateFormater() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter
    }
}

extension DiaryViewController: VADayViewAppearanceDelegate {
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .red
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
}

extension DiaryViewController: VACalendarViewDelegate {
    func selectedDate(_ date: Date) {
        print(date)
    }
}
