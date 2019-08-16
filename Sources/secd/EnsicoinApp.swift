import Logging
import FileUtils
import Foundation

public final class EnsicoinApp {

	public final class Config : Codable {
		public let logger : String = "com.ensicoin.swift"
		public let port : Socket.NetPort = 4224
		public let bufferSize : Int = 4096
		public let bufferAlignment : Int = 4
	}

	public static let shared = EnsicoinApp()

	public let config : Config
	public let logger : Logger
	public let monitor : FileMonitor
	public var buffer : UnsafeMutableRawBufferPointer

	private init() {
		self.config = Config()

		self.logger = Logger(label: self.config.logger)

		self.monitor = FileMonitor()

		self.buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: self.config.bufferSize, alignment: self.config.bufferAlignment)

		let socket = EnsicoinApp.makeSocketIPv6(from: self.config, loggingTo: self.logger)
		self.monitor.read(for: socket, with: acceptPeerIPv6)
	}

	deinit {
		self.buffer.deallocate()
	}

	private func readPeer(fileDescriptor: FileDescriptor) -> Bool {
		var address = Socket.NetAddress()

		switch File.receive(socket: fileDescriptor, in: self.buffer, from: &address) {
		case .failure(let error):
			logger.error("EnsicoinApp: Unable to receive socket \(fileDescriptor): \(error.rawValue)")
		case .success(let received):
			if received == 0 {
				return true
			}
		}

		return false
	}

	private func acceptPeerIPv6(fileDescriptor: FileDescriptor) -> Bool {
		var address = Socket.NetAddress()

		switch File.makeSocket(fromINet6: fileDescriptor, address: &address) {
		case .failure(let error):
			self.logger.error("EnsicoinApp: Error when accepting socket from INet6 \(fileDescriptor): \(error.rawValue)")
		case .success(let socket):
			self.monitor.read(for: socket, with: readPeer)
		}

		return true
	}

	private static func makeSocketIPv6(from configuration: Config, loggingTo logger: Logger) -> FileDescriptor {

		guard let netProtocol = Socket.netProtocol(named: "IP"),
			let netAddress = Socket.NetAddress(ipv6: "::", port: configuration.port) else {
			logger.error("EnsicoinApp: Unable to load static configuration")
			abort()
		}

		switch File.makeSocket(in: .inet6, as: .stream, following: netProtocol) {
		case .failure(let error):
			logger.error("EnsicoinApp: Error when creating socket: \(error.rawValue)")
			abort()
		case .success(let fileDescriptor):
			if let error = Socket.bind(socket: fileDescriptor, at: netAddress) {
				logger.error("EnsicoinApp: Error when binding acceptor: \(error.rawValue)")
				abort()
			}

			if let error = Socket.listen(with: fileDescriptor) {
				logger.error("EnsicoinApp: Error for listen: \(error.rawValue)")
				abort()
			}

			return fileDescriptor
		}
	}
}

