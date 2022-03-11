//
//  File.swift
//  SpacePhoto SUI
//
//  Created by Augusto Galindo Alí on 23/02/21.
//

import SwiftUI

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}

class PhotoInfoController {
    
    func fetchPhotoInfo(date: Date, completion: @escaping (Result<PhotoInfo, Error>) -> Void) {
        print("The date you chose is \(dateFormatter.string(from: date))")
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": "Dj6CEmPOjiO0fWK0YBvopAscAEQtYg4t5DfLa9Ir",
            "date": dateFormatter.string(from: date),
            "hd": "true"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }

        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let photoInfo = try decoder.decode(PhotoInfo.self, from: data)
                    completion(.success(photoInfo))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    enum PhotoInfoError: Error, LocalizedError {
        case imageDataMissing
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        
        let task = URLSession.shared.dataTask(with: urlComponents!.url!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(PhotoInfoError.imageDataMissing))
            }
        }
        task.resume()
    }
}
