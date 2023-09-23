
import Foundation

final class RootVM: RootProtocol {

    // MARK: Properties
    private let networkService: NetworkServiceProtocol
    
    var update: (() -> Void)?
    var successfulSubmission: (() -> Void)?
    var receiveError: ((String) -> Void)?
    var developersArray: [DeveloperModel] = [] {
        didSet {
            update?()
        }
    }
    
    // MARK: Init
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        getDevelopers()
    }
}

// MARK: GetDevelopers
private extension RootVM {
    func getDevelopers() {
        // # 1
        networkService.getDevelopers { [ weak self ] result in
            // # 2
            switch result {
            case .success(let resultArray):
                if let currentArray = resultArray as? [DeveloperModel] {
                    self?.developersArray = currentArray
                }
            case .error(error: ):
                self?.receiveError?("No data received. Check your internet connection or try again later")
            }
        }
    }
}

// MARK: SendDevelopersData
extension RootVM {
    func sendDeveleper(name: String, id: Int32, filePathKey: String) {
        networkService.sendImageToServer(name: name, id: id, filePathKey: filePathKey) { [  weak self ]result in
            switch result {
            case .success(_):
                self?.successfulSubmission?()
            case .error(error:):
                self?.receiveError?("Failed to send. Try later")
            }
        }
    }
}

