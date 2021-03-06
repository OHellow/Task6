//
//  NoteCell.swift
//  TODO
//
//  Created by Satsishur on 15.12.2020.
//

import UIKit

protocol ExpandedCellDelegate:NSObjectProtocol{
    func topButtonTouched(in cell: NoteCell)
}

class NoteCell: UICollectionViewCell {
    static let identidier = "cell"
        
    var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Название"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 0.078, green: 0.08, blue: 0.087, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var expandButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.setImage(UIImage(systemName: "pip.swap"), for: .normal)
        return button
    }()
    
    var cellBackgroundColor: UIColor = NoteColors.blue {
        didSet{
            contentView.backgroundColor = cellBackgroundColor
        }
    }
    
    weak var delegate:ExpandedCellDelegate?
    public var indexPath:IndexPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 5
        //layoutIfNeeded()
    }
    
    func setupLayout() {
        contentView.backgroundColor = cellBackgroundColor
        contentView.addSubview(titleLabel)
        let margin = contentView.layoutMarginsGuide
        titleLabel.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        
//        contentView.addSubview(expandButton)
//        expandButton.bringSubviewToFront(contentView)
//        expandButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
//        expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
//        expandButton.isUserInteractionEnabled = true
//        contentView.isUserInteractionEnabled = true
//        expandButton.addTarget(self, action: #selector(expandButtonTouched(_:)), for: .touchUpInside)
    }
    
    @objc func expandButtonTouched(_ sender: UIButton) {
        print("expand button touched")
        if let delegate = self.delegate{
            delegate.topButtonTouched(in: self)
        }
    }
}
