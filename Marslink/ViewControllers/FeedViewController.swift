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

import UIKit
import IGListKit

class FeedViewController: UIViewController {
  
  let loader = JournalEntryLoader()
  let collectionView: IGListCollectionView = {
    let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    view.backgroundColor = UIColor.black
    return view
  }()
  lazy var adapter: IGListAdapter = {
    return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
  }()
  let pathfinder = Pathfinder()
  let wxScanner = WxScanner()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    loader.loadLatest()
    view.addSubview(collectionView)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    pathfinder.delegate = self
    pathfinder.connect()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: - IGListAdapterDataSource
extension FeedViewController: IGListAdapterDataSource {
  
  func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
    var items: [IGListDiffable] = [wxScanner.currentWeather]
    items += loader.entries as [IGListDiffable]
    items += pathfinder.messages as [IGListDiffable]

    return items.sorted(by: { (left: Any, right: Any) -> Bool in
      if let left = left as? DateSortable, let right = right as? DateSortable {
        return left.date > right.date
      }
      return false
    })
  }
  
  func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
    if object is Message {
      return MessageSectionController()
    } else if object is Weather {
      return WeatherSectionController()
    } else {
      return JournalSectionController()
    }
  }
  func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}

// MARK: - PathfinderDelegate
extension FeedViewController: PathfinderDelegate {
  func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
    adapter.performUpdates(animated: true)
  }
}
