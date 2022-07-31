
import UIKit

class HabitCollectionViewCell: UICollectionViewCell {


    weak var delegate: HabitCollectionViewCellDelegate?
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    private var index = 0
    
    private lazy var roundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 18
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private lazy var checkmarkImageView: UIImageView = {
        
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let imageView = UIImageView(image: UIImage(systemName: "checkmark", withConfiguration: configuration))
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    
    private lazy var habitNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = UIColor(red: 0.161, green: 0.427, blue: 1, alpha: 1)
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        return label
    }()
    
    private lazy var dateStringLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.682, green: 0.682, blue: 0.698, alpha: 1)
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        return label
    }()
    
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        setupView()
        setupGesture()
    }
    
    func setupCell(habit: Habit, index: Int) {

        self.index = index

        let color = habit.color
        habitNameLabel.text = habit.name
        habitNameLabel.textColor = color
        dateStringLabel.text = habit.dateString
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        
        
        if habit.isAlreadyTakenToday {
            roundImageView.backgroundColor = color
            roundImageView.layer.borderColor = color.cgColor
            checkmarkImageView.alpha = 1
            roundImageView.alpha = 1
            
        } else {
            roundImageView.layer.borderColor = color.cgColor
            roundImageView.backgroundColor = .white
            checkmarkImageView.alpha = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGesture() {
        tapGestureRecognizer.addTarget(self, action: #selector(tapRoundImage))
        roundImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupView() {
        [habitNameLabel, dateStringLabel, counterLabel, roundImageView].forEach { contentView.addSubview($0) }
        roundImageView.addSubview(checkmarkImageView)
        layout()
    }
    
    
    private func layout() {
        
        
        NSLayoutConstraint.activate([
            habitNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            habitNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            habitNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -103),
            dateStringLabel.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 4),
            dateStringLabel.leadingAnchor.constraint(equalTo: habitNameLabel.leadingAnchor),
            dateStringLabel.trailingAnchor.constraint(equalTo: habitNameLabel.trailingAnchor),
            
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            counterLabel.leadingAnchor.constraint(equalTo: habitNameLabel.leadingAnchor),
            counterLabel.trailingAnchor.constraint(equalTo: habitNameLabel.trailingAnchor),
            counterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -152),
            
            roundImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            roundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            roundImageView.heightAnchor.constraint(equalToConstant: 36),
            roundImageView.widthAnchor.constraint(equalToConstant: 36),
            
            checkmarkImageView.centerYAnchor.constraint(equalTo: roundImageView.centerYAnchor),
            checkmarkImageView.centerXAnchor.constraint(equalTo: roundImageView.centerXAnchor),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            
        ])
    }

    @objc private func tapRoundImage(_ gestureRecognizer: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.roundImageView.backgroundColor =  UIColor(cgColor: self.roundImageView.layer.borderColor!)
            self.checkmarkImageView.alpha = 1
            self.layoutIfNeeded()
            
        }   completion: { _ in
            let habit = HabitsStore.shared.habits[self.index]
            if !habit.isAlreadyTakenToday {
                HabitsStore.shared.track(habit)
                self.counterLabel.text = "Счётчик: \(habit.trackDates.count)"
                self.delegate?.didTapRoundImage()
            }
        }
    }
    
    
}

protocol HabitCollectionViewCellDelegate: AnyObject {
    
    func didTapRoundImage()
    
}




