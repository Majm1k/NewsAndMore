//
//  APICaller.swift
//  NewsAndMore
//
//  Created by Дмитрий Рузайкин on 07.06.2022.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    struct Constants{
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=ru&category=technology&apiKey=2f605a9e5de0492c8a69caf6429618aa")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            } else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    
                    //DispatchQueue.main.async {
                    completion(.success(result.articles))
                } catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    let author: String?
}

struct Source: Codable{
    let name: String
}

