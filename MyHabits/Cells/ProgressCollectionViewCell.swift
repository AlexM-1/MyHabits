

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {


    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Всё получится!"
        label.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        return label
    }()
    
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        label.font = UIFont(name: "SFProText-Semibold", size: 13)
        return label
    }()
    

    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0, animated: false)
        progressView.progressViewStyle = .default
        progressView.progressTintColor = UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)
        progressView.layer.cornerRadius = 3.5
        progressView.layer.masksToBounds = true
        return progressView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.backgroundColor = .white
        layout()
    }
    
    

    func setupProgressCell() {
        let todayProgress = HabitsStore.shared.todayProgress;
        progressView.setProgress(todayProgress, animated: false)
        percentLabel.text = "\(Int(todayProgress * 100))%"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layout() {
        
        [label, percentLabel, progressView].forEach { contentView.addSubview ($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            percentLabel.topAnchor.constraint(equalTo: label.topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            progressView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressView.heightAnchor.constraint(equalToConstant: 7),
        ])
    }
}
