//
//  CSegmentedControl.swift
//  Cheq
//
//  Created by Alexey on 11.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

protocol CSegmentedControlItem {
    var title: String { get }
    var ref: Any? { get }
}

class CSegmentedControl: XibControlView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var stackView: UIStackView!

    // MARK: - Public properties
    @IBInspectable var isOptionalSelection: Bool = true
    
    var selectedItemIndex: Int?
    var selectedItem: CSegmentedControlItem? {
        get {
            items[selectedItemIndex ?? 0]
        }
    }

    // MARK: - Private properties
    private var items: [CSegmentedControlItem] = []
    private var buttons: [UIButton] = []
    
    // MARK: - Public functions
    func configure(with config: (String, [CSegmentedControlItem])) {
        self.titleLabel.text = config.0
        self.items = config.1
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        buttons = items.map(button(for:))
        buttons
            .enumerated()
            .forEach { idx, button in
                button.tag = idx
                stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Buttons logic
    
    private func button(for item: CSegmentedControlItem) -> UIButton {
        let b = CRadioButton()
        b.setTitle(item.title)
        b.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        return b
    }
    
    @objc func onButtonPressed(_ sender: UIButton) {
        defer {
            sendActions(for: .valueChanged)
        }
        
        if self.isOptionalSelection && sender.isSelected {
            sender.isSelected = false
            selectedItemIndex = nil
        } else {
            buttons.forEach { button in
                button.isSelected = sender == button
            }
            selectedItemIndex = sender.tag
        }
    }
}
