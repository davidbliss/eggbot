﻿package{		import com.davidbliss.eb.Canvas;	import com.davidbliss.images.FXImage;		import flash.display.Sprite;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;		public class HalftoneImage extends Sprite	{		private var image:FXImage;		private var canvas:Canvas;		public function HalftoneImage()		{				stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;						// draw square to test stage 			var sq:Sprite = new Sprite();			sq.graphics.beginFill( 0xdddddd , 1 );			sq.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);			addChild(sq);						// create canvas			canvas = new Canvas(false);			canvas.x=canvas.y=5;			addChild(canvas);						image = new FXImage("http://l.yimg.com/g/images/home_photo_notsogoodphotography.jpg");			// TO FIT ON AN EGG (1.5 width scale) YOU SHOULD HAVE AN IMAGE 533x150 PIXELS (OR SIMILAR RATIO)			image.load();			image.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);			image.x = 5;			image.y = 600/4+10;			addChild(image);		}				private function imageLoaded(e:Event):void{						trace("EGGBOT: image loaded");			var numCellsVert:Number=30; // 20x20 squares 			var gridSize:Number=20;			image.pixelate(numCellsVert);							var oheight:Number = image.height;			image.height = 600/4;			image.width = image.width * (image.height/oheight);						var dotArray:Array = image.getDotArray();						for (var i:Number=0; i<dotArray.length; i++){				canvas.DrawFilledCircle(gridSize/2+(dotArray[i].x*gridSize), gridSize/2+(dotArray[i].y*gridSize), Math.round((1.0-dotArray[i].l)*8), 10);			}						canvas.movePen(0,300);		}	}}