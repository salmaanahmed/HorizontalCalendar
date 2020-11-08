//
//  HorizontalCalendar.swift
//  HorizontalCalendar
//
//  Created by Salmaan Ahmed on 17/08/2020.
//  Copyright © 2020 Salmaan Ahmed. All rights reserved.
//

import Foundation
import UIKit

private let dateCellHeight: CGFloat = 35

let fontSmall: CGFloat = 12
let fontMedium: CGFloat = 14
let fontLarge: CGFloat = 16


public class HorizontalCalendar: UIView {
    
    static var dateFormat = "EEEE, MMM d"
    
    static var selectedColor = UIColor(red: 0/255, green: 133/255, blue: 154/255, alpha: 1)
    static var todayColor = UIColor(red: 255/255, green: 62/255, blue: 85/255, alpha: 1)
    static var textDark = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    static var textLight = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
    static var dateColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)

    let border = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)

    private lazy var dateLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.text = "Thursday, May 30"
        label.font = .boldSystemFont(ofSize: fontLarge)
        label.textColor = HorizontalCalendar.dateColor
        
        return label
    }()
    
    private lazy var arrow: UIImageView = { [unowned self] in
        let image = UIImageView()
        image.image = UIImage(named: "icon-arrow-down")
        image.transform = CGAffineTransform(rotationAngle: .pi)
        return image
    }()
    
    private lazy var todayButton: UIButton = { [unowned self] in
        let button = UIButton(type: .system)
        button.setTitle("Go to Today", for: .normal)
        button.setTitleColor(HorizontalCalendar.textDark, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: fontMedium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        button.layer.cornerRadius = 5
        button.tintColor = .red
        button.layer.borderWidth = 1
        button.layer.borderColor = border.cgColor
        button.isHidden = true
        return button
    }()
    
    private lazy var weekDays: UIView = { [unowned self] in
        let stackView = UIStackView()
        stackView.addArrangedSubview(WeekDayLabel(with: "S", isDark: false))
        stackView.addArrangedSubview(WeekDayLabel(with: "M"))
        stackView.addArrangedSubview(WeekDayLabel(with: "T"))
        stackView.addArrangedSubview(WeekDayLabel(with: "W"))
        stackView.addArrangedSubview(WeekDayLabel(with: "T"))
        stackView.addArrangedSubview(WeekDayLabel(with: "F"))
        stackView.addArrangedSubview(WeekDayLabel(with: "S", isDark: false))
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isDirectionalLockEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DateViewCell.self, forCellWithReuseIdentifier: DateViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isHidden = true
        return collectionView
    }()
    
    private var firstTime = true
    private let createCellThreshold = 5
    private let calendar = Calendar.current
    
    private var currentIndex: Int {
        didSet {
            selectedDate = list[currentIndex].weekDates[selectedWeekDay]
        }
    }
    
    private let today = Date()
    private var list = [Date]()

    public var selectedWeekDay: Int
    public var selectedDate: Date {
        didSet {
            dateLabel.text = selectedDate.string(format: Self.dateFormat)
            todayButton.isHidden = selectedDate.isToday
            onSelectionChanged?(selectedDate)
        }
    }
    
    public var onSelectionChanged: ((Date) -> Void)?
    
    var collectionViewToBottom: NSLayoutConstraint!
    var dateViewToBottom: NSLayoutConstraint!
    
    public override init(frame: CGRect) {
        
        selectedWeekDay = today.dayOfTheWeek
        selectedDate = today
        currentIndex = createCellThreshold
        
        super.init(frame: frame)
                
        setupViews()
        
        list.append(today.startOfWeek)
        loadCells(after: today)
        loadCells(before: today)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: IndexPath(row: self?.createCellThreshold ?? 5, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleCalendar() {
        let shouldShow = arrow.transform == CGAffineTransform.identity
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.collectionView.isHidden = shouldShow
            self?.weekDays.isHidden = shouldShow
            self?.arrow.transform = CGAffineTransform(rotationAngle: shouldShow ? .pi : 0)
            self?.dateViewToBottom.isActive = shouldShow
            self?.collectionViewToBottom.isActive = !shouldShow
        })
    }
}

// MARK: - Setup Views
extension HorizontalCalendar {
    private func setupViews() {
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateViewToBottom = dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            dateViewToBottom
        ])
        
        arrow.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrow)
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalTo: dateLabel.heightAnchor),
            arrow.heightAnchor.constraint(equalTo: dateLabel.heightAnchor),
            arrow.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8),
            arrow.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
        
        [dateLabel, arrow].forEach {
            $0.addTapGestureRecognizer { [weak self] in
                self?.toggleCalendar()
            }
        }
        
        todayButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(todayButton)
        NSLayoutConstraint.activate([
            todayButton.heightAnchor.constraint(equalToConstant: 25),
            todayButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            todayButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
        
        todayButton.addTapGestureRecognizer { [weak self] in
            guard let startOfWeek = self?.today.startOfWeek,
                  let index = self?.list.firstIndex(of: startOfWeek),
                let dayOfWeek = self?.today.dayOfTheWeek else {
                return
            }
            
            self?.selectedWeekDay = dayOfWeek
            self?.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
            if self?.currentIndex == index {
                self?.collectionView.reloadData()
            }
        }
        
        weekDays.translatesAutoresizingMaskIntoConstraints = false
        addSubview(weekDays)
        NSLayoutConstraint.activate([
            weekDays.heightAnchor.constraint(equalToConstant: 30),
            weekDays.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            weekDays.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            weekDays.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionViewToBottom = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: dateCellHeight),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: weekDays.bottomAnchor)
        ])
    }
}

// MARK: - Collection View Delegates
extension HorizontalCalendar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateViewCell.reuseIdentifier, for: indexPath) as? DateViewCell else {
            fatalError("Unable to dequeue DateViewCell")
        }
        
        cell.onSelectionChanged = { [weak self] selectedIndex in
            self?.selectedWeekDay = selectedIndex
            self?.currentIndex = indexPath.row
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if firstTime {
            collectionView.scrollToItem(at: IndexPath(row: createCellThreshold, section: 0), at: .centeredHorizontally, animated: false)
            firstTime = false
            return
        }
        
        if indexPath.row < createCellThreshold, let date = list.first {
            loadCells(before: date)
        } else if list.count - indexPath.row < createCellThreshold, let date = list.last {
            loadCells(after: date)
        }
        
        guard let cell = cell as? DateViewCell else { return }
        let date = list[indexPath.row]
        cell.setup(with: date, selectedIndex: selectedWeekDay)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let index = collectionView.indexPathsForVisibleItems.first?.row else {
            return
        }
        currentIndex = index
    }
  
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.size.width - 16
        return CGSize(width: width, height: dateCellHeight)
    }
}

// MARK: - Infinite scroll
extension HorizontalCalendar {
    private func loadCells(after: Date) {
        var date = after
        var tmpList = [Date]()
        for _ in 0..<createCellThreshold {
            date = date.startOfNextWeek
            tmpList.append(date)
        }
        list += tmpList
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    private func loadCells(before: Date) {
        var date = before
        var tmpList = [Date]()
        for _ in 0..<createCellThreshold {
            date = date.startOfPreviousWeek
            tmpList.append(date)
        }
        list = tmpList.reversed() + list
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self, let index = strongSelf.collectionView.indexPathsForVisibleItems.first?.row else {
                    return
            }
            
            let indexPath = IndexPath(row: index + strongSelf.createCellThreshold + 1, section: 0)
            strongSelf.collectionView.reloadData()
            strongSelf.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

// MARK: - Collection view cell
class DateViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DateViewCellIdentifier"
    
    private lazy var datesView: UIView = { [unowned self] in
        let stackView = UIStackView()
        stackView.addArrangedSubview(WeekDayLabel(with: "7", isDark: false))
        stackView.addArrangedSubview(WeekDayLabel(with: "8"))
        stackView.addArrangedSubview(WeekDayLabel(with: "9"))
        stackView.addArrangedSubview(WeekDayLabel(with: "10"))
        stackView.addArrangedSubview(WeekDayLabel(with: "11"))
        stackView.addArrangedSubview(WeekDayLabel(with: "12"))
        stackView.addArrangedSubview(WeekDayLabel(with: "13", isDark: false))
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var dates = [Date]()
    var onSelectionChanged: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(datesView)
        datesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            datesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            datesView.topAnchor.constraint(equalTo: topAnchor),
            datesView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for (index, date) in datesView.subviews.enumerated() {
            date.addTapGestureRecognizer { [weak self] in
                self?.select(at: index)
            }
        }
    }
    
    func select(at selectedIndex: Int) {
        for (index, date) in datesView.subviews.enumerated() {
            guard let dayLabel = date as? WeekDayLabel else { return }
            dayLabel.isTextRed = dates[index].isToday
            dayLabel.isSelected = index == selectedIndex
        }
        onSelectionChanged?(selectedIndex)
    }
    
    func setup(with startDate: Date, selectedIndex: Int) {
        dates = startDate.weekDates
        
        for (index, (view, date)) in zip(datesView.subviews, dates).enumerated() {
            guard let dayLabel = view as? WeekDayLabel else { continue }
            
            dayLabel.set(text: "\(date.day)")
            dayLabel.isTextRed = dates[index].isToday
            dayLabel.isSelected = index == selectedIndex
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Week Day Label
class WeekDayLabel: UIView {
    
    private lazy var label: UILabel = { [unowned self] in
        let label = UILabel()
        label.layer.cornerRadius = dateCellHeight / 2
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private var isDark: Bool
    
    var isSelected: Bool = false {
        didSet {
            label.backgroundColor = isSelected ? HorizontalCalendar.selectedColor : .clear
            updateTextColor()
        }
    }
    
    var isTextRed: Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    init(with text: String, isDark: Bool = true) {
        self.isDark = isDark
        super.init(frame: .zero)
        
        label.textColor = isDark ? HorizontalCalendar.textDark : HorizontalCalendar.textLight
        label.text = text
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: dateCellHeight),
            label.heightAnchor.constraint(equalToConstant: dateCellHeight)
        ])
    }
    
    private func updateTextColor() {
        if isSelected {
            label.textColor = .white
        } else if isTextRed {
            label.textColor = HorizontalCalendar.todayColor
        } else if isDark {
            label.textColor = HorizontalCalendar.textDark
        } else {
            label.textColor = HorizontalCalendar.textLight
        }
    }
    
    func set(text: String) {
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
