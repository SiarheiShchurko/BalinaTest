
import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    var task: URLSessionDataTask?
    
    func getDevelopers(complition: @escaping(NetworkServiceResult) -> Void) {
        // # 1
        guard
            let url = URL(string: "https://junior.balinasoft.com/api/v2/photo/type") else {
            complition(.error(error: NetworkServiceErrors.urlStringInvalid))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // # 2
        self.task = URLSession.shared.dataTask(with: request) { data, response, error in
            // # 3
            if let error {
                complition(NetworkServiceResult.error(error: error))
                // # 4
            } else if let data {
                // # 5
                do {
                    let developerResponse = try JSONDecoder().decode(DeveloperResponse.self, from: data)
                    DispatchQueue.main.async {
                        let developers = developerResponse.content
                        complition(NetworkServiceResult.success(developers))
                    }
                } catch {
                    complition(NetworkServiceResult.error(error: error))
                }
            }
            // # 6
        }
        task?.resume()
    }

    func sendImageToServer(name: String, id: Int32, filePathKey: String, complition: @escaping(NetworkServiceResult) -> Void) {
        // # 1
        guard
            let url = URL(string: "https://junior.balinasoft.com/api/v2/photo") else {
            complition(.error(error: NetworkServiceErrors.urlStringInvalid))
            return
        }
        // # 2
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // # 3
        let parameters = [
            "name": name,
            "typeId": id
        ] as [String : Any]
        // # 4
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // # 5
        request.httpBody = createBody(with: parameters, filePathKey: filePathKey, boundary: boundary)
        
        // # 6
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error {
                complition(NetworkServiceResult.error(error: error))
            } else if let data = data {
              if let responseString = String(data: data, encoding: .utf8) {
                    complition(NetworkServiceResult.success([responseString]))
                }
            }
        }
        // # 7
        task.resume()
    }
}

// MARK: - Create body
private extension NetworkService {
    private func createBody(with parameters: [String: Any], filePathKey: String, boundary: String) -> Data {
        // # 1
        var requestBodyData = Data()
        // # 2
        for (key, value) in parameters {
            let parameterString = "--\(boundary)\r\n" +
            "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" +
            "\(value)\r\n"
            if let parameterData = parameterString.data(using: .utf8) {
                requestBodyData.append(parameterData)
            }
        }
        
        // # 3
        let imageString = "--\(boundary)\r\n" +
        "Content-Disposition: form-data; name=\"photo\"; filename=\"image.jpg\"\r\n" +
        "Content-Type: image/jpeg\r\n\r\n"
        if let imageStringData = imageString.data(using: .utf8) {
            requestBodyData.append(imageStringData)
        }
        // # 4
        if let imageData = try? Data(contentsOf: URL(fileURLWithPath: filePathKey)) {
            requestBodyData.append(imageData)
        }
        // # 5
        let newlineData = "\r\n".data(using: .utf8)
        requestBodyData.append(newlineData!)
        
        // # 6
        let closingBoundaryString = "--\(boundary)--\r\n"
        if let closingBoundaryData = closingBoundaryString.data(using: .utf8) {
            requestBodyData.append(closingBoundaryData)
        }
        return requestBodyData
    }
}
