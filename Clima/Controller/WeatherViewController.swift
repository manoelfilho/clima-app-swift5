import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var unsplashManager = UnsplashManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        unsplashManager.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    
}

//MARK: - Section Heading

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    //permite fechar o teclado do telefone?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) //Finaliza a escrita no textfield
        return true //permite aqui...
    }
    
    //permite a finalizacao do textfield ? Aceita o clique do ok do teclado?
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true //se nao for vazio, ok
        }else{
            textField.placeholder = "Digite o nome da cidade"
            return false //se for vazio, coloca um alerta e nada faz...
        }
    }
    
    //acao executada ao finalizar o textfield ...
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let cityName = textField.text {
            weatherManager.fetchWeather(cityName: cityName)
        }
        searchTextField.text = ""
    }
    
}

//MARK: - Weather Delegate

extension WeatherViewController: WeatherManagerDelegate {
    
    //function of delegate
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureStting
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage.init(systemName: weather.conditionName)
        }
        
        self.unsplashManager.fetchImage(key: weather.cityName)
        
    }
    
    //function of delegate
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - Location

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestLocation()
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lgt  = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lgt)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension WeatherViewController: UnsplashManagerDelegate{
    func didUpdateImage(_ unsplashManager: UnsplashManager, unsplashModel: UnsplashModel) {
        if let image = unsplashModel.results?[0].urls?.full {
            DispatchQueue.main.async {
                self.backgroundImageView.downloaded(from: image)
                self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
}

