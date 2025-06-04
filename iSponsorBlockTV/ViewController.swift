import UIKit
import Network

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let serverAddressTextField = UITextField()
    private let connectButton = UIButton(type: .system)
    
    private let devicesHeaderLabel = UILabel()
    private let devicesStackView = UIStackView()
    
    private let settingsHeaderLabel = UILabel()
    private let sponsorBlockEnabledSwitch = UISwitch()
    private let adBlockEnabledSwitch = UISwitch()
    private let autoSkipSwitch = UISwitch()
    
    private let statisticsHeaderLabel = UILabel()
    private let skippedCountLabel = UILabel()
    private let savedTimeLabel = UILabel()
    
    // MARK: - Properties
    private var isConnected = false
    private var serverAddress = "http://192.168.1.100:8000"
    private var connectedDevices: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadSettings()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "iSponsorBlockTV"
        
        // Scroll view setup
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Title
        titleLabel.text = "iSponsorBlockTV Client"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Status
        statusLabel.text = "Отключено от сервера"
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .systemRed
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusLabel)
        
        // Server address input
        serverAddressTextField.placeholder = "Адрес сервера (http://192.168.1.100:8000)"
        serverAddressTextField.text = serverAddress
        serverAddressTextField.borderStyle = .roundedRect
        serverAddressTextField.autocapitalizationType = .none
        serverAddressTextField.keyboardType = .URL
        serverAddressTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(serverAddressTextField)
        
        // Connect button
        connectButton.setTitle("Подключиться", for: .normal)
        connectButton.backgroundColor = .systemBlue
        connectButton.setTitleColor(.white, for: .normal)
        connectButton.layer.cornerRadius = 8
        connectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(connectButton)
        
        // Devices section
        devicesHeaderLabel.text = "Подключенные устройства"
        devicesHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20)
        devicesHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(devicesHeaderLabel)
        
        devicesStackView.axis = .vertical
        devicesStackView.spacing = 8
        devicesStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(devicesStackView)
        
        // Settings section
        settingsHeaderLabel.text = "Настройки"
        settingsHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20)
        settingsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(settingsHeaderLabel)
        
        // SponsorBlock setting
        let sponsorBlockStack = createSettingRow(
            title: "Блокировка спонсоров",
            subtitle: "Автоматически пропускать спонсорские сегменты",
            switch: sponsorBlockEnabledSwitch
        )
        contentView.addSubview(sponsorBlockStack)
        
        // Ad block setting
        let adBlockStack = createSettingRow(
            title: "Блокировка рекламы",
            subtitle: "Пропускать рекламные ролики YouTube",
            switch: adBlockEnabledSwitch
        )
        contentView.addSubview(adBlockStack)
        
        // Auto skip setting
        let autoSkipStack = createSettingRow(
            title: "Автопропуск",
            subtitle: "Автоматически пропускать без подтверждения",
            switch: autoSkipSwitch
        )
        contentView.addSubview(autoSkipStack)
        
        // Statistics section
        statisticsHeaderLabel.text = "Статистика"
        statisticsHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20)
        statisticsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statisticsHeaderLabel)
        
        skippedCountLabel.text = "Пропущено сегментов: 0"
        skippedCountLabel.font = UIFont.systemFont(ofSize: 16)
        skippedCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(skippedCountLabel)
        
        savedTimeLabel.text = "Сэкономлено времени: 0 мин"
        savedTimeLabel.font = UIFont.systemFont(ofSize: 16)
        savedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(savedTimeLabel)
        
        // Add switch targets
        sponsorBlockEnabledSwitch.addTarget(self, action: #selector(settingChanged), for: .valueChanged)
        adBlockEnabledSwitch.addTarget(self, action: #selector(settingChanged), for: .valueChanged)
        autoSkipSwitch.addTarget(self, action: #selector(settingChanged), for: .valueChanged)
        
        updateDevicesList()
    }
    
    private func createSettingRow(title: String, subtitle: String, switch: UISwitch) -> UIStackView {
        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        let labelsStack = UIStackView()
        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.numberOfLines = 0
        
        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitleLabel)
        
        switch.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.addArrangedSubview(labelsStack)
        mainStack.addArrangedSubview(switch)
        
        return mainStack
    }
    
    private func setupConstraints() {
        let sponsorBlockStack = contentView.subviews.first { $0 is UIStackView && $0 != devicesStackView }!
        let adBlockStack = contentView.subviews.dropFirst().first { $0 is UIStackView && $0 != devicesStackView && $0 != sponsorBlockStack }!
        let autoSkipStack = contentView.subviews.dropFirst(2).first { $0 is UIStackView && $0 != devicesStackView && $0 != sponsorBlockStack && $0 != adBlockStack }!
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Status
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Server address
            serverAddressTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            serverAddressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            serverAddressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            serverAddressTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Connect button
            connectButton.topAnchor.constraint(equalTo: serverAddressTextField.bottomAnchor, constant: 16),
            connectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            connectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            connectButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Devices header
            devicesHeaderLabel.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 30),
            devicesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            devicesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Devices stack
            devicesStackView.topAnchor.constraint(equalTo: devicesHeaderLabel.bottomAnchor, constant: 16),
            devicesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            devicesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Settings header
            settingsHeaderLabel.topAnchor.constraint(equalTo: devicesStackView.bottomAnchor, constant: 30),
            settingsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            settingsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Settings stacks
            sponsorBlockStack.topAnchor.constraint(equalTo: settingsHeaderLabel.bottomAnchor, constant: 16),
            sponsorBlockStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sponsorBlockStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            adBlockStack.topAnchor.constraint(equalTo: sponsorBlockStack.bottomAnchor, constant: 16),
            adBlockStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            adBlockStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            autoSkipStack.topAnchor.constraint(equalTo: adBlockStack.bottomAnchor, constant: 16),
            autoSkipStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            autoSkipStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Statistics header
            statisticsHeaderLabel.topAnchor.constraint(equalTo: autoSkipStack.bottomAnchor, constant: 30),
            statisticsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statisticsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Statistics labels
            skippedCountLabel.topAnchor.constraint(equalTo: statisticsHeaderLabel.bottomAnchor, constant: 16),
            skippedCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            skippedCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            savedTimeLabel.topAnchor.constraint(equalTo: skippedCountLabel.bottomAnchor, constant: 8),
            savedTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            savedTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            savedTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Actions
    @objc private func connectButtonTapped() {
        if isConnected {
            disconnect()
        } else {
            connect()
        }
    }
    
    @objc private func settingChanged() {
        saveSettings()
        // Here you would send settings to the server
        if isConnected {
            sendSettingsToServer()
        }
    }
    
    // MARK: - Connection Logic
    private func connect() {
        guard let address = serverAddressTextField.text, !address.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите адрес сервера")
            return
        }
        
        serverAddress = address
        
        // Simulate connection (in real app, make HTTP request to server)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isConnected = true
            self.updateConnectionStatus()
            self.simulateDeviceData()
        }
    }
    
    private func disconnect() {
        isConnected = false
        updateConnectionStatus()
        connectedDevices.removeAll()
        updateDevicesList()
    }
    
    private func updateConnectionStatus() {
        if isConnected {
            statusLabel.text = "Подключено к серверу"
            statusLabel.textColor = .systemGreen
            connectButton.setTitle("Отключиться", for: .normal)
            connectButton.backgroundColor = .systemRed
        } else {
            statusLabel.text = "Отключено от сервера"
            statusLabel.textColor = .systemRed
            connectButton.setTitle("Подключиться", for: .normal)
            connectButton.backgroundColor = .systemBlue
        }
    }
    
    private func simulateDeviceData() {
        // Simulate connected devices
        connectedDevices = ["Apple TV (Гостиная)", "Samsung TV (Спальня)", "Chromecast (Кухня)"]
        updateDevicesList()
        
        // Simulate statistics
        skippedCountLabel.text = "Пропущено сегментов: 127"
        savedTimeLabel.text = "Сэкономлено времени: 42 мин"
    }
    
    private func updateDevicesList() {
        // Clear existing device views
        devicesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if connectedDevices.isEmpty {
            let noDevicesLabel = UILabel()
            noDevicesLabel.text = "Нет подключенных устройств"
            noDevicesLabel.textColor = .systemGray
            noDevicesLabel.font = UIFont.systemFont(ofSize: 16)
            devicesStackView.addArrangedSubview(noDevicesLabel)
        } else {
            for device in connectedDevices {
                let deviceView = createDeviceView(name: device)
                devicesStackView.addArrangedSubview(deviceView)
            }
        }
    }
    
    private func createDeviceView(name: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = "📺"
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let statusIndicator = UIView()
        statusIndicator.backgroundColor = .systemGreen
        statusIndicator.layer.cornerRadius = 6
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(iconLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(UIView()) // Spacer
        stackView.addArrangedSubview(statusIndicator)
        
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            statusIndicator.widthAnchor.constraint(equalToConstant: 12),
            statusIndicator.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        return containerView
    }
    
    // MARK: - Settings
    private func loadSettings() {
        let defaults = UserDefaults.standard
        sponsorBlockEnabledSwitch.isOn = defaults.bool(forKey: "sponsorBlockEnabled")
        adBlockEnabledSwitch.isOn = defaults.bool(forKey: "adBlockEnabled")
        autoSkipSwitch.isOn = defaults.bool(forKey: "autoSkipEnabled")
        serverAddress = defaults.string(forKey: "serverAddress") ?? "http://192.168.1.100:8000"
        serverAddressTextField.text = serverAddress
    }
    
    private func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(sponsorBlockEnabledSwitch.isOn, forKey: "sponsorBlockEnabled")
        defaults.set(adBlockEnabledSwitch.isOn, forKey: "adBlockEnabled")
        defaults.set(autoSkipSwitch.isOn, forKey: "autoSkipEnabled")
        defaults.set(serverAddress, forKey: "serverAddress")
    }
    
    private func sendSettingsToServer() {
        // Here you would make HTTP requests to update server settings
        print("Отправка настроек на сервер...")
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 