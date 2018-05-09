//
//  ActionCollectionViewCell.swift
//  Alerta
//
//  Created by Anthony Latsis on 5/30/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

enum ActionState {

    case normal

    case highlighted
}

protocol ActionCell: class {

    var state: ActionState { get set }
}

class ActionCollectionViewCell: UICollectionViewCell, ActionCell {

    var state: ActionState = .normal //{ didSet { update() }}

    let colorView = UIView()

    internal let textLabel = UILabel()

    override init(frame: CGRect) {

        super.init(frame: frame)

        setUI()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActionCollectionViewCell: View {

    func setUI() {

        textLabel.textAlignment = .center

        self.contentView.insert(subviews: [colorView, textLabel], at: 10)
    }

    func setConstraints() {

        self.colorView.anchor(to: self.contentView)
        self.textLabel.anchor(to: self.contentView)
    }
}
