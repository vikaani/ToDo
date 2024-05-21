//
//  CustomTableViewCell.swift
//  ToDo
//
//  Created by Vika on 18.05.2024.
//

import UIKit

final class TaskItemCell: UITableViewCell {
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .checkmarkEmpty
        imageView.tintColor = .lightGray
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var onTapImage: ((TaskItemCell) -> Void)?
    
    private let imageHeight: CGFloat = 23
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkmarkImageView.image = .checkmarkEmpty
        titleLabel.text = ""
    }
    
    private func setupViews() {
        selectionStyle = .none
        setupImageView()
        setupConstraints()
    }

    private func setupImageView() {
        checkmarkImageView.tintColor = .systemGreen
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCheckmarkImageView))
        checkmarkImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTapCheckmarkImageView() {
        onTapImage?(self)
    }
    
    private func setupConstraints() {
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(titleLabel)
 
        NSLayoutConstraint.activate([
            checkmarkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}


