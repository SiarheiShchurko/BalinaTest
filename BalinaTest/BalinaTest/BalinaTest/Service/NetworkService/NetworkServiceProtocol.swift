import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func getDevelopers(complition: @escaping(NetworkServiceResult) -> Void)
    func sendImageToServer(name: String, id: Int32, filePathKey: String, complition: @escaping(NetworkServiceResult) -> Void)
}
