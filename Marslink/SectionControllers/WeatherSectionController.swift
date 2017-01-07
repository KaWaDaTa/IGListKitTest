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

class WeatherSectionController: IGListSectionController {
  var weather: Weather!
  var expanded = false
  
  override init() {
    super.init()
    inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
  }
}

// MARK: - IGListSectionType
extension WeatherSectionController: IGListSectionType {
  func didUpdate(to object: Any) {
    weather = object as? Weather
  }

  func numberOfItems() -> Int {
    return expanded ? 5 : 1
  }
  
  func sizeForItem(at index: Int) -> CGSize {
    guard let context = collectionContext else { return .zero }
    let width = context.containerSize.width
    if index == 0 {
      return CGSize(width: width, height: 70)
    } else {
      return CGSize(width: width, height: 40)
    }
  }
  
  func cellForItem(at index: Int) -> UICollectionViewCell {
    let cellClass: AnyClass = index == 0 ? WeatherSummaryCell.self : WeatherDetailCell.self
    let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
    if let cell = cell as? WeatherSummaryCell {
      cell.setExpanded(expanded)
    } else if let cell = cell as? WeatherDetailCell {
      let title: String, detail: String
      switch index {
      case 1:
        title = "SUNRISE"
        detail = weather.sunrise
      case 2:
        title = "SUNSET"
        detail = weather.sunset
      case 3:
        title = "HIGH"
        detail = "\(weather.high) C"
      case 4:
        title = "LOW"
        detail = "\(weather.low) C"
      default:
        title = "n/a"
        detail = "n/a"
      }
      cell.titleLabel.text = title
      cell.detailLabel.text = detail
    }
    return cell
  }

  func didSelectItem(at index: Int) {
    if index != 0 {
        return
    }
    expanded = !expanded
    collectionContext?.reload(self)
  }
}


