//
//  ActionCollectionView.swift
//  Alerta
//
//  Created by Anthony Latsis on 4/30/17.
//  Copyright © 2017 Anthony Latsis. All rights reserved.
//

import UIKit

fileprivate extension IndexPath {
    
    func next() -> IndexPath {
        return IndexPath.init(row: self.row + 1, section: self.section)
    }
    
    func previous() -> IndexPath {
        return IndexPath.init(row: self.row - 1, section: self.section)
    }
    
    func step(over: Int) -> IndexPath {
        return IndexPath.init(row: self.row + over, section: self.section)
    }
}

class ActionCollection: UICollectionView {
    
    enum ReuseID: String {
        
        case separator
        case cell
    }
    
    fileprivate let topView = UIView()
    
    fileprivate let bottomView = UIView()
    
    fileprivate var indexPathForHighlightedCell: IndexPath?
    
    //@available(iOS 10.0, *)
    //fileprivate lazy var generator: UISelectionFeedbackGenerator? = nil
    
    fileprivate var generator: NSObject?
    
    fileprivate var timer: Timer?
    
    init() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        setup()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActionCollection {
    
    func setup() {
        
        self.register(ActionCollectionViewCell.self, forCellWithReuseIdentifier: ReuseID.cell.rawValue)
        self.register(SeparatorCell.self, forCellWithReuseIdentifier: ReuseID.separator.rawValue)

        self.backgroundColor = .clear
        self.alwaysBounceVertical = true
        self.allowsMultipleSelection = false

        if #available(iOS 10.0, *) {
            self.generator = UISelectionFeedbackGenerator.init()
            (self.generator as! UISelectionFeedbackGenerator).prepare()
        }
    }
}

extension ActionCollection {
    
    override func layoutSubviews() {
        
        topView.frame = CGRect(x: 0, y: -UIScreen.main.bounds.height, width: self.bounds.width, height: UIScreen.main.bounds.height)
        
        bottomView.frame = CGRect(x: 0, y: self.contentSize.height, width: self.bounds.width, height: UIScreen.main.bounds.height)
        
        topView.backgroundColor = UIColor.white.withAlphaComponent(0.5)//layout.alpha(for: .normal))
        bottomView.backgroundColor = UIColor.white.withAlphaComponent(0.5)//layout.alpha(for: .normal))
        
        super.layoutSubviews()
    }
}

//extension ActionCollectionView {
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
////        if #available(iOS 10.0, *) {
////            timer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true, block: {
////                _ in
////                print("Rr")
////                (self.generator as! UISelectionFeedbackGenerator).prepare()
////            })
////        }
//        guard touches.count == 1 else {
//            return
//        }
//        if #available(iOS 10.0, *) {
//            
//            (self.generator as! UISelectionFeedbackGenerator).prepare()
//        }
//        let location = touches[touches.startIndex].location(in: self)
//        
//        if let indexPath = self.indexPathForRow(at: location) {
//            if indexPath.row % 2 == 0 {
//                update(at: indexPath, to: .highlighted)
//            
//                self.indexPathForHighlightedCell = indexPath
//            }
//        }
//        super.touchesBegan(touches, with: event)
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        //DispatchQueue.main.async {
//            if #available(iOS 10.0, *) {
//                (self.generator as! UISelectionFeedbackGenerator).prepare()
//            }
//        //}
//        guard touches.count == 1 else {
//            return
//        }
//        let location = touches[touches.startIndex].location(in: self)
//        
//        if let indexPath = self.indexPathForRow(at: location) {
//            if let current = self.indexPathForHighlightedCell {
//                if indexPath != current && indexPath.row % 2 == 0 {
//                    
//                    //DispatchQueue.main.async {
//                        if #available(iOS 10.0, *) {
//                            (self.generator as! UISelectionFeedbackGenerator).selectionChanged()
//                            (self.generator as! UISelectionFeedbackGenerator).prepare()
//                        }
//                    //}
//                    
//                    update(at: current, to: .normal)
//                    update(at: indexPath, to: .highlighted)
//                    
//                    self.indexPathForHighlightedCell = indexPath
//                }
//            } else if indexPath.row % 2 == 0 {
//                
//                //DispatchQueue.main.async {
//                    if #available(iOS 10.0, *) {
//                        (self.generator as! UISelectionFeedbackGenerator).selectionChanged()
//                        (self.generator as! UISelectionFeedbackGenerator).prepare()
//                    }
//                //}
//
//                update(at: indexPath, to: .highlighted)
//                
//                self.indexPathForHighlightedCell = indexPath
//            }
//        } else {
//            if let current = self.indexPathForHighlightedCell {
//                update(at: current, to: .normal)
//                
//                self.indexPathForHighlightedCell = nil
//            }
//        }
//        super.touchesMoved(touches, with: event)
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        guard touches.count == 1 else {
//            return
//        }
//        if let indexPath = self.indexPathForHighlightedCell {
//            update(at: indexPath, to: .normal)
//            
//            self.indexPathForHighlightedCell = nil
//        }
//        timer?.invalidate()
//        timer = nil
//        
//        super.touchesEnded(touches, with: event)
//    }
//}
//
//extension ActionCollectionView {
//    
//    func update(at indexPath: IndexPath, to state: ActionState) {
//        
//        let topSeparator = self.cellForRow(at: indexPath.previous()) as? ActionCell
//        let action = self.cellForRow(at: indexPath) as? ActionCell
//        let bottomSeparator = self.cellForRow(at: indexPath.next()) as? ActionCell
//        
//        topSeparator?.state = state
//        action?.state = state
//        bottomSeparator?.state = state
//    }
//}
