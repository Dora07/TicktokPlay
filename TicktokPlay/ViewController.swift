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
    //隨機播放按鈕
    @IBOutlet weak var ShuffleButton: UIButton!
    //重複播放循環按鈕
    @IBOutlet weak var RepeatButton: UIButton!
    //歌詞播放按鈕
    @IBOutlet weak var WordsButton: UIButton!
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
        //隨機播放
        PlayList.shuffle()
        //  播放音樂
        PlaySong()
        
        
  
    
    }
    
    //播放音樂
    func PlaySong()
    {
        if index < PlayList.count
        {
            if index < 0
            {
                index = PlayList.count - 1
            }
            let album = PlayList[index]
            CurrectSong = album
            if album != nil
            {
                let SongName:String = album.Name
                let SingerName:String = album.Singer
                let ImageName :String = album.AlbumImage
                
                //  設定歌手歌曲Label顯示
                self.SongLabel.text = SongName
                self.SingerLabel.text = SingerName
                
                //  設定Image圖片顯示
                AlbumImage.image = UIImage(named: ImageName)
                
                //  載入歌曲檔案
            let FileUrl = Bundle.main.url(forResource: SongName, withExtension: "mp4")!
                let PlayerItem = AVPlayerItem(url: FileUrl)
               player.replaceCurrentItem(with: PlayerItem)
                player.volume = 0.7
               looper = AVPlayerLooper(player: player, templateItem: PlayerItem)
                
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
            else
            {
             index = 0
            }
            
            
        }
    }
   
    //  播放/暫停
    @IBAction func PlayActionButton(_ sender: UIButton)
    {
        let ImageName = PlayButton.imageView?.image
        if ImageName == PlayItem
        {
            if player.rate == 0
            {
                player.play()
                PlayButton.setImage(PauseItem, for: UIControl.State.normal)
            }
            else if ImageName == PauseItem
            {
                if player.rate == 1
                {
                    player.pause()
                    PlayButton.setImage(PlayItem, for: UIControl.State.normal)
                   
                }
                
            }
        }
    }
    //播放下一首
    @IBAction func NextSongAction(_ sender: UIButton)
    {
        index = index  + 1
        PlaySong()
    }
    
    
    @IBAction func BackButtonAction(_ sender: UIButton)
    {
        index = index  - 1
        PlaySong()
    }
    
    
    
    
}

