import Foundation

public typealias JSONDictionary = [String: Any]

public typealias JSONParams = [String: AnyHashable]

public typealias HttpRequestCompletionBlock = (Any?, URLResponse?, Error?) -> Void
