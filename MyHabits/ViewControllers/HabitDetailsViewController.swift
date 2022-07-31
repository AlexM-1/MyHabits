

import UIKit

class HabitDetailsViewController: UIViewController {
    
    private var index = 0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HabitDetailsTableViewCell.self, forCellReuseIdentifier: HabitDetailsTableViewCell.identifier)
        return tableView
        
    }()
    
    
    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        self.index = index
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIBarButtonItem.appearance().tintColor = UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(editHabit))
        
        
        self.navigationItem.leftBarButtonItem?.title = "Сегодня"
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard index < HabitsStore.shared.habits.count  else { return }
        self.navigationItem.title = HabitsStore.shared.habits[index].name
        
    }
    
    private func setupView() {
        view.backgroundColor = .lightGray
        view.addSubview(tableView)
        createViewConstraint()
    }
    
    private func createViewConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    @objc func editHabit() {
        let habitViewController = HabitViewController(index: index, isNewHabit: false)
        let habitViewControllerNavigationController = UINavigationController(rootViewController: habitViewController)
        
        
        habitViewController.showHabitDeleteButton()
        habitViewController.setup()
        
        habitViewController.closure = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        
        habitViewControllerNavigationController.modalPresentationStyle = .fullScreen
        self.present(habitViewControllerNavigationController, animated: true)
    }
}




extension HabitDetailsViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                   section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitDetailsTableViewCell.identifier, for: indexPath) as! HabitDetailsTableViewCell
        
        
        let store = HabitsStore.shared
        let habit = store.habits[index]
        cell.setupCell(habit: habit, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension HabitDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 { return 0 }
        return UITableView.automaticDimension
    }
    
}






















