import Foundation
import ExtensionFoundation

import ChimeKit

@main
final class SwiftStandaloneExtension: ChimeExtension {
	private let localExtension: StandaloneExtension<SwiftExtension>

	init() {
		self.localExtension = StandaloneExtension(extensionProvider: { SwiftExtension(host: $0) })
	}

	func acceptHostConnection(_ host: HostProtocol) throws {
		try localExtension.acceptHostConnection(host)
	}
}

extension SwiftStandaloneExtension {
	var configuration: ExtensionConfiguration {
		get throws {
			return try localExtension.configuration
		}
	}

	var applicationService: some ApplicationService {
		get throws {
			return try localExtension.applicationService
		}
	}
}
