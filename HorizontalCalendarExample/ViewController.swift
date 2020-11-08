//
//  ViewController.swift
//  HorizontalCalendarExample
//
//  Created by Salmaan Ahmed on 17/08/2020.
//  Copyright © 2020 Salmaan Ahmed. All rights reserved.
//

import UIKit
import HorizontalCalendar

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let calendar = HorizontalCalendar()
        
        view.addSubview(calendar)

        calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            calendar.leftAnchor.constraint(equalTo: view.leftAnchor),
            calendar.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        calendar.backgroundColor = UIColor("#f7f7f7")
        
        calendar.onSelectionChanged = { date in
            print(date)
        }
    }
}


extension UIColor {
  
  convenience init(_ hex: String, alpha: CGFloat = 1.0) {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) { cString.removeFirst() }
    
    if ((cString.count) != 6) {
        self.init("ff0000") // return red color for wrong hex input
      return
    }
    
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }

}
