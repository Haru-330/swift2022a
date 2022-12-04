//
//  BusTime.swift
//  swift2022a
//
//  Created by 似鳥　亜美 on 2022/11/06.
//

import Foundation

func BusTime(departure:String,arrival:String) -> (output_de_time:[String], output_ar_time:[String],keito:[String],ikisaki:[String],noriba:[String],oriba:[String],RTinfo:[(trip_id:[String],stop_sequence:[String])]){
    //departure→de,arrival→ar
    var de_stopid:[String]=[]//出発バス停のstop_id（バス停を表すid）
    var ar_stopid:[String]=[]//到着バス停のstop_id（バス停を表すid）
    
    var de_tripid:[String]=[]//出発バス停を通るtrip_id（便）
    var ar_tripid:[String]=[]//到着バス停を通るtrip_id（便）
    
    var tripid:[String]=[]//出発・到着バス停の両方を通るtrip_id（便）
    var tripidd:[String]=[]//出発→到着バス停の順番で通るtrip_id（便）
    var today_tripid:[String]=[]//今日の曜日のtrip_id（便）
    var output_tripid:[String]=[]//出力するtrip_id（便）
    var de_time:[String]=[]//出発バス停のarrival_time（到着時間）
    var ar_time:[String]=[]//到着バス停のarrival_time（到着時間）
    var output_de:[String]=[]
    var output_ar:[String]=[]
    var output_de_time:[String]=[]//出発バス停の到着時間を時間順にソートしたarrival_time（到着時間）
    var output_ar_time:[String]=[]//到着バス停の到着時間を時間順にソートしたarrival_time（到着時間）
    var de_info:[(arrival_time:String,trip_id:String,stop_id:String,stop_sequence:String,stop_headsign:String)]=[]//出発バス停のarrival_time,trip_id,stop_id,stop_headsignの情報が入っている
    var ar_info:[(arrival_time:String,trip_id:String,stop_id:String,stop_sequence:String,stop_headsign:String)]=[]//到着バス停のarrival_time,trip_id,stop_id,stop_headsignの情報が入っている
    var ikisaki:[String]=[]//行き先
    var keito:[String]=[]//系統
    var noriba:[String]=[]//乗り場
    var oriba:[String]=[]//降り場

    //出発・到着バス停名のstop_id(バス停を表すid)を探す
    de_stopid=stop_idSearch(input_stop:departure)
    ar_stopid=stop_idSearch(input_stop:arrival)
    
    //出発・到着バス停を通るそれぞれのtrip_id(便)を探す
    de_tripid=trip_idSearch(output_stop_id:de_stopid)
    ar_tripid=trip_idSearch(output_stop_id:ar_stopid)
    
    //出発・到着バス停の両方を通るtrip_id(便)を探す
    for i in de_tripid{
        for j in ar_tripid{
            if(i==j){
                tripid+=[j]
            }
        }
    }
    
    //出発→到着バス停の順番で通るtrip_id(便)を探す
    var m:Int=0
    var n:Int=0
    for stoptime in stoptimes{
        for tripid in tripid{
            if(stoptime.trip_id==tripid){
                for stopid in de_stopid{
                    if(stoptime.stop_id==stopid){
                        m=Int(stoptime.stop_sequence)!
                    }
                }
                for stopid in ar_stopid{
                    if(stoptime.stop_id==stopid){
                        n=Int(stoptime.stop_sequence)!
                    }
                }
                if(m>0 && n>0){
                    if(m<n){
                        tripidd+=[stoptime.trip_id]
                        m=0
                        n=0
                    }
                }
            }
        }
    }
    
    //今日の曜日のtrip_id(便)を探す
    today_tripid=trip_idToday(day:DAY_OF_WEEK)
    
    //今日のtrip_id(便)かつ出発→到着バス停を通るtrip_id(便)を探す
    for tripid in today_tripid{
        for tripidd in tripidd{
            if(tripid==tripidd){
                output_tripid+=[tripid]
            }
        }
    }

    //しぼったtrip_id(便)の出発・到着バス停それぞれの到着時刻を配列に格納
    var q:String=""
    var e:String=""
    /*
    for i in 0..<stoptimes.count{
        for tripid in output_tripid{
            if(stoptimes[i].trip_id==tripid){
                for stopid in de_stopid{
                    if(stoptimes[i].stop_id==stopid){
                        if(!(stoptimes[i].trip_id==q)){
                            de_time+=[stoptimes[i].arrival_time]
                            q=stoptimes[i].trip_id
                            de_info+=[(stoptimes[i].arrival_time,stoptimes[i].trip_id,stoptimes[i].stop_id,stoptimes[i].stop_sequence,stoptimes[i].stop_headsign)]
                        }
                    }
                }
                for stopid in ar_stopid{
                    if(stoptimes[i].stop_id==stopid){
                        if(!(stoptimes[i].trip_id==e)){
                            ar_time+=[stoptimes[i].arrival_time]
                            e=stoptimes[i].trip_id
                            ar_info+=[(stoptimes[i].arrival_time,stoptimes[i].trip_id,stoptimes[i].stop_id,stoptimes[i].stop_sequence,stoptimes[i].stop_headsign)]
                        }
                    }
                }
            }
        }
    }*/
    
    for i in stoptimes{
        for tripid in output_tripid{
            if(i.trip_id==tripid){
                for stopid in de_stopid{
                    if(i.stop_id==stopid){
                        if(!(i.trip_id==q)){
                            de_time+=[i.arrival_time]
                            q=i.trip_id
                            de_info+=[(i.arrival_time,i.trip_id,i.stop_id,i.stop_sequence,i.stop_headsign)]
                        }
                    }
                }
                for stopid in ar_stopid{
                    if(i.stop_id==stopid){
                        if(!(i.trip_id==e)){
                            ar_time+=[i.arrival_time]
                            e=i.trip_id
                            ar_info+=[(i.arrival_time,i.trip_id,i.stop_id,i.stop_sequence,i.stop_headsign)]
                        }
                    }
                }
            }
        }
    }
    
    de_info.remove(at: 0)
    ar_info.remove(at: 0)
        
    //de_info、ar_infoを時間順にソート
    var de:[(arrival_time:String,trip_id:String,stop_id:String,stop_sequence:String,stop_headsign:String)]=timeSort(date: de_info)
    var ar:[(arrival_time:String,trip_id:String,stop_id:String,stop_sequence:String,stop_headsign:String)]=timeSort(date: ar_info)
    
    
    
    var de_routeid:[String]=[]//出発バス停のrouteid
    for i in de{
        for trip in trips{
            if(trip.trip_id==i.trip_id){
                de_routeid+=[trip.route_id]
            }
        }
    }
    for routeid in de_routeid{
        for route in routes{
            if(route.route_id==routeid){
                keito+=[route.route_short_name]
            }
        }
    }
    
    //時間順にソートされた行き先を格納
    for i in de{
        let arr = i.stop_headsign.components(separatedBy: "(")
        ikisaki+=[arr[0]]
    }
    
    //時間順にソートされた乗り場、降り場を格納
    var noribaireru:[String]=[]
    for i in de{
        noribaireru+=[i.stop_id]
    }
    var oribaireru:[String]=[]
    for i in ar{
        oribaireru+=[i.stop_id]
    }

    noriba=noribaNamed(date: noribaireru)
    oriba=noribaNamed(date: oribaireru)
    
    for i in de{
        output_de+=[i.arrival_time]
    }
    for i in ar{
        output_ar+=[i.arrival_time]
    }
    output_de_time=secondDelete(time: output_de)
    output_ar_time=secondDelete(time: output_ar)

    //RT関連
    var trip_id:[String]=[]
    for i in de{
        trip_id+=[i.trip_id]
    }
    var stop_sequence:[String]=[]
    for i in de{
        stop_sequence+=[i.stop_sequence]
    }
    //RTで使う情報
    var RTinfo:[(trip_id:[String],stop_sequence:[String])] = [(trip_id,stop_sequence)]
    
    //出発・到着時刻の値を返す
    return (output_de_time,output_ar_time,keito,ikisaki,noriba,oriba,RTinfo)
    
}

/*
 関数名：totalTime
 引数：output_de_time,output_ar_time(型String,配列)
 返り値：totalTime(型String,配列)
 　　内容：出発時間から到着時間までの合計所要時間を求める
 */
func totalTime(output_de_time:[String],output_ar_time:[String])->(totalHour:[String],totalMin:[String]){
    //時間を入れる空の配列を用意
    var deHour:[Int] = []
    var arHour:[Int] = []
    //分を入れる空の配列を用意
    var deMin:[Int] = []
    var arMin:[Int] = []
    //文字列から時間を分で取得
    for output_de_time in output_de_time{
        deHour.append(Int(output_de_time.prefix(2).description)!*60)//分に直す
    }
    for output_ar_time in output_ar_time{
        arHour.append(Int(output_ar_time.prefix(2).description)!*60)//分に直す
    }
    //文字列から分を取得
    for output_de_time in output_de_time{
        deMin.append(Int(output_de_time.suffix(2).description)!)//分なのでそのまま取得
    }
    for output_ar_time in output_ar_time{
        arMin.append(Int(output_ar_time.suffix(2).description)!)//分なのでそのまま取得
    }
    //出発時間と到着時間の分のの合計を入れる配列
    var de_sum:[Int] = []
    var ar_sum:[Int] = []
    //出発時間の時間と分の合計（分）を求める
    for i in 0..<deHour.count {
        de_sum.append(deHour[i]+deMin[i])
    }
    //到着時間の時間と分の合計（分）を求める
    for i in 0..<arHour.count {
        ar_sum.append(arHour[i]+arMin[i])
    }
    //分で引き算＝所要時間が分で求められる
    var hiki:[Int] = []
    for i in 0..<ar_sum.count{
        hiki.append(ar_sum[i] - de_sum[i])
    }
    //所要時間の合計を求める
    var totalHour:[String] = []
    var totalMin:[String] = []
    for i in 0..<hiki.count{
        totalHour.append(String(hiki[i]/60))
        totalMin.append(String(hiki[i]%60))
    }
    //配列を返す
    return (totalHour,totalMin)
}

/*関数名：stop_idSearch
 引数：input_stop(型String)
 返り値：stop_id(型String)
 　　内容：stopsファイルから入力されたバス停名と同じstop_name(バス停名)のstop_id(バス停を表すid)を探す */

func stop_idSearch(input_stop:String) -> [String]{
    var stop_id:[String]=[]
    for stop in stops {
        if(stop.stop_name==input_stop){
            stop_id+=[stop.stop_id]
        }
    }
    return stop_id
}

/*関数名：trip_idSearch
 引数：output_stop_id(型[String])
 返り値：trip_id(型[String])
 　　内容：stop_id(バス停を表すid)を通るそれぞれのtrip_id(便)を探す */

func trip_idSearch(output_stop_id:[String]) -> [String]{
    var trip_id:[String]=[]
    for stoptime in stoptimes{
        for stop_id in output_stop_id{
            if(stoptime.stop_id==stop_id){
                trip_id+=[stoptime.trip_id]
            }
        }
    }
    return trip_id
}

/*関数名：getDayOfWeek
 引数：Date型
 返り値：(型Int)
 　　内容：その日が何曜日なのか取得する
 */
func getDayOfWeek(_ date : Date) -> Int{
    enum WeekDay: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
    let weekday = WeekDay(rawValue: Calendar.current.component(.weekday, from: date))!
    
    switch weekday {
    case .sunday:
        return 6
    case .monday:
        return 0
    case .tuesday:
        return 1
    case .wednesday:
        return 2
    case .thursday:
        return 3
    case .friday:
        return 4
    case .saturday:
        return 5
    }
}
/*関数名：trip_idToday
 引数：day(型Int)
 返り値：tripid_today(型[String])
 　　内容：各曜日のtrip_idを抽出して、該当する曜日のtrip_idを渡す
 */
func trip_idToday(day:Int) -> [String]{
    var serviceid_sunday:[String]=[]
    var serviceid_monday:[String]=[]
    var serviceid_tuesday:[String]=[]
    var serviceid_wednesday:[String]=[]
    var serviceid_thursday:[String]=[]
    var serviceid_friday:[String]=[]
    var serviceid_saturday:[String]=[]
    var serviceid_today:[String]=[]
    var tripid_today:[String]=[]
    
    for i in calendar1{
        if(Int(i.monday)==1){
            serviceid_monday+=[i.service_id]
        }
        if(Int(i.tuesday)==1){
            serviceid_tuesday+=[i.service_id]
        }
        if(Int(i.wednesday)==1){
            serviceid_wednesday+=[i.service_id]
        }
        if(Int(i.thursday)==1){
            serviceid_thursday+=[i.service_id]
        }
        if(Int(i.friday)==1){
            serviceid_friday+=[i.service_id]
        }
        if(Int(i.saturday)==1){
            serviceid_saturday+=[i.service_id]
        }
        if(Int(i.sunday)==1){
            serviceid_sunday+=[i.service_id]
        }
    }
    
    if(day==0){
        serviceid_today=serviceid_monday
    }
    if(day==1){
        serviceid_today=serviceid_tuesday
    }
    if(day==2){
        serviceid_today=serviceid_wednesday
    }
    if(day==3){
        serviceid_today=serviceid_thursday
    }
    if(day==4){
        serviceid_today=serviceid_friday
    }
    if(day==5){
        serviceid_today=serviceid_saturday
    }
    if(day==6){
        serviceid_today=serviceid_sunday
    }
    
    for i in trips{
        for l in serviceid_today{
            if(i.service_id==l){
                tripid_today+=[i.trip_id]
            }
        }
    }
    return tripid_today
}

/*関数名：secondDelete
 引数：time(型[String])
 返り値：hm(型[String])
 　　内容：時刻の秒を消去する
 */
func secondDelete(time:[String]) -> [String]{
    var hms=""
    var hm:[String]=[]
    
    for time in time{
        hms=time
        hm.append(String(hms.prefix(5)))
    }
    return hm
}

/*関数名：timeSort
    引数：date(型[[String]])
  返り値：timesorted(型[[String]])
　　内容：時刻を昇順に並べる関数
 */
func timeSort(date:[(arrival_time:String,trip_id:String,stop_id:String,stop_sequence:String,stop_headsign:String)]) -> [(arrival_time:String,trip_id:String,stop_id:String,stop_sequence:String,stop_headsign:String)]{
    var timesorted:[(arrival_time:String,trip_id:String,stop_id:String,stop_sequence:String,stop_headsign:String)] = []
    timesorted = date.sorted { $0.arrival_time < $1.arrival_time}
    return timesorted
}

/*関数名：noribaNamed
    引数：date(型[[String]])
  返り値：noriba(型[String])
　　内容：stopsからstop_idに対応する乗り場名(stop_desc)を探す
 */
func noribaNamed(date:[String]) -> [String]{
    var noriba:[String]=[]
    
    for i in 0..<date.count{
        for stop in stops{
            if(stop.stop_id==date[i]){
                noriba+=[stop.stop_desc]
            }
        }
    }
    return noriba
}
