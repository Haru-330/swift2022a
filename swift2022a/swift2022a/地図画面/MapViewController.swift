//
//  MapViewController.swift
//  swift2022a
//
//  Created by 児玉拓海 on 2022/11/24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    //地図のインスタンス
    @IBOutlet weak var mapView: MKMapView!
    //地図上のテキストフィールドのインスタンス
    @IBOutlet weak var mapTextField: UITextField!
    
    //バス停名と座標を格納する変数
    var BusStopPosition: [(BusStopNames:String, lat:String, lon:String)]=[]
    var checkNum = 0
    var backNum = 0
    var inDeparture = ""
    var inArrival = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapTextField.delegate = self
        mapView.delegate = self
        
        //地図の開始地点の設定
        let center = CLLocationCoordinate2DMake(41.786520, 140.744559) //函館中央辺り
        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015) //表示範囲
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        mapTextField.frame.size.height = 50
        
        //バス停名と緯度経度を格納
        for stop in stops {
            BusStopPosition += [(stop.stop_name, stop.stop_lat, stop.stop_lon)]
        }
        //マップにバス停をプロットする
        for Inf in BusStopPosition {
            PlotBusStop(busname: Inf.BusStopNames, ido: Inf.lat, keido: Inf.lon)
        }
    }
    //ピンをプロットする関数
    func PlotBusStop(busname:String, ido:String, keido:String){
        let lat = Double(ido)
        let lon = Double(keido)
        let busName = busname
        let coordnate = CLLocationCoordinate2DMake(lat!, lon!)
        //ピンの生成
        let pin = MKPointAnnotation()
        pin.title = busName
        pin.coordinate = coordnate
        mapView.addAnnotation(pin)
        mapView.delegate = self
    }
    
    //ピンの設定
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation.title == inArrival {
            annotationView.markerTintColor = UIColor(hex: "dc143c")
        } else if annotation.title == inDeparture {
            annotationView.markerTintColor = UIColor(hex: "dc143c")
        } else {
            annotationView.markerTintColor = UIColor(hex: "3F6AB2")
        }
        return annotationView
    }
    
    //ピンがタップされた時の処理
    func mapView(_ mapView:MKMapView, didSelect view:MKAnnotationView) {
        if let annotation = view.annotation{
            //画面遷移
            let storyboard = UIStoryboard(name: "didSelect", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "viewdidSelect") as! didSelectViewController
            nextVC.busname = annotation.title!!
            nextVC.ADcheckNum = checkNum
            nextVC.presentationController?.delegate = self
            self.present(nextVC, animated: true, completion: nil)
        } else {
            print("no")
        }
    }
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension MapViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        for annotation in self.mapView.selectedAnnotations {
            self.mapView.deselectAnnotation(annotation, animated: true)
        }
    }
}
