

import UIKit

class HabitDetailsTableViewCell: UITableViewCell {
    
    private lazy var contentMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        label.numberOfLines = 2
        return label
    }()
    
    
    private lazy var checkmarkImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let imageView = UIImageView(image: UIImage(systemName: "checkmark", withConfiguration: configuration))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCell(habit: Habit, index: Int) {
        
        let store = HabitsStore.shared
        let date = store.dates.reversed()[index]
        dateLabel.text = store.trackDateString(forIndex: index)
        if store.habit(habit, isTrackedIn: date) {
            checkmarkImageView.alpha = 1
        }
    }
    
    private func layout() {
        
        [contentMainView, dateLabel, checkmarkImageView].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            contentMainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentMainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentMainView.heightAnchor.constraint(equalToConstant: 44),
            
            dateLabel.centerYAnchor.constraint(equalTo: contentMainView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 16),
            
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentMainView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentMainView.trailingAnchor, constant: -14),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20),
            
        ])
        
    }
    
}
