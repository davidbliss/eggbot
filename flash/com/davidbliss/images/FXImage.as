﻿package com.davidbliss.images{	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Loader;	import flash.display.MovieClip;	import flash.events.Event;	import flash.geom.Matrix;	import flash.net.URLRequest;		public class FXImage extends MovieClip {		public var loader:Loader;		private var url:String;		private var bitmapData:BitmapData 				public function FXImage(u:String) {			trace("gonna load:"+u);			url = u			loader = new Loader() ; 		}				public function load():void{ 			loader.load(new URLRequest(url));			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);		}				private function imageLoaded(e:Event):void{			trace("FXIMAGE: image loaded");		}				public function pixelate(numCellsVert:Number):void{			var numCellsHorz:Number = numCellsVert*loader.width/loader.height;						bitmapData = new BitmapData( numCellsHorz, numCellsVert, false );			var bitmap:Bitmap = new  Bitmap(bitmapData);						addChild(bitmap);			var scaleMatrix:Matrix = new Matrix();			scaleMatrix.scale(1/(loader.height/numCellsVert), numCellsVert/loader.height);						bitmapData.draw( loader, scaleMatrix );		}						public function getDotArray():Array{			var dotArray:Array = new Array();			// now we can go through and draw circles			for(var i:Number=0; i<bitmapData.width; i++){				for(var ii:Number=0; ii<bitmapData.height; ii++){					//image.					var l:Number = (luminance(bitmapData.getPixel(i, ii)))/256;					var o:Object = new Object;					o.x=i;					o.y=ii;					o.l=l;					dotArray.push(o);				}			}			return dotArray;		}				private function luminance(myRGB:int):int {			//returns a luminance value between 0 and 255			var R:int = (myRGB / 65536) % 256;			var G:int = (myRGB / 256) % 256;			var B:int = myRGB % 256;			return ((0.3*R)+(0.59*G)+(0.11*B));		}	}}