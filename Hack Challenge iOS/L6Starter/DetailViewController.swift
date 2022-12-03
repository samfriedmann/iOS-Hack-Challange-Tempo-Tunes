//
//  DetailViewController.swift
//  L6Starter
//
//  Created by Sam Friedman on 10/24/22.
//

import UIKit

import youtube_ios_player_helper

import AVFoundation


class DetailViewController: UIViewController {

    var BkImageView: UIImageView!
    var buttonColor = UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1.0)

    
    let albumImageView = UIImageView()
    
    let songTitle = UITextField()
    let artistLabel = UITextField()
    let bpmLabel = UITextField()
    let bpmTextLabel = UITextField()

    let playButton = UIButton()
    let songTitleLabel = UILabel()
    let artistTextLabel = UILabel()
    let submitButton = UIButton()
    
    var webView: WKWebView!
    
    @IBOutlet var playerView: YTPlayerView!

    let song: Song
    weak var delegate: ChangeSongDelegate?
    init(song: Song, delegate:ChangeSongDelegate) {
        self.song = song
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BkImageView = UIImageView(frame: view.bounds)
        BkImageView.contentMode = .scaleAspectFill
        BkImageView.clipsToBounds = true
        BkImageView.image = UIImage(named: "gradient")
        BkImageView.center = view.center
        view.addSubview(BkImageView)
        self.view.sendSubviewToBack(BkImageView)
        
//        title = "Edit Song"

//        albumImageView.image = UIImage(named:"logo")
//        albumImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        albumImageView.layer.cornerRadius = 20
//        albumImageView.clipsToBounds = true
//
//        view.addSubview(albumImageView)
        
        
        submitButton.setTitle("   Submit   ", for: .normal)
        submitButton.backgroundColor = buttonColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(changeSongCell), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)

        songTitle.text = song.title
        songTitle.font = .systemFont(ofSize: 20)
        songTitle.backgroundColor = .systemGray5
        songTitle.layer.cornerRadius = 5
        songTitle.clipsToBounds = true
        songTitle.textAlignment = .center
        songTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(songTitle)
        
        artistLabel.text = song.artist
        artistLabel.font = .systemFont(ofSize: 20)
        artistLabel.backgroundColor = .systemGray5
        artistLabel.layer.cornerRadius = 5
        artistLabel.clipsToBounds = true
        artistLabel.textAlignment = .center
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(artistLabel)
        
        songTitleLabel.text = "Song Title:"
        songTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(songTitleLabel)
        
        artistTextLabel.text = "Artist:"
        artistTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(artistTextLabel)
        
        bpmTextLabel.text = "BPM:"
        bpmTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bpmTextLabel)
        
        bpmLabel.text = String(song.bpm)
        bpmLabel.font = .systemFont(ofSize: 20)
        bpmLabel.backgroundColor = .systemGray5
        bpmLabel.layer.cornerRadius = 5
        bpmLabel.clipsToBounds = true
        bpmLabel.textAlignment = .center
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bpmLabel)
        
        submitButton.setTitle("   Submit   ", for: .normal)
        submitButton.backgroundColor = buttonColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(changeSongCell), for: .touchUpInside)
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)

        playButton.setTitle("    Play on YouTube    ", for: .normal)
        playButton.backgroundColor = buttonColor
        playButton.setTitleColor(.white, for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        playButton.layer.cornerRadius = 8
        playButton.addTarget(self, action: #selector(openURL), for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playButton)

//        playerView.delegate = self
//        playerView.load(withVideoId: "YE7VzlLtp-4", playerVars: ["playsinline": "1"])
//
//        // If you want to change the video after you loaded the first one, use the following code
////        playerView.cueVideo(byId: "DQuhA5ZCV9M", startSeconds: 0)
//
//        playerView.webView?.backgroundColor = .black
//        playerView.webView?.isOpaque = false
        
        playYT()
        setupConstraints()
    }
        
    
    @objc func changeSongCell() {
        delegate?.changeSongName(name: songTitle.text!, artist: artistLabel.text!, bpm:bpmLabel.text!)
        song.title = songTitle.text!
        song.artist = artistLabel.text!
        song.bpm = Int(bpmLabel.text!)!
        dismiss(animated:true)
    }
    
    @objc func openURL(){
                
        guard let url = URL(string: song.link) else {
          return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    func playYT(){
        
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), configuration: webViewConfiguration)
        
        webView.center.x = view.center.x
        
        
        // Load a YouTube video URL in the web view
        if let url = URL(string: song.link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        // Add the web view to your view hierarchy
        view.addSubview(webView)
        

        //        let WV = WKWebView(frame: CGRect(origin: 50, size: 50))
        //
        //        let webV:UIWebView = UIWebView(frame: CGRectMake(0, 0, view.safeAreaLayoutGuide.widthAnchor, view.safeAreaLayoutGuide.heightAnchor))
        //        webV.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.google.co.in")))
        //        webV.delegate = self;
        //        self.view.addSubview(webV)
        //
        //        let width: CGFloat = player.frame.size.width
        //        let height = ceil((width / 16) * 9) // Assuming that the videos aspect ratio is 16:9
        //
        //        let htmlString = "<div style='text-align: center;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(width)' height='\(height)' src='http://www.youtube.com/embed/\(youtubeVideoID)?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></div>"
        
    }

    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            playButton.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: -30),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    

        NSLayoutConstraint.activate([
            songTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 350),
            songTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            songTitle.topAnchor.constraint(equalTo: songTitleLabel.bottomAnchor, constant: 10),
            songTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            songTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.67),
        ])
        
        
        NSLayoutConstraint.activate([
            artistTextLabel.topAnchor.constraint(equalTo: songTitle.bottomAnchor, constant: 20),
            artistTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            artistLabel.topAnchor.constraint(equalTo: artistTextLabel.bottomAnchor, constant: 10),
            artistLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            artistLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.67),
        ])
        
        NSLayoutConstraint.activate([
            bpmTextLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 20),
            bpmTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bpmLabel.topAnchor.constraint(equalTo: bpmTextLabel.bottomAnchor, constant: 10),
            bpmLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bpmLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.67),
        ])
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: bpmLabel.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ChangeSongDelegate: UITableViewCell{
    func changeSongName(name:String, artist:String, bpm:String)
}

extension DetailViewController: YTPlayerViewDelegate {
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.black
    }
}
