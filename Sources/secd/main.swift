import Logging

LoggingSystem.bootstrap(StreamLogHandler.standardError)

let app = EnsicoinApp.shared

app.logger.info("EnsicoinApp running...")

while !app.monitor.isEmpty {
	switch app.monitor.pselect() {
	case .success(let handled):
		app.logger.info("EnsicoinApp Monitor handled \(handled) connections")
	case .failure(let failure):
		app.logger.error("EnsicoinApp Monitor error: \(failure)")
	}
}

