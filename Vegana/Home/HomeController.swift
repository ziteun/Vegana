//
//  HomeController.swift
//  vegana
//
//  Created by DongUk Kim on 2022/01/01.
//  Copyright © 2022 VEGANA. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, HomePostCellDelegate {
    var user: User?
    let cellId = "cellId"
    var posts = [Post]()
    let refreshControl = UIRefreshControl()
    
    let loadingPhotosQueue = OperationQueue()
    var loadingPhotosOperations: [IndexPath: DataPrefetchOperation] = [:]
    
    // paginations properties
    var fetchingMore = false
    var endReached = false
    let leadingScreenForBatching:CGFloat = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.prefetchDataSource = self
        collectionView?.backgroundColor = .systemBackground
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        refreshControl.addTarget(self, action: #selector(refreshTop), for: .valueChanged)
        
        collectionView?.refreshControl = refreshControl
        setupDMbarbuttomItem()
        setupNavigationItems()
        fetchUser()
        beginBatchFetch()
    }
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            //self.navigationItem.title = self.user?.username
        }
    }
    
    private func setupDMbarbuttomItem () {
        let directMessageButton = UIBarButtonItem(image: UIImage(systemName: "paperplane")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(showDMController))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(showSearchController))
        self.navigationItem.rightBarButtonItems = [directMessageButton, searchButton]
    }
    
    @objc
    private func showDMController() {
        guard let user = self.user else { return }
        let DMTVC = DMtableViewController()
        DMTVC.user = user
        DMTVC.navigationItem.title = "Direct"
        DMTVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(DMTVC, animated: true)
    }
    
    @objc
    private func showSearchController() {
        let searchController = UserSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        searchController.navigationItem.title = "Search"
        searchController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
    
    private var lastKey: String?
    private var startKey: String?
    
    private func fetchFeedPosts(completion: @escaping (_ posts:[Post])->()) {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        //let postsRef = Database.database().reference().child("FeedPosts").child(uid)
        let postsRef = Database.database().reference().child("FeedPosts")
        
        var queryRef: DatabaseQuery
        if self.lastKey == nil {
            queryRef = postsRef.queryOrderedByKey().queryLimited(toLast: 3)
        } else {
            queryRef = postsRef.queryOrderedByKey().queryEnding(atValue: self.lastKey).queryLimited(toLast: 3)
        }
        
        queryRef.observeSingleEvent(of: .value) { snapshot in
            guard let lastSnapshot = snapshot.children.allObjects.first as? DataSnapshot else { return }
            
            var newPosts = [Post]()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                if self.lastKey != key {
                    guard let dictionary = value as? [String: Any] else { return }
                    guard let userDic = dictionary["user"] as? [String: Any] else { return }
                    let user = User(uid: userDic["userId"] as! String, dictionary: userDic)
                    var post = Post(user: user, dictionary: dictionary)
                    post.id = key
                    
                    for postId in self.posts {
                        if key == postId.id {
                            return
                        }
                    }
                    
                    newPosts.append(post)
                }
            })
            newPosts.sort { (p1, p2) -> Bool in
                let date1 = Double(p1.creationDate.timeIntervalSince1970)
                let date2 = Double(p2.creationDate.timeIntervalSince1970)
                return date1 < date2
            }
            
            self.lastKey = lastSnapshot.key
            
            completion(newPosts)
        }
    }
    
    //
    private func fetchTopFeedPosts(completion: @escaping (_ posts:[Post])->()) {
//            guard let uid = Auth.auth().currentUser?.uid else { return }
            let postsRef = Database.database().reference().child("FeedPosts")
            
            var queryRef:DatabaseQuery
            if startKey == nil {
                queryRef = postsRef.queryOrderedByKey().queryLimited(toFirst: 3)
            } else {
                queryRef = postsRef.queryOrderedByKey().queryStarting(atValue: startKey).queryLimited(toFirst: 3)
            }
            
            queryRef.observeSingleEvent(of: .value) { snapshot in
                var newPosts = [Post]()
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                dictionaries.forEach({ (key, value) in
                    if self.startKey != key {
                        guard let dictionary = value as? [String: Any] else { return }
                        guard let userDic = dictionary["user"] as? [String: Any] else { return }
                        let user = User(uid: userDic["userId"] as! String, dictionary: userDic)
                        var post = Post(user: user, dictionary: dictionary)
                        post.id = key
                        
                        for postId in self.posts {
                            if key == postId.id {
                                return
                            }
                        }
                        
                        newPosts.append(post)
                    }
                })
                newPosts.sort { (p1, p2) -> Bool in
                    let date1 = Double(p1.creationDate.timeIntervalSince1970)
                    let date2 = Double(p2.creationDate.timeIntervalSince1970)
                    return date1 < date2
                }
                let lastSnapshot = snapshot.children.allObjects.last as! DataSnapshot
                self.startKey = lastSnapshot.key
                completion(newPosts)
            }
        }
    //
    
    @objc func handleUpdateFeed() {
        refresh()
    }

    @objc func refresh() {
        print("refresh...")
        //posts.removeAll()
        
        fetchUser()
        beginBatchFetch()
        
        self.collectionView?.refreshControl?.endRefreshing()
    }
    
    @objc func refreshTop() {
        print("refresh...")
        //posts.removeAll()
        
        fetchUser()
        beginTopBatchFetch()
        
        self.collectionView?.refreshControl?.endRefreshing()
    }
    
    
    func setupNavigationItems() {
        // 네비게이션 이미지
//        let image = #imageLiteral(resourceName: "logo")
//        let tintImage = image.withRenderingMode(.alwaysTemplate)
//        let imageView = UIImageView(image: tintImage)
//        imageView.tintColor = .label
//        navigationItem.titleView = imageView
        
        // 네비게이션 텍스트
        navigationItem.title = "VEGANA"
    }
    
    
    // MARK:- ScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        //print("\(offsetY): \(contentHeight)")
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreenForBatching {
            if !fetchingMore && !endReached {
                beginBatchFetch()
            }
        }
        //print(posts.count)
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        fetchFeedPosts() { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.endReached = newPosts.count == 0
            print(self.posts.count)
            self.fetchingMore = false
            self.collectionView.reloadData()
        }
    }
    
    private func beginTopBatchFetch() {
        fetchingMore = true
        fetchTopFeedPosts() { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate > post2.creationDate
            })
            self.endReached = newPosts.count == 0
            print(self.posts.count)
            self.fetchingMore = false
            self.collectionView.reloadData()
        }
    }
}

// MARK:- UICollectionViewDelegateFlowLayout

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let commentString = posts[indexPath.item].caption
        let estimateHeight = commentString.getEdtimatedHeight(width: view.frame.width)
        var height: CGFloat = 40 + 8 + 8 //username and userProfileImageView
        height += view.frame.width
        height += 50
        height += 60
        height += estimateHeight
        return CGSize(width: view.frame.width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! HomePostCell
        if !self.refreshControl.isRefreshing {
            cell.post = posts[indexPath.item]
            
            // TODO: what if operation queue and customImage.load doesn't fetch => we left with two request!
            
        }
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        if let dataLoader = loadingPhotosOperations[indexPath] {
            loadingPhotosOperations.removeValue(forKey: indexPath)
            dataLoader.cancel()
        }
    }
    
    func didTapComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        commentsController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didLike(for cell: HomePostCell) {
        
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }

        var post = posts[indexPath.item]

        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // update like db
        let values = [uid: post.hasLiked ? 0 : 1]
        
        Database.database().reference().child("likes").child(postId).updateChildValues(values)
        { (err, _) in

            if let err = err {
                print("Failed to like post:", err)
                return
            }

            print("Successfully liked post")

            post.hasLiked = !post.hasLiked
            
            DispatchQueue.main.async {
                self.posts[indexPath.item] = post
                self.collectionView?.reloadItems(at: [indexPath])
            }
            
        }
        // update post
        //Database.database().reference().child("FeedPosts").child(uid).child(postId).updateChildValues(["hasLiked": post.hasLiked ? false: true])
        Database.database().reference().child("FeedPosts").child(postId).updateChildValues(["hasLiked": post.hasLiked ? false: true])
    }

}


// MARK:- UICollectionViewDataSourcePrefetching

extension HomeController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        if !self.refreshControl.isRefreshing {
            for indexPath in indexPaths {
                let imageUrl = posts[indexPath.row].imageUrl
                if imageCache[imageUrl] == nil {
                    //print("loading indexpath: \(indexPath)")
                    let dataPrefetcher = DataPrefetchOperation(with: imageUrl)
                    loadingPhotosQueue.addOperation(dataPrefetcher)
                    loadingPhotosOperations[indexPath] = dataPrefetcher
                }
            }
        }
    }

    // it's only called when the cache is cleared as the photos
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataPrefetcher = loadingPhotosOperations[indexPath] {
                dataPrefetcher.cancel()
                loadingPhotosOperations.removeValue(forKey: indexPath)
                //print("cancel loading indexpath: \(indexPath)")
            }
        }
    }
}

