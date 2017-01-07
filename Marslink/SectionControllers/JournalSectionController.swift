/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import IGListKit

class JournalSectionController: IGListSectionController {
  var entry: JournalEntry!
  let solFormatter = SolFormatter()

  override init() {
    super.init()
    inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
  }
}

// MARK: - IGListSectionType
extension JournalSectionController: IGListSectionType {
  func numberOfItems() -> Int {
    return 2
  }
  
  func sizeForItem(at index: Int) -> CGSize {
    guard let context = collectionContext, let entry = entry else { return .zero }
    let width = context.containerSize.width

    if index == 0 {
      return CGSize(width: width, height: 30)
    } else {
      return JournalEntryCell.cellSize(width: width, text: entry.text)
    }
  }
  
  func cellForItem(at index: Int) -> UICollectionViewCell {
    let cellClass: AnyClass = index == 0 ? JournalEntryDateCell.self : JournalEntryCell.self
    let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)

    if let cell = cell as? JournalEntryDateCell {
      cell.label.text = "SOL \(solFormatter.sols(fromDate: entry.date))"
    } else if let cell = cell as? JournalEntryCell {
      cell.label.text = entry.text
    }
    return cell
  }
  
  func didUpdate(to object: Any) {
    entry = object as? JournalEntry
  }
  
  func didSelectItem(at index: Int) {}
}

