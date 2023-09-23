
enum NetworkServiceResult {
    case success([Decodable])
    case error(error: Error)
}
