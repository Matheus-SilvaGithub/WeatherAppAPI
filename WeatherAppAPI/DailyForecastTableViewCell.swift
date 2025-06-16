import UIKit

class DailyForecastTableViewCell: UITableViewCell {
    
    static let identifier = "DailyForecastTableViewCell"
  
    private lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "SoftGray")
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "SoftGray")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "SoftGray")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weekDayLabel, minTemperatureLabel, maxTemperatureLabel])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }

    func configure(with forecast: Forecast) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "pt_BR")
        
        if let date = formatter.date(from: forecast.dtTxt) {
            formatter.dateFormat = "EEEE - HH:mm" 
            weekDayLabel.text = formatter.string(from: date).capitalized
        } else {
            weekDayLabel.text = "-"
        }
        
        minTemperatureLabel.text = "Min \(Int(forecast.main.tempMin))°C"
        maxTemperatureLabel.text = "Max \(Int(forecast.main.tempMax))°C"
    }
}
