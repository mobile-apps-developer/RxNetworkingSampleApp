
import UIKit

final class ReachabilityWrapper: NSObject {
    /// Shared reachability instance across the app.
    static let sharedReach = Reachability()
    private override init() {}

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

public enum HttpMethods: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

private extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false
        )
        append(data!)
    }
}
