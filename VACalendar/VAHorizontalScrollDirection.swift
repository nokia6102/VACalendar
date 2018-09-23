//
//  VAHorizontalScrollDirection.swift
//  Pods-VACalendarExample
//
//  Created by Vodolazkyi Anton on 9/18/18.
//

import UIKit

public class VAHorizontalScrollDirection: VACalendarScrollDirection {
    
    private let maxNumberOfWeek = 6
    
    override var weekHeight: CGFloat {
        return calendarView.frame.height / CGFloat(maxNumberOfWeek)
    }
    
    public override init(calendarView: VACalendarView, periodType: VAPeriodType = VAMonthPeriodType()) {
        calendarView.isPagingEnabled = true
        super.init(calendarView: calendarView, periodType: periodType)
    }
    
    override func nextMonth() {
        guard let currentMonth = getMonthView(with: calendarView.contentOffset) else { return }
        guard let currentMonthIndex = calendarView.monthViews.index(of: currentMonth) else { return }
        
        let nextMonthIndex = calendarView.monthViews.index(after: currentMonthIndex)
        
        guard nextMonthIndex < calendarView.monthViews.endIndex else { return }
        
        let nextMonth = calendarView.monthViews[nextMonthIndex]
        drawMonth(nextMonth)
        calendarView.setContentOffset(nextMonth.frame.origin, animated: false)
    }
    
    override func previousMonth() {
        guard let currentMonth = getMonthView(with: calendarView.contentOffset) else { return }
        guard let currentMonthIndex = calendarView.monthViews.index(of: currentMonth) else { return }
        
        let nextMonthIndex = calendarView.monthViews.index(before: currentMonthIndex)
        
        guard nextMonthIndex > calendarView.monthViews.startIndex else { return }
        
        let nextMonth = calendarView.monthViews[nextMonthIndex]
        drawMonth(nextMonth)
        calendarView.setContentOffset(nextMonth.frame.origin, animated: false)
    }
    
    override func changeViewType() {
        periodType = periodType.nextPeriod()
        calculateContentSize()
        drawMonths()
        calendarView.scrollToStartDate()
    }
    
    override func calculateContentSize() {
        calendarView.contentSize = periodType.calculateContentSize(for: calendarView)
    }
    
    override func drawMonths() {
        periodType.drawMonths(in: calendarView)
    }
    
    override func getMonthView(with offset: CGPoint) -> VAMonthView? {
        return periodType.getMonthView(in: calendarView, offset: offset)
    }
    
    override func drawMonth(_ month: VAMonthView?) {
        let offset = month?.frame.origin ?? .zero
        let first: ((offset: Int, element: VAMonthView)) -> Bool = { $0.element.frame.midX >= offset.x }
        guard let currentIndex = calendarView.monthViews.enumerated().first(where: first)?.offset else { return }
        
        calendarView.monthViews.enumerated().forEach { index, month in
            if index == currentIndex || index + 1 == currentIndex || index - 1 == currentIndex {
                month.delegate = calendarView
                month.setupWeeksView(with: periodType, shouldShowMonthLabel: false)
            } else {
                month.clean()
            }
        }
    }
    
    override func scrollToMonth(_ month: VAMonthView?) {
        let offset = periodType.scrollOffset(for: month, date: calendarView.startDate)
        calendarView.setContentOffset(offset, animated: false)
    }
    
}
