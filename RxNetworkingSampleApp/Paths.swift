import Foundation

struct Paths {
    /// Get the path of the document directory in app file system.
    ///
    /// - Returns: Full path of document directory.
    @discardableResult
    public static func documentDirectoryPath() -> String {
        let paths: Array = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        )
        let docDir: String = paths[0]
        return docDir
    }

    /// Get the file path of the document directory in app file system.
    ///
    /// - Parameter fileName: Name of the file
    /// - Returns: Full path for the file in document directory
    @discardableResult
    public static func filePathInDocDirectory(fileName: String) -> String {
        let paths: [String] = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        )
        let docDir: String = paths[0]
        let filePath: String = docDir + "/" + fileName

        return filePath
    }
}
