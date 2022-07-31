

import UIKit

class HabitViewController: UIViewController {
    
    var closure: (() -> Void)?
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    private var index = 0
    private var isNewHabit = true
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "НАЗВАНИЕ"
        label.textColor = .black
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        return label
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ"
        label.textColor = .black
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        return label
    }()
    
    
    private lazy var timeLabelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВРЕМЯ"
        label.textColor = .black
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        return label
    }()
    
    
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Каждый день в "
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        return label
    }()
    
    
    private lazy var pickerTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        return label
    }()
    
    
    
    private lazy var habitNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor(red: 0.161, green: 0.427, blue: 1, alpha: 1)
        textField.backgroundColor = .white
        textField.font = UIFont(name: "SFProText-Semibold", size: 17)
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.delegate = self
        return textField
    }()
    
    
    private lazy var habitColorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 1, green: 0.624, blue: 0.31, alpha: 1)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: "11:00") {
            datePicker.date = date
        }
        
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.backgroundColor = .white
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.tintColor = UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)
        datePicker.addTarget(self, action: #selector(datePickerChange), for: .valueChanged)
        return datePicker
    }()
    
    
    
    
    private lazy var habitDeleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 0.231, blue: 0.188, alpha: 1), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(habitDeleteButtonTap), for: .touchUpInside)
        return button
    }()
    
    
    init(index: Int, isNewHabit: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.index = index
        self.isNewHabit = isNewHabit
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationItem.title = "Создать"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveHabit))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(canсelSaveHabit))
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)
        
        
        showHabitDeleteButton()
        setup()
        setupView()
        setupGesture()
        layout()
        
    }
    
    private func setupGesture() {
        tapGestureRecognizer.addTarget(self, action: #selector(habitColorTap))
        habitColorImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func showHabitDeleteButton() {
        habitDeleteButton.alpha = isNewHabit ? 0 : 1
        
    }
    
    func setup() {
        
        if !isNewHabit {
            let store = HabitsStore.shared
            let habit = store.habits[index]
            
            habitNameTextField.text = habit.name
            datePicker.date = habit.date
            habitColorImageView.backgroundColor = habit.color
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        pickerTimeLabel.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    
    private func setupView() {
        
        [nameLabel, colorLabel, timeLabelTitle, habitNameTextField, habitColorImageView, timeLabel, datePicker, pickerTimeLabel, habitDeleteButton].forEach { view.addSubview($0) }
        
    }
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            habitNameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            habitNameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            habitNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -65),
            
            colorLabel.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 15),
            colorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            habitColorImageView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            habitColorImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            habitColorImageView.heightAnchor.constraint(equalToConstant: 30),
            habitColorImageView.widthAnchor.constraint(equalToConstant: 30),
            
            timeLabelTitle.topAnchor.constraint(equalTo: habitColorImageView.bottomAnchor, constant: 15),
            timeLabelTitle.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: timeLabelTitle.bottomAnchor, constant: 7),
            timeLabel.leadingAnchor.constraint(equalTo: timeLabelTitle.leadingAnchor),
            
            
            
            pickerTimeLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            pickerTimeLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            
            
            
            datePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            habitDeleteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            habitDeleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            
        ])
    }
    
    @objc func saveHabit() {
        
        let name = habitNameTextField.text ?? ""
        let date = datePicker.date
        let color = habitColorImageView.backgroundColor ?? .white
        
        let habit = Habit(name: name,
                          date: date,
                          color: color)
        
        let store = HabitsStore.shared
        
        
        if isNewHabit {
            store.habits.append(habit)
        } else {
            let habit = store.habits[index]
            habit.name = name
            habit.date = date
            habit.color = color
            store.habits[index] = habit
        }
        
        dismiss(animated: true)
        
    }
    
    @objc func canсelSaveHabit() {
        dismiss(animated: true)
    }
    
    @objc func datePickerChange() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        pickerTimeLabel.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    
    @objc private func habitColorTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.selectedColor = habitColorImageView.backgroundColor ?? UIColor.black
        present(colorPickerVC, animated: true)
        
    }
    
    
    
    @objc func habitDeleteButtonTap() {
        
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \"\(HabitsStore.shared.habits[index].name)\"?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [self] _ in
            
            
            let store = HabitsStore.shared
            store.habits.remove(at: self.index)
            self.dismiss(animated: false)
            self.closure?()
            
            
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}


extension HabitViewController : UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        habitColorImageView.backgroundColor = viewController.selectedColor
    }
    
}

extension HabitViewController : UITextFieldDelegate {
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}



