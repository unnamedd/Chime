import AppKit

public final class TextDocument: NSDocument {
	override init() {
	    super.init()
		// Add your subclass-specific initialization here.
	}

	public override class var autosavesInPlace: Bool {
		return true
	}

	public override func makeWindowControllers() {
		let window = NSWindow(contentViewController: NSViewController())

		addWindowController(NSWindowController(window: window))

		window.contentMinSize = NSSize(width: 100, height: 200)
	}

	public override func data(ofType typeName: String) throws -> Data {
		// Insert code here to write your document to data of the specified type, throwing an error in case of failure.
		// Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
		throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
	}

	public override func read(from data: Data, ofType typeName: String) throws {
		// Insert code here to read your document from the given data of the specified type, throwing an error in case of failure.
		// Alternatively, you could remove this method and override read(from:ofType:) instead.
		// If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
		throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
	}
}
