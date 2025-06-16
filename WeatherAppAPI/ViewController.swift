import UIKit

class ViewController: UIViewController {

    private var forecasts: [Forecast] = []
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "contrastColor")
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = UIColor(named: "SoftGray")
        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor(named: "SoftGray")
        return label
    }()
    
    private lazy var minMaxTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = UIColor(named: "SoftGray")
        label.textAlignment = .left
        return label
    }()

    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Umidade:"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(named: "SoftGray")
        return label
    }()

    private lazy var humidityValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(named: "SoftGray")
        return label
    }()

    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vento:"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(named: "SoftGray")
        return label
    }()

    private lazy var windValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(named: "SoftGray")
        return label
    }()

    private lazy var humidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityLabel, humidityValueLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var windStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [windLabel, windValueLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var dailyForecastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.softGray
        label.text = "PROXIMOS DIAS"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var headerView2: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "contrastColor")
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var dailyForecastTabelView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
        return tableView
    }()
    
    private let service = Service()
    //private var city = City(lat: -8.0476, lon: -34.8770, name: "Recife")
   private var city = City(lat: -23.5489, lon: -46.6388, name: "São Paulo")
    //private var city = City(lat: -22.9068, lon: -43.1729, name: "Rio de Janeiro")
    private var weatherResponse: WeatherResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backGround
        setupView()
        fetchData()
        fetchData2()
    }

    private func fetchData() {
        service.fetchData(city: city) { [weak self] result in
            self?.weatherResponse = result
            DispatchQueue.main.async {
                self?.loadData()
            }
        }
    }
    
    private let weatherService = WeatherService()

    private func fetchData2() {
        weatherService.fetchWeather { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecasts):
                    self?.forecasts = forecasts
                    self?.loadData()
                    self?.dailyForecastTabelView.reloadData()
                case .failure(let error):
                    print("Erro ao buscar previsão: \(error.localizedDescription)")
                }
            }
        }
    }

    private func loadData() {
        cityLabel.text = city.name
        temperatureLabel.text = "\(Int(weatherResponse?.main.temp ?? 0))°C"
        let minTemp = Int(weatherResponse?.main.temp_min ?? 0)
        let maxTemp = Int(weatherResponse?.main.temp_max ?? 0)
        minMaxTempLabel.text = "Mín: \(minTemp)°C  Máx: \(maxTemp)°C"
        
        humidityValueLabel.text = "\(Int(weatherResponse?.main.humidity ?? 0))%"
        windValueLabel.text = "\(Int(weatherResponse?.wind.speed ?? 0)) km/h"
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
       
        view.addSubview(headerView)
        view.addSubview(headerView2)
        view.addSubview(dailyForecastLabel)
        view.addSubview(dailyForecastTabelView)
        
        headerView.addSubview(cityLabel)
        headerView.addSubview(temperatureLabel)
        headerView.addSubview(minMaxTempLabel)
        headerView.addSubview(humidityStackView)
        headerView.addSubview(windStackView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            headerView.heightAnchor.constraint(equalToConstant: 260),

            cityLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            cityLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 35),
            cityLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -35),
            cityLabel.heightAnchor.constraint(equalToConstant: 25),

            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            temperatureLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 105),
          
            
            minMaxTempLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 22),
            minMaxTempLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 70),
        

            humidityStackView.topAnchor.constraint(equalTo: minMaxTempLabel.bottomAnchor, constant: 50),
            humidityStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 102),

            windStackView.topAnchor.constraint(equalTo: minMaxTempLabel.bottomAnchor, constant: 20),
            windStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 102),
            
        ])
        
        NSLayoutConstraint.activate([
            
            headerView2.topAnchor.constraint(equalTo: dailyForecastLabel.bottomAnchor, constant: 10),
            headerView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView2.heightAnchor.constraint(equalToConstant: 500),
            
            dailyForecastLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            dailyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            dailyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            
            dailyForecastTabelView.topAnchor.constraint(equalTo: dailyForecastLabel.bottomAnchor, constant: 18),
            dailyForecastTabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyForecastTabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyForecastTabelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier, for: indexPath) as? DailyForecastTableViewCell else {
            return UITableViewCell()
        }
        
        let forecast = forecasts[indexPath.row]
        cell.configure(with: forecast)
        return cell
    }
}


