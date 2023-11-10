import AppKit

import DocumentContent
import SourceView
import Theme

public final class SourceViewController: NSViewController {
	let sourceView = SourceView()

	public init(content: DocumentContent) {
		super.init(nibName: nil, bundle: nil)

		sourceView.drawsBackground = false
		sourceView.wrapsTextToHorizontalBounds = false

		sourceView.delegate = self

		self.representedObject = content
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func loadView() {
		self.view = sourceView
	}

	var representedContent: DocumentContent {
		representedObject as! DocumentContent
	}

	override public var representedObject: Any? {
		didSet {
			if sourceView.textContentStorage?.textStorage === representedContent.storage {
				return
			}
			
			sourceView.textContentStorage?.textStorage = representedContent.storage
		}
	}
}

extension SourceViewController {
	public func updateTheme(_ theme: Theme, context: Theme.Context) {
		sourceView.typingAttributes = [
			.font: theme.font(for: .source, context: context),
			.foregroundColor: theme.color(for: .source, context: context),
		]

		sourceView.insertionPointColor = theme.color(for: .insertionPoint, context: context)
	}
}

extension SourceViewController: NSTextViewDelegate {
	public func textView(_ textView: NSTextView, shouldChangeTextInRanges affectedRanges: [NSValue], replacementStrings: [String]?) -> Bool {
		return true
	}
}
