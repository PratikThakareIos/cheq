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

struct CSegmentedControlViewModel {
    let title: String
    let items: [CSegmentedControlItem]
    let selectedIndex: Int?
}

class CSegmentedControl: XibControlView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var stackView: UIStackView!

    // MARK: - Public properties
    @IBInspectable var isOptionalSelection: Bool = true
    
    var selectedItemIndex: Int? {
        didSet {
            if let selectedItemIndex = selectedItemIndex {
                buttons.forEach { button in
                    button.isSelected = button.tag == selectedItemIndex
                }
            } else {
                buttons.forEach { button in
                    button.isSelected = false
                }
            }
        }
    }
    var selectedItem: CSegmentedControlItem? {
        get {
            items[selectedItemIndex ?? 0]
        }
    }

    // MARK: - Private properties
    private var items: [CSegmentedControlItem] = []
    private var buttons: [UIButton] = []
    
    // MARK: - Public functions
    func configure(with viewModel: CSegmentedControlViewModel) {
        self.titleLabel.text = viewModel.title
        self.items = viewModel.items
        
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
        self.selectedItemIndex = viewModel.selectedIndex
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
            selectedItemIndex = nil
        } else {
            selectedItemIndex = sender.tag
        }
    }
}
