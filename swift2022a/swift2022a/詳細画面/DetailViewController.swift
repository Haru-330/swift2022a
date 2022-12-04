//
//  DetailViewController.swift
//  swift2022a
//
//  Created by 涌井春那 on 2022/11/13.
//

import UIKit

class DetailViewController: UIViewController {
    // 乗り換えあるなし共通
    @IBOutlet weak var Modoru: UIImageView! //戻るボタン
    @IBOutlet weak var Home: UIImageView! //ホームボタン
    @IBOutlet weak var BusTotalPrice: UILabel!      // バスの合計料金
    @IBOutlet weak var TotalReTime: UILabel!        // バスの合計所要時間
    @IBOutlet weak var BusTransferNum: UILabel!     // バスの乗換回数
    @IBOutlet weak var dateLabel: UILabel! //日にち
    @IBOutlet weak var keiroLabel: UILabel! //経路情報
    // 乗り換えなしの場合
    @IBOutlet weak var StartBusStopName: UILabel!   // 出発バス停名
    @IBOutlet weak var ArrivalBusStopName: UILabel! // 到着バス停名
    @IBOutlet weak var StartBusTime: UILabel!       // 出発時間
    @IBOutlet weak var ArrivalBusTime: UILabel!     // 到着時間
    @IBOutlet weak var ArivalPlatformName: UILabel! // おりば
    @IBOutlet weak var DeparturePlatFormName: UILabel! //のりば
    @IBOutlet weak var BusLineage: UILabel!         // 系統
    @IBOutlet weak var BusDestination: UILabel!     // バスの行き先
    @IBOutlet weak var BusPrice: UILabel!           // バスの料金
    @IBOutlet weak var BusPredict: UILabel! //「つ前のバス停を出発」
    var DepartureObi = UIView() //出発時間用の帯
    var ArrivalObi = UIView() //到着時間用の帯
    var KeiroInfoView = UIView() // 経路情報が表示されるバックグラウンドView
    var BusInfoView = UIView()  //バスの情報（系統、行先、金額、いつ出発か？）のバックグラウンドView
    // 乗り換えある場合
    var DepartureTransferObi = UIView() // 乗り換えある場合の出発時間用の帯
    var ArrivalTransferObi = UIView() //　乗り換えある場合の到着時間用の帯
    var TransferTimeView = UIView() // 乗り換えある場合の乗り換え時間の帯
    var BusInfoTransferView = UIView()  // 乗り換えある場合のバスの情報（系統、行先、金額、いつ出発か？）のバックグラウンドView
    var StartTransferBusStopName = UILabel()   // 乗り換えある場合の出発バス停名
    var ArrivalTransferBusStopName = UILabel() // 乗り換えある場合の到着バス停名
    var TransferTime = UILabel() // 乗り換え時間
    var StartTransferBusTime = UILabel()       // 乗り換えある場合の出発時間
    var ArrivalTransferBusTime = UILabel()     // 乗り換えある場合の到着時間
    var ArivalTransferPlatformName = UILabel() // 乗り換えある場合のおりば
    var DepartureTransferPlatFormName = UILabel() //乗り換えある場合ののりば
    var TransferBusLineage = UILabel()         // 乗り換えある場合の系統
    var TransferBusDestination = UILabel()    // 乗り換えある場合のバスの行き先
    var TransferBusPrice = UILabel()          // 乗り換えある場合のバスの料金
    var TransferBusPredict = UILabel() // 乗り換えある場合の「つ前のバス停を出発」
    
    // Homeから受け取る用の変数
    var startStr = ""       // 出発バス停受け取り
    var arrStr = ""         // 到着バス停受け取り
    var startTime = ""      // 出発時間受け取り
    var arrTime = ""        // 到着時間受け取り
    var reTimeHour = ""     // 合計所要時間（時間）受け取り
    var reTimeMin = ""      // 合計所要時間（分）受け取り
    var busDes = ""         // 行き先受け取り
    var busLine = ""        // 系統受け取り
    var oPlatformName = ""  // 乗り場受け取り
    var nPlatformName = ""  // 降り場受け取り
    var dateString = "" //日にち受け取り
    
    //スクリーンの幅
    let screenWidth = Int(UIScreen.main.bounds.size.width)
    //スクリーンの高さ
    let screenHeight = Int(UIScreen.main.bounds.size.height)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //　スクリーンの幅
        let screenWidth = Int(UIScreen.main.bounds.size.width)
        //　乗り換えあるなし共通
        //　戻るの場所設定
        Modoru.isUserInteractionEnabled = true
        Modoru.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ModoruViewTapped(_:))))
        Modoru.frame = CGRect(x:15, y:70,
                              width:70, height:50)
        Home.isUserInteractionEnabled = true
        Home.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeViewTapped(_:))))
        //　Homeの場所設定
        Home.frame = CGRect(x:screenWidth - 85, y:70,
                              width:70, height:50)
        // ラベルの位置とサイズを設定
        keiroLabel.frame = CGRect(x:0, y:120, width:screenWidth, height:30)
        // 文字を中央にalignする
        keiroLabel.textAlignment = NSTextAlignment.center
        // ラベルの文字サイズを設定
        keiroLabel.font = UIFont(name:"ヒラギノ角ゴシック W3", size: 20)
        // viewにラベルを追加
        self.view.addSubview(keiroLabel)
        // 日にちを受け取る
        dateLabel.text = dateString
        // テキストの色
        dateLabel.textColor = UIColor.black
        // ラベルの位置とサイズを設定
        dateLabel.frame = CGRect(x:0, y:90, width:screenWidth, height:30)
        // 文字を中央にalignする
        dateLabel.textAlignment = NSTextAlignment.center
        // ラベルの文字サイズを設定
        dateLabel.font = UIFont(name:"ヒラギノ角ゴシック W3", size: 16)
        // viewにラベルを追加
        self.view.addSubview(dateLabel)
        // 経路情報 乗り換えあるなし共通
        KeiroInfoView.frame = CGRect(x: 0, y: 158,width: screenWidth, height: 110)
        KeiroInfoView.backgroundColor = .white
        self.view.addSubview(KeiroInfoView)
        BusTotalPrice.frame = CGRect(x: 28, y: 45,width: screenWidth-28, height: 30)
        BusTotalPrice.textAlignment = NSTextAlignment.left
        BusTotalPrice.textColor = .black
        TotalReTime.frame = CGRect(x: 28, y: 74,width: screenWidth-28, height: 30)
        TotalReTime.textAlignment = NSTextAlignment.left
        TotalReTime.textColor = .black
        BusTransferNum.frame = CGRect(x: 28, y: 16,width: screenWidth-28, height: 30)
        BusTransferNum.textAlignment = NSTextAlignment.left
        BusTransferNum.textColor = .black
        KeiroInfoView.addSubview(BusTransferNum)
        KeiroInfoView.addSubview(BusTotalPrice)
        KeiroInfoView.addSubview(TotalReTime)
        // 乗り換えなしの時
        DepartureObi.frame = CGRect(x:0, y:268, width:screenWidth, height:48)
        DepartureObi.backgroundColor = UIColor(hex:"3F6AB2")
        self.view.addSubview(DepartureObi)
        BusInfoView.frame = CGRect(x: 0, y: 313,width: screenWidth, height: 133)
        BusInfoView.backgroundColor = .white
        self.view.addSubview(BusInfoView)
        ArrivalObi.frame = CGRect(x:0, y:446, width:screenWidth, height:48)
        ArrivalObi.backgroundColor = UIColor(hex:"3F6AB2")
        self.view.addSubview(ArrivalObi)
        StartBusTime.frame = CGRect(x:21, y:0, width:50, height:48)
        StartBusTime.textAlignment = NSTextAlignment.left
        StartBusTime.textColor = .white
        ArrivalBusTime.frame = CGRect(x:21,y:0,width:50,height: 48)
        ArrivalBusTime.textAlignment = NSTextAlignment.left
        ArrivalBusTime.textColor = .white
        StartBusStopName.frame = CGRect(x:75, y:0, width:148, height:48)
        StartBusStopName.textAlignment = NSTextAlignment.left
        StartBusStopName.textColor = .white
        ArrivalBusStopName.frame = CGRect(x:75, y:0, width:148, height:48)
        ArrivalBusStopName.textAlignment = NSTextAlignment.left
        ArrivalBusStopName.textColor = .white
        DepartureObi.addSubview(StartBusTime)
        DepartureObi.addSubview(StartBusStopName)
        ArrivalObi.addSubview(ArrivalBusTime)
        ArrivalObi.addSubview(ArrivalBusStopName)
        BusInfoView.drawLine(start: CGPoint(x:27,y:0), end: CGPoint(x:27,y:135), color: UIColor(hex:"5A7FBB"), weight: 5, rounded: false)
        BusDestination.frame = CGRect(x: 40, y: 12,width: screenWidth-40, height: 30)
        BusDestination.textAlignment = NSTextAlignment.left
        BusDestination.textColor = .black
        BusLineage.frame = CGRect(x: 40, y: 41,width: screenWidth-40, height: 30)
        BusLineage.textAlignment = NSTextAlignment.left
        BusLineage.textColor = .black
        BusPrice.frame = CGRect(x: 40, y: 70,width: screenWidth-40, height: 30)
        BusPrice.textAlignment = NSTextAlignment.left
        BusPrice.textColor = .black
        BusPredict.frame = CGRect(x: 40, y: 99,width: screenWidth-40, height: 30)
        BusPredict.textAlignment = NSTextAlignment.left
        BusPredict.textColor = .black
        BusInfoView.addSubview(BusDestination)
        BusInfoView.addSubview(BusLineage)
        BusInfoView.addSubview(BusPrice)
        BusInfoView.addSubview(BusPredict)
        DeparturePlatFormName.frame = CGRect(x:160, y:0, width:screenWidth-160, height:48)
        DeparturePlatFormName.textAlignment = NSTextAlignment.left
        DeparturePlatFormName.textColor = .white
        DepartureObi.addSubview(DeparturePlatFormName)
        ArivalPlatformName.frame = CGRect(x: 160, y: 0,width: screenWidth-150, height: 48)
        ArivalPlatformName.textAlignment = NSTextAlignment.left
        ArivalPlatformName.textColor = .white
        ArrivalObi.addSubview(ArivalPlatformName)
        /*// 乗り換えある場合
        DepartureTransferObi.frame = CGRect(x:0, y:543, width:screenWidth, height:48)
        DepartureTransferObi.backgroundColor = UIColor(hex:"3F6AB2")
        self.view.addSubview(DepartureTransferObi)
        BusInfoTransferView.frame = CGRect(x: 0, y: 543+48,width: screenWidth, height: 133)
        BusInfoTransferView.backgroundColor = .white
        self.view.addSubview(BusInfoTransferView)
        ArrivalTransferObi.frame = CGRect(x:0, y:543+48+133, width:screenWidth, height:48)
        ArrivalTransferObi.backgroundColor = UIColor(hex:"3F6AB2")
        self.view.addSubview(ArrivalTransferObi)
        TransferTimeView.frame = CGRect(x:0, y:494, width:screenWidth, height:48)
        TransferTimeView.backgroundColor = .white
        self.view.addSubview(TransferTimeView)
        let drawView = DrawView(frame: self.view.bounds)
        TransferTimeView.addSubview(drawView)
        TransferTime.frame = CGRect(x:40, y:0, width:screenWidth-21, height:48)
        TransferTime.textAlignment = NSTextAlignment.left
        TransferTime.textColor = .black
        TransferTimeView.addSubview(TransferTime)
        StartTransferBusTime.frame = CGRect(x:21, y:0, width:50, height:48)
        StartTransferBusTime.textAlignment = NSTextAlignment.left
        StartTransferBusTime.textColor = .white
        ArrivalTransferBusTime.frame = CGRect(x:21,y:0,width:50,height: 48)
        ArrivalTransferBusTime.textAlignment = NSTextAlignment.left
        ArrivalTransferBusTime.textColor = .white
        StartTransferBusStopName.frame = CGRect(x:75, y:0, width:148, height:48)
        StartTransferBusStopName.textAlignment = NSTextAlignment.left
        StartTransferBusStopName.textColor = .white
        ArrivalTransferBusStopName.frame = CGRect(x:75, y:0, width:148, height:48)
        ArrivalTransferBusStopName.textAlignment = NSTextAlignment.left
        ArrivalTransferBusStopName.textColor = .white
        DepartureTransferObi.addSubview(StartTransferBusTime)
        DepartureTransferObi.addSubview(StartTransferBusStopName)
        ArrivalTransferObi.addSubview(ArrivalTransferBusTime)
        ArrivalTransferObi.addSubview(ArrivalTransferBusStopName)
        BusInfoTransferView.drawLine(start: CGPoint(x:27,y:0), end: CGPoint(x:27,y:133), color: UIColor(hex:"5A7FBB"), weight: 5, rounded: false)
        TransferBusDestination.frame = CGRect(x: 40, y: 12,width: screenWidth-40, height: 30)
        TransferBusDestination.textAlignment = NSTextAlignment.left
        TransferBusDestination.textColor = .black
        TransferBusLineage.frame = CGRect(x: 40, y: 41,width: screenWidth-40, height: 30)
        TransferBusLineage.textAlignment = NSTextAlignment.left
        TransferBusLineage.textColor = .black
        TransferBusPrice.frame = CGRect(x: 40, y: 70,width: screenWidth-40, height: 30)
        TransferBusPrice.textAlignment = NSTextAlignment.left
        TransferBusPrice.textColor = .black
        TransferBusPredict.frame = CGRect(x: 40, y: 99,width: screenWidth-40, height: 30)
        TransferBusPredict.textAlignment = NSTextAlignment.left
        TransferBusPredict.textColor = .black
        BusInfoTransferView.addSubview(TransferBusDestination)
        BusInfoTransferView.addSubview(TransferBusLineage)
        BusInfoTransferView.addSubview(TransferBusPrice)
        BusInfoTransferView.addSubview(TransferBusPredict)
        DepartureTransferPlatFormName.frame = CGRect(x:160, y:0, width:screenWidth-160, height:48)
        DepartureTransferPlatFormName.textAlignment = NSTextAlignment.left
        DepartureTransferPlatFormName.textColor = .white
        DepartureTransferObi.addSubview(DepartureTransferPlatFormName)
        ArivalTransferPlatformName.frame = CGRect(x: 160, y: 0,width: screenWidth-150, height: 48)
        ArivalTransferPlatformName.textAlignment = NSTextAlignment.left
        ArivalTransferPlatformName.textColor = .white
        ArrivalTransferObi.addSubview(ArivalTransferPlatformName)
         */
        // 乗り換えある場合ここまで
        // あるなし共通
        BusTotalPrice.text = "料金：" // 合計料金ラベルのtextを設定
        if reTimeHour == "0" {
            TotalReTime.text = "所要時間" + reTimeMin + "分" // 合計所要時間ラベルのtextを設定（分のみ）
        } else {
            TotalReTime.text = "所要時間" + reTimeHour + "時間" + reTimeMin + "分" // 合計所要時間ラベルのtextを設定（時間＆分）
        }
        BusTransferNum.text = "乗換："     // バス乗り換え回数ラベルのtextを設定
        // 乗り換えない場合のテキストの設定
        StartBusStopName.text = startStr // 出発バス停名ラベルのtextを設定
        ArrivalBusStopName.text = arrStr // 到着バス停名ラベルのtextを設定
        StartBusTime.text = startTime    // 出発時刻ラベルのtextを設定
        ArrivalBusTime.text = arrTime    // 到着時刻ラベルのtextを設定
        DeparturePlatFormName.text = nPlatformName //のりばラベルのtextを設定
        ArivalPlatformName.text = oPlatformName           // おりばラベルのtextを設定
        BusLineage.text = busLine        // 系統ラベルのtextを設定
        BusDestination.text = busDes + " 行き"     // 行き先ラベルのtextを設定
        BusPrice.text = "料金"      // 料金ラベルのtextを設定
        // 乗り換えない場合のテキストの設定
        TransferTime.text = "乗換時間：" //乗り換え時間のtextを設定
        StartTransferBusStopName.text = "出発バス停" // 出発バス停名ラベルのtextを設定
        ArrivalTransferBusStopName.text = "到着バス停" // 到着バス停名ラベルのtextを設定
        StartTransferBusTime.text = "00:00"  // 出発時刻ラベルのtextを設定
        ArrivalTransferBusTime.text = "00:00"    // 到着時刻ラベルのtextを設定
        DepartureTransferPlatFormName.text = "乗り場" // のりばラベルのtextを設定
        ArivalTransferPlatformName.text = "降り場"           // おりばラベルのtextを設定
        TransferBusPredict.text = "つ前のバス停を出発" // 出発情報の予測のtextを設定
        TransferBusLineage.text = "系統"        // 系統ラベルのtextを設定
        TransferBusDestination.text = "行き"     // 行き先ラベルのtextを設定
        TransferBusPrice.text = "料金"      // 料金ラベルのtextを設定
        
    }
    @objc func ModoruViewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    @objc func HomeViewTapped(_ sender: UITapGestureRecognizer) {
        // storyboardのインスタンス取得（別のstoryboardの場合）
        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        // ②遷移先ViewControllerのインスタンス取得
        let nextView = storyboard.instantiateViewController(withIdentifier: "viewHome") as! HomeViewController
        nextView.modalPresentationStyle = .fullScreen
        // ③画面遷移
        self.present(nextView, animated: false, completion: nil)
    }
}
/*ラインを描くための拡張クラス*/
class BezierView: UIView {

    var start: CGPoint = .zero
    var end: CGPoint = .zero
    var weight: CGFloat = 2.0
    var color: UIColor = .gray
    var isRounded: Bool = true
    //var dashes: [CGFloat] = [.zero,.zero]

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let line = UIBezierPath()
        line.move(to: start)
        line.addLine(to: end)
        line.close()
        color.setStroke()
        line.lineWidth = weight
        //line.setLineDash(dashes,count: dashes.count, phase: 0)
        line.lineCapStyle = isRounded ? .round : .square
        line.stroke()
        self.isUserInteractionEnabled = false
    }
}
/*ラインのためのUIViewの拡張*/
extension UIView {
    func drawLine(start: CGPoint, end: CGPoint, color: UIColor, weight: CGFloat, rounded: Bool) {
        let line: BezierView = BezierView(frame: CGRect(x: 0, y: 0, width: max(start.x , end.x)+weight, height: max(start.y, end.y)+weight))
        line.start = start
        line.end = end
        line.color = color
        line.weight = weight
        line.isRounded = rounded
        //line.setLineDash(dashes,count: dashes.count, phase: 0)
        self.addSubview(line)
    }
    func drawLine(points: [CGPoint], color: UIColor, weight: CGFloat, rounded: Bool) {
        guard points.count >= 2 else { fatalError("Line is not drawable because points are less than 2") }
        for i in 0..<points.count-1 {
            self.drawLine(start: points[i], end: points[i+1], color: color, weight: weight, rounded: rounded)
        }
    }
}
/*ドットラインを描くための拡張クラス*/
class DrawView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // 線
        let line = UIBezierPath()
        // 最初の位置
        line.move(to: CGPoint(x: 27, y: 0))
        // 次の位置
        line.addLine(to:CGPoint(x: 27, y: 48))
        // 終わる
        line.close()
        // 線の色
        UIColor(hex:"3F6AB2").setStroke()
        // 線の太さ
        line.lineWidth = 5.0
        // 点線の大きさ, 点線の隙間
        let dashes : [CGFloat] = [3, 6]
        // 第一引数 点線の大きさ(数値*2になる), 点線の間隔（間隔-大きさになる）
        // 第二引数 第一引数で指定した配列の要素数
        // 第三引数 開始位置
        line.setLineDash(dashes, count: dashes.count, phase: 0)
        // 線を塗りつぶす
        line.stroke()
        
    }
}
