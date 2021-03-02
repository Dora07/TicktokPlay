import UIKit
//播放音樂的 AVFoundation 物件。
import AVFoundation
//多媒體播放
import MediaPlayer
class ViewController: UIViewController
{
     //專輯照片
    @IBOutlet weak var AlbumImage: UIImageView!
    //歌曲
    @IBOutlet weak var SongLabel: UILabel!
    //歌手
    @IBOutlet weak var SingerLabel: UILabel!
    //Slider
    @IBOutlet weak var SongSlider: UISlider!
    //播放/暫停按鈕
    @IBOutlet weak var PlayButton: UIButton!
    //播放
    let PlayItem = UIImage(systemName:"play.fill")
    //暫停
    let PauseItem = UIImage(systemName:"pause.fill")
    
    //下一首按鈕
    @IBOutlet weak var NextButton: UIButton!
    //前一首按鈕
    @IBOutlet weak var BackButton: UIButton!
    //目前播放秒數
    @IBOutlet weak var NowPlayingLabel: UILabel!
    //總共秒數
    @IBOutlet weak var AllPlayingLabel: UILabel!
    
    //新增SongListSwift檔案
    //播放清單
    var PlayList : [SongList]! = [SongList]()
    var index = 0
    var CurrectSong:SongList?
    //音樂播放
    let player = AVQueuePlayer()
    //音樂循環播放
    var looper: AVPlayerLooper?
    
    
    
    //  表單載入
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //調整系統的音量
        let volumeView = MPVolumeView(frame: CGRect(x: 10, y: 100, width: 300, height: 40))
        view.addSubview(volumeView)
        
        //  音樂資料庫
        PlayList.append(SongList(Name:"千千萬萬",Singer:"深海魚子醬",AlbumImage:"千千萬萬"))
        PlayList.append(SongList(Name:"清空", Singer:"王忻辰_蘇星婕", AlbumImage:"清空"))
        PlayList.append(SongList(Name:"錯位時空", Singer:"艾辰", AlbumImage:"錯位時空"))
        PlayList.append(SongList(Name:"星辰大海", Singer:"黃霄雲", AlbumImage:"星辰大海"))
       
     
        //  播放音樂
        PlaySong()
        //執行現在播放的秒數
        CurrentTime()
  
        
        //  播完後，繼續播下一首
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
         
            self.index = self.index - 1
            self.PlaySong()
           
            }
        
    }
 
    
    
    
    //播放音樂
    func PlaySong()
    {
        if index < PlayList.count
        {
            if index  < 0
            {
                index = PlayList.count - 1
       
            }
            let AlbumObj = PlayList[index]
            CurrectSong = AlbumObj
            if AlbumObj != nil
            {
                let SongName:String = AlbumObj.Name
                let SingerName:String = AlbumObj.Singer
                let ImageName :String = AlbumObj.AlbumImage
                
                //  設定歌手歌曲Label顯示
                self.SongLabel.text = SongName
                self.SingerLabel.text = SingerName
                
                //  設定Image圖片顯示
                AlbumImage.image = UIImage(named: ImageName)
                
                //  載入歌曲檔案
            let FileUrl = Bundle.main.url(forResource: SongName, withExtension: "mp4")!
                let PlayerItem = AVPlayerItem(url: FileUrl)
               player.replaceCurrentItem(with: PlayerItem)
                player.volume = 0.5
               looper = AVPlayerLooper(player: player, templateItem: PlayerItem)
                
                
                //總時間顯示
                let duration = CMTimeGetSeconds(PlayerItem.asset.duration)
                        AllPlayingLabel.text = formatConversion(time: duration)
                
                
                //  重置slider和播放軌道
                SongSlider.setValue(Float(0), animated: true)
                let TargetTime:CMTime = CMTimeMake(value: Int64(0), timescale: 1)
                player.seek(to: TargetTime)
                
                
                //  播放
                player.play()
                
                //  更新slider時間
               let Duration :CMTime = PlayerItem.asset.duration
              let Seconds:Float64 = CMTimeGetSeconds(Duration)
                SongSlider.minimumValue = 0
                SongSlider.maximumValue = Float(Seconds)
                
                
                //  設定播放按鈕圖案
                PlayButton.setImage(PauseItem, for: UIControl.State.normal)
                
                
                
                }
        }else{
             index = 0
            }
            
            
        
    }
   
    //  播放/暫停
    @IBAction func PlayActionButton(_ sender: UIButton)
    {
            if player.rate == 0
            {
                player.play()
                PlayButton.setImage(PauseItem, for: UIControl.State.normal)
            }
         else
            {
                
                    player.pause()
                    PlayButton.setImage(PlayItem, for: UIControl.State.normal)
                   
                }
                
            
        
    }
    //播放下一首
    @IBAction func NextSongAction(_ sender: UIButton)
    {
        index -= 1
        PlaySong()
        print(index)
      
    }
    
    //播放前一首
    //因為index = PlayList.count - 1 所以不用動
    @IBAction func BackButtonAction(_ sender: UIButton)
    {
     
        PlaySong()
        print(index)
          
        
    }

    
    
    
    
    
    
    
    //  拖曳slider進度，要設定player播放軌道
    @IBAction func SongSliderAction(_ sender: UISlider)
    {  //  slider移動的位置
        let Seconds : Int64 = Int64(SongSlider.value)
        //  計算秒數
        let TargetTime :CMTime = CMTimeMake(value: Seconds, timescale: 1)
        //  設定player播放進度
        player.seek(to: TargetTime)
        
    
        //  如果player暫停，則繼續播放
        if player.rate == 0
        {
            player.play()
           PlayButton.setImage(PauseItem, for: UIControl.State.normal)
        }
    
        
    }
    //現在播放的秒數
    func CurrentTime() {
          player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime) in
                  if self.player.currentItem?.status == .readyToPlay {
                      let currentTime = CMTimeGetSeconds(self.player.currentTime())
                    //讓Slider跟著連動
                    self.SongSlider.value = Float(currentTime)
                    //文字更改
                    self.NowPlayingLabel.text = self.formatConversion(time: currentTime)
                  }
              })
          }
    //把秒數轉換成幾分幾秒的格式，最後輸出成一個 String 直接顯示在 Label 上
    func formatConversion(time:Float64) -> String {
        let songLength = Int(time)
        let minutes = Int(songLength / 60) // 求 songLength 的商，為分鐘數
        let seconds = Int(songLength % 60) // 求 songLength 的餘數，為秒數
        var time = ""
        if minutes < 10 {
          time = "0\(minutes):"
        } else {
          time = "\(minutes)"
        }
        if seconds < 10 {
          time += "0\(seconds)"
        } else {
          time += "\(seconds)"
        }
        return time
    }
    
  
        
    
        
    }
    
    
    
    
    
    
    
    
    
    

