

import UIKit

class HabitsViewController: UIViewController {

    let store = HabitsStore.shared


    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        collectionView.clipsToBounds = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()


    private func setupCollections() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func layout(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupCollections()
        view.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addHabit))

        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)

        self.navigationItem.title = "Сегодня"

        self.navigationController?.navigationBar.prefersLargeTitles = true

    }



    @objc func addHabit() {
        let habitViewController = HabitViewController(index: 0, isNewHabit: true)
        let habitViewControllerNavigationController = UINavigationController(rootViewController: habitViewController)

        habitViewControllerNavigationController.modalPresentationStyle = .fullScreen
        self.present(habitViewControllerNavigationController, animated: true)
    }
}



// MARK: - UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        } else {
            return store.habits.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
            cell.setupProgressCell()


            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as! HabitCollectionViewCell
            cell.setupCell(habit: store.habits[indexPath.item], index: indexPath.item)
            cell.delegate = self
            return cell
        }

    }
}



// MARK: - UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {

    private var sideInset: CGFloat { return 16 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width - sideInset * 2

        if indexPath.section == 0 {
            return CGSize(width: width, height: 60)

        } else {
            return CGSize(width: width, height: 130)
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if section == 0 {
            return  UIEdgeInsets(top: 22, left: 0, bottom: 6, right: 0)
        } else {
            return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section != 0 {
            let habitDetailsViewController = HabitDetailsViewController(index: indexPath.item)
            self.navigationController?.pushViewController(habitDetailsViewController, animated: true)

        }

    }

}


extension HabitsViewController :  HabitCollectionViewCellDelegate {

    func didTapRoundImage() {
        collectionView.reloadData()
    }

}




