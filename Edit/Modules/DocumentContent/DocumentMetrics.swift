import Foundation

import Rearrange
import RelativeCollections

public final class DocumentMetrics {
	private struct LineValue {
		let whitespaceOnly: Bool
	}

	private lazy var rangeStateProcessor = LazyRangeStateProcessor(
		configuration: .init(minimumDelta: 1024),
		processor: .init(
			didChange: { [weak self] in self?.didChange($0, delta: $1) }
		)
	)

	private let parser = LineParser()
	private let lineList = RelativeList<LineValue, Int>()
	private let storage: TextStorageReference

	init(storage: TextStorageReference) {
		self.storage = storage
	}

	public func line(at index: Int) -> Line {
		let record = lineList[index]
		let range = NSRange(location: record.dependency, length: record.weight)

		return Line(index: index, range: range, whitespaceOnly: record.value.whitespaceOnly)
	}

	public func lineCount() -> Int {
		lineList.count
	}
}

extension DocumentMetrics: TextStorageMonitor {
	public func willApplyMutations(_ mutations: [TextStorageMutation]) {
		rangeStateProcessor.willApplyMutations(mutations)
	}

	public func didApplyMutations(_ mutations: [TextStorageMutation]) {
		rangeStateProcessor.didApplyMutations(mutations)
	}
}

extension DocumentMetrics {
	/// Apply an effective change.
	///
	/// This is invoked lazily by `rangeStateProcessor`.
	private func didChange(_ range: NSRange, delta: Int) {
		let rangeMutation = RangeMutation(range: range, delta: delta)

		let limit = rangeMutation.postApplyLimit
		let range = rangeMutation.range
		let delta = rangeMutation.delta

		let lowerIndex = lastLineIndex(before: range.location)
		let upperIndex = firstLineIndex(after: range.max)

		let lowerReadLocation = lowerIndex.flatMap { line(at: $0).range.location } ?? 0
		let upperReadLocation = upperIndex.flatMap { min(line(at: $0).range.location + delta, limit) } ?? limit

		let affectedRange = NSRange(lowerReadLocation..<upperReadLocation)

		guard let substring = try? storage.substring(from: affectedRange) else {
			fatalError("Unable to compute substring from readableRange")
		}

		print("substring: ", substring)
	}
}

extension DocumentMetrics {
	private func firstLineIndex(after location: Int) -> Int? {
		lineList.firstIndex { record in
			location < record.dependency
		}
	}

	private func lastLineIndex(before location: Int) -> Int? {
		lineList.reversed().firstIndex { record in
			record.dependency <= location
		}
	}
}