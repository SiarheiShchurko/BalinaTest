
import Foundation

protocol RootProtocol: AnyObject {
    var update: (() -> Void)? { get set }
    var receiveError: ((String) -> Void)? { get set }
    var developersArray: [DeveloperModel] { get set }
    var successfulSubmission: (() -> Void)? { get set }
    
    func sendDeveleper(name: String, id: Int32, filePathKey: String) 
}
