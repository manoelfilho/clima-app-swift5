import Foundation
import CoreLocation

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&lang=pt&appid=\(K.openweathermapKey)"
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(self.stringTrimToURL(cityName))"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        
        //print(urlString)
        
        //1 - create a URL
        if let url = URL(string: urlString) {
            
            //2 - create a URL session
            let session = URLSession(configuration: .default)
            
            //3 - give the session a task
            
            //SEM CLOSURE - FUNCAO handle LOGO ABAIXO
            //let task = session.dataTask(with: url, completionHandler: handle(data:urlResponse:error:))
            
            //COM CLOSURE
            let task = session.dataTask(with: url, completionHandler: {(data, urlResponse, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    // let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
                
            })
            
            //4 - start the task
            task.resume()
        }
        
    }
    
    //    FUNCTION PARA USAR COMO FUNCAO DE CALL BACK DO RETORNO DA CONSULTA A API
    //    NO EXEMPLO ACIMA USAMOS O CLOUSURE ENTAO ESSE METODO NAO ESTA SENDO USADO
    //    func handle(data: Data?, urlResponse: URLResponse?, error:Error?) {
    //        if error != nil {
    //            print(error!)
    //            return
    //        }
    //        if let safeData = data {
    //            let dataString = String(data: safeData, encoding: .utf8)
    //            print(dataString)
    //        }
    //    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
            //print(weather.conditionName)
            //print(weather.temperatureStting)
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func stringTrimToURL(_ nameOfString:String) -> String {
        return nameOfString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
            .replacingOccurrences(of: " ", with: "+")
    }
    
}
