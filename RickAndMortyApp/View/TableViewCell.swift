//
//  TableViewCell.swift
//  RickAndMortyApp
//
//  Created by Александр on 26.02.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    var cellModel : RickAndMortyModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aliveStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "alive"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let circle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        return view
    }()
    
    let lastLocationLabel : UILabel = {
        let label = UILabel()
        label.text = "Last known location:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let planetLabel : UILabel = {
        let label = UILabel()
        label.text = "Earth"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let myImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(myImageView)
        myImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        myImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        myImageView.widthAnchor.constraint(equalTo: myImageView.heightAnchor).isActive = true
        
        addSubview(stackView)
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 6).isActive = true
    
        backCircleView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        backCircleView.addSubview(circle)
        backCircleView.addSubview(aliveStatusLabel)
        
        circle.leadingAnchor.constraint(equalTo: backCircleView.leadingAnchor).isActive = true
        circle.topAnchor.constraint(equalTo: backCircleView.topAnchor, constant: 8).isActive = true
        circle.bottomAnchor.constraint(equalTo: backCircleView.bottomAnchor, constant: -8).isActive = true
        circle.widthAnchor.constraint(equalTo: circle.heightAnchor).isActive = true
        aliveStatusLabel.centerYAnchor.constraint(equalTo: backCircleView.centerYAnchor).isActive = true
        aliveStatusLabel.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 8).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(backCircleView)
        stackView.addArrangedSubview(lastLocationLabel)
        stackView.addArrangedSubview(planetLabel)

    }
    
    func configureCell() {
        guard let model = cellModel else {return}
        nameLabel.text = model.name
        if (model.status == "Alive") {
            circle.backgroundColor = .green
        } else {
            circle.backgroundColor = .red
        }
        aliveStatusLabel.text = model.status + " - " + model.species
        planetLabel.text = model.location.name
        NetworlManager.fetchImage(url: model.image) { data in
            guard let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                self.myImageView.image = image
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
