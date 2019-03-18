//
//  URLSession.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

enum Result <A : Codable> {
    case succeed( data : A)
    case failer(error : Error)
}


extension URLSession {
    func load<A : Codable>(_ resource: TinyResourceProtocol, completion: @escaping (Result<A>) -> ()) {
        print(resource.urlRequest.description)
        dataTask(with: resource.urlRequest) { data, _, err in
            guard let data = data else {
                completion(Result.failer(error: err!))
                return
            }
            do {
                completion(Result.succeed(data: try resource.parse(data)))
            }catch let error {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
}



