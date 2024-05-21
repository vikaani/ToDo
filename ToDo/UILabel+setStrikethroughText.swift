//
//  UILabel+setStrikethroughText.swift
//  ToDo
//
//  Created by Vika on 21.05.2024.
//

import UIKit

extension UILabel {
    func setStrikethroughText(_ text: String) {
        let attributedString = NSAttributedString(string: text, attributes: [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ])
        self.attributedText = attributedString
    }
}
