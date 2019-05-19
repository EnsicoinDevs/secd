import Logging
import FileUtils
import Foundation

public final class EnsicoinApp {

	public final class Config : Codable {
		public let logger : String = "com.ensicoin.swift"
		public let port : UInt16 = 4224
	}

	public static let shared = EnsicoinApp()

	public let config : Config
	public let logger : Logger
	public let monitor : FileMonitor

	private init() {
		self.config = Config()

		self.logger = Logger(label: self.config.logger)

		self.monitor = FileMonitor()
		self.monitor.setWrite(of: 1, to: FileWriteBytesDelegate(with: "Hello, World!\n".data(using: .utf8)!))
	}
}

