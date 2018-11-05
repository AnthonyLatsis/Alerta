//
//  SeparatorCell.swift
//  Alerta
//
//  Created by Anthony Latsis on 4/17/18.
//  Copyright © 2018 Anthony Latsis. All rights reserved.
//

class SeparatorCell: UICollectionViewCell {

    fileprivate let effectView = UIVisualEffectView()

    override init(frame: CGRect) {

        super.init(frame: frame)

        effectView.effect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .extraLight))
        effectView.contentView.backgroundColor = .white

        contentView.insert(subviews: [effectView])

        effectView.anchor(to: self.contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
