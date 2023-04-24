//
//  Networking.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 24.04.23.
//

import Foundation

struct NetworkError: Error {}

struct Networking {
    static func getRSSPageOfSite(by url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let session = URLSession(configuration: .ephemeral)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NetworkError()))
                }
                return
            }

            if let data = data, let stringData = String(data: data, encoding: .utf8) {
                completion(.success(stringData))
                return
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NetworkError()))
            }
        }
        dataTask.resume()
    }
}
