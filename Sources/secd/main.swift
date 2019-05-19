import Logging

LoggingSystem.bootstrap(StreamLogHandler.standardError)

let app = EnsicoinApp.shared

while !app.monitor.isEmpty {
	switch app.monitor.pselect() {
		case .success:
			break
		case .failure(let failure):
			app.logger.error("Monitor error: \(failure)")
	}
}

