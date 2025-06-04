import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let session = URLSession.shared
    private var baseURL: String = ""
    
    // MARK: - Connection
    func setBaseURL(_ url: String) {
        baseURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        if !baseURL.hasPrefix("http://") && !baseURL.hasPrefix("https://") {
            baseURL = "http://" + baseURL
        }
        if baseURL.hasSuffix("/") {
            baseURL = String(baseURL.dropLast())
        }
    }
    
    func checkConnection(completion: @escaping (Bool) -> Void) {
        guard !baseURL.isEmpty else {
            completion(false)
            return
        }
        
        guard let url = URL(string: "\(baseURL)/status") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5.0
        
        session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 || httpResponse.statusCode == 404 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
    
    // MARK: - Device Management
    func getConnectedDevices(completion: @escaping ([Device]) -> Void) {
        guard let url = URL(string: "\(baseURL)/devices") else {
            completion([])
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data,
                      let devices = try? JSONDecoder().decode([Device].self, from: data) else {
                    // Возвращаем симулированные данные если API недоступно
                    completion(self.simulatedDevices())
                    return
                }
                completion(devices)
            }
        }.resume()
    }
    
    private func simulatedDevices() -> [Device] {
        return [
            Device(id: "1", name: "Apple TV (Гостиная)", type: "apple_tv", status: "connected"),
            Device(id: "2", name: "Samsung TV (Спальня)", type: "samsung_tv", status: "connected"),
            Device(id: "3", name: "Chromecast (Кухня)", type: "chromecast", status: "connected")
        ]
    }
    
    // MARK: - Settings
    func getSettings(completion: @escaping (ServerSettings?) -> Void) {
        guard let url = URL(string: "\(baseURL)/settings") else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data,
                      let settings = try? JSONDecoder().decode(ServerSettings.self, from: data) else {
                    completion(nil)
                    return
                }
                completion(settings)
            }
        }.resume()
    }
    
    func updateSettings(_ settings: ServerSettings, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/settings") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(settings)
        } catch {
            completion(false)
            return
        }
        
        session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
    
    // MARK: - Statistics
    func getStatistics(completion: @escaping (Statistics?) -> Void) {
        guard let url = URL(string: "\(baseURL)/stats") else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data,
                      let stats = try? JSONDecoder().decode(Statistics.self, from: data) else {
                    // Возвращаем симулированные данные
                    completion(Statistics(segmentsSkipped: 127, timeSaved: 2547))
                    return
                }
                completion(stats)
            }
        }.resume()
    }
}

// MARK: - Data Models
struct Device: Codable {
    let id: String
    let name: String
    let type: String
    let status: String
    
    var emoji: String {
        switch type {
        case "apple_tv":
            return "📺"
        case "samsung_tv", "lg_tv":
            return "📺"
        case "chromecast":
            return "📱"
        case "roku":
            return "📺"
        case "fire_tv":
            return "🔥"
        default:
            return "📺"
        }
    }
    
    var isConnected: Bool {
        return status == "connected"
    }
}

struct ServerSettings: Codable {
    var sponsorBlockEnabled: Bool
    var adBlockEnabled: Bool
    var autoSkipEnabled: Bool
    var skipCategories: [String]
    
    init(sponsorBlockEnabled: Bool = true, 
         adBlockEnabled: Bool = false, 
         autoSkipEnabled: Bool = true,
         skipCategories: [String] = ["sponsor", "intro", "outro"]) {
        self.sponsorBlockEnabled = sponsorBlockEnabled
        self.adBlockEnabled = adBlockEnabled
        self.autoSkipEnabled = autoSkipEnabled
        self.skipCategories = skipCategories
    }
}

struct Statistics: Codable {
    let segmentsSkipped: Int
    let timeSaved: Int // в секундах
    
    var formattedTimeSaved: String {
        let minutes = timeSaved / 60
        let hours = minutes / 60
        
        if hours > 0 {
            let remainingMinutes = minutes % 60
            return "\(hours)ч \(remainingMinutes)мин"
        } else {
            return "\(minutes) мин"
        }
    }
} 