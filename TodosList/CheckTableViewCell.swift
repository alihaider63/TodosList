//
//  CheckTableViewCell.swift
//  TodosList
//
//  Created by Ali Haider on 16/10/2024.
//

import UIKit

protocol CheckTableViewCellDelegate: AnyObject {
    func checkTableViewCell(_ cell: CheckTableViewCell, didChangeCheckedState checked: Bool)
}

class CheckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var checkbox: Checkbox!
    
    weak var delegate: CheckTableViewCellDelegate?
    
    @IBAction func onValueChanged(_ sender: Checkbox) {
        updateChecked()
        delegate?.checkTableViewCell(self, didChangeCheckedState: checkbox.checked)
    }
    
    func set(title: String, checked: Bool) {
        label?.text = title
        checkbox?.checked = checked
        updateChecked()
    }
    
    func set(checked: Bool) {
        checkbox?.checked = checked
        updateChecked()
    }
    
    private func updateChecked() {
        let attributedString = NSMutableAttributedString(string: label.text!)
        
        if checkbox.checked {
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
        }
        
        label.attributedText = attributedString
    }
}
