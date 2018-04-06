//
//  AUPickerCell.swift
//  AUPickerCell
//
//  Created by Aziz Uysal on 3/23/17.
//  Copyright © 2017 Aziz Uysal. All rights reserved.
//

import Foundation
import UIKit

public protocol AUPickerCellDelegate {
  func auPickerCell(_ cell: AUPickerCell, didPick row: Int, value: Any)
}

public class AUPickerCell: UITableViewCell {
  
  public enum PickerType {
    case `default`, date
  }
  
  public enum DatePickerMode {
    case date, dateAndTime, time
  }
  
  public let leftLabel = UILabel()
  public let rightLabel = UILabel()
  private var rightLabelTextColor = UIColor.darkText
  
  private let separator = ColorLockedView()
  private let pickerContainer = UIView()
  private(set) var picker: UIView = UIPickerView()
  public private(set) var pickerType = PickerType.default
  
  private var expanded = false
  
  public var values = [String]()
  public var delegate: AUPickerCellDelegate?
  public var selectedRow: Int {
    get {
      return pickerType == .default ? (picker as! UIPickerView).selectedRow(inComponent: 0) : -1
    }
    set {
      if pickerType == .default {
        (picker as! UIPickerView).selectRow(newValue, inComponent: 0, animated: true)
        rightLabel.text = values[newValue]
      }
    }
  }
  
  private static let dateFormatter = DateFormatter()
  public var timeStyle = DateFormatter.Style.short {
    didSet {
      guard let _ = picker as? UIDatePicker else {
        return
      }
      AUPickerCell.dateFormatter.timeStyle = timeStyle
      rightLabel.text = AUPickerCell.dateFormatter.string(from: date)
    }
  }
  public var dateStyle = DateFormatter.Style.medium {
    didSet {
      guard let _ = picker as? UIDatePicker else {
        return
      }
      AUPickerCell.dateFormatter.dateStyle = dateStyle
      rightLabel.text = AUPickerCell.dateFormatter.string(from: date)
    }
  }
  public var timeZone: TimeZone? = nil {
    didSet {
      guard let picker = picker as? UIDatePicker else {
        return
      }
      picker.timeZone = timeZone
      AUPickerCell.dateFormatter.timeZone = timeZone
      rightLabel.text = AUPickerCell.dateFormatter.string(from: date)
    }
  }
  public var minimumDate: Date? = nil {
    didSet {
      guard let picker = picker as? UIDatePicker else {
        return
      }
      picker.minimumDate = minimumDate
    }
  }
  public var maximumDate: Date? = nil {
    didSet {
      guard let picker = picker as? UIDatePicker else {
        return
      }
      picker.maximumDate = maximumDate
    }
  }
  public var minuteInterval: Int = 1 {
    didSet {
      guard let picker = picker as? UIDatePicker else {
        return
      }
      picker.minuteInterval = minuteInterval
    }
  }
  public var datePickerMode: DatePickerMode = .dateAndTime {
    didSet {
      guard let picker = picker as? UIDatePicker else {
        return
      }
      switch datePickerMode {
      case .date: picker.datePickerMode = .date
      case .dateAndTime: picker.datePickerMode = .dateAndTime
      case .time: picker.datePickerMode = .time
      }
    }
  }
  public var date = Date() {
    didSet {
      guard let picker = picker as? UIDatePicker else {
        return
      }
      picker.setDate(date, animated: true)
      AUPickerCell.dateFormatter.dateStyle = dateStyle
      AUPickerCell.dateFormatter.timeStyle = timeStyle
      rightLabel.text = AUPickerCell.dateFormatter.string(from: date)
    }
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    pickerType = .default
    initialize()
  }
  
  public init(type: PickerType, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    pickerType = type
    initialize()
  }
  
  private func initialize() {
    
    if pickerType == .default {
      picker = UIPickerView()
      (picker as! UIPickerView).delegate = self
      (picker as! UIPickerView).dataSource = self
    } else {
      picker = UIDatePicker()
      (picker as! UIDatePicker).addTarget(self, action: #selector(AUPickerCell.datePicked), for: .valueChanged)
      let timeIntervalSinceReferenceDateWithoutSeconds = floor(date.timeIntervalSinceReferenceDate / 60.0) * 60.0
      date = Date(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDateWithoutSeconds)
    }
    
    clipsToBounds = true
    
    let views = ["leftLabel": leftLabel, "rightLabel": rightLabel, "pickerContainer": pickerContainer, "separator": separator, "picker": picker]
    for view in views.values {
      view.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(view)
    }
    
    pickerContainer.clipsToBounds = true
    pickerContainer.addSubview(picker)
    
    separator.lockedBackgroundColor = UIColor(white: 0, alpha: 0.1)
    pickerContainer.addSubview(separator)
    
    separator.leadingAnchor.constraint(equalTo: pickerContainer.leadingAnchor).isActive = true
    separator.trailingAnchor.constraint(equalTo: pickerContainer.trailingAnchor).isActive = true
    separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    separator.topAnchor.constraint(equalTo: pickerContainer.topAnchor).isActive = true
    
    leftLabel.heightAnchor.constraint(equalToConstant: 44.5).isActive = true
    leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    leftLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
    
    rightLabel.heightAnchor.constraint(equalToConstant: 44.5).isActive = true
    rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    rightLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
    
    pickerContainer.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
    pickerContainer.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
    pickerContainer.topAnchor.constraint(equalTo: leftLabel.bottomAnchor).isActive = true
    pickerContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1).isActive = true
    
    picker.leadingAnchor.constraint(equalTo: pickerContainer.leadingAnchor).isActive = true
    picker.trailingAnchor.constraint(equalTo: pickerContainer.trailingAnchor).isActive = true
    picker.topAnchor.constraint(equalTo: pickerContainer.topAnchor).isActive = true
  }
  
  public func pickerHeight() -> CGFloat {
    let expandedHeight = 44.0 + picker.bounds.height
    return expanded ? expandedHeight : 44.0
  }
  
  public func selectedInTableView(_ tableView: UITableView) {
    if !expanded {
      rightLabelTextColor = rightLabel.textColor
    }
    expanded = !expanded
    
    UIView.transition(with: rightLabel, duration: 0.25, options: .transitionCrossDissolve, animations: { [unowned self] in
      self.rightLabel.textColor = self.expanded ? self.tintColor : self.rightLabelTextColor
    })
    
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  @objc private func datePicked() {
    date = (picker as! UIDatePicker).date
    delegate?.auPickerCell(self, didPick: selectedRow, value: date)
  }
}

extension AUPickerCell: UIPickerViewDelegate {
  
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return values[row]
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    rightLabel.text = values[row]
    delegate?.auPickerCell(self, didPick: row, value: values[row])
  }
}

extension AUPickerCell: UIPickerViewDataSource {
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return values.count
  }
}

private class ColorLockedView: UIView {
  var lockedBackgroundColor:UIColor {
    set { super.backgroundColor = newValue }
    get { return super.backgroundColor! }
  }
  override var backgroundColor:UIColor? {
    set { }
    get { return super.backgroundColor }
  }
}
