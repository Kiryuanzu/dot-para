// ライブラリを読み込み（よくわからなかったらとりあえずそのままにしておいてください）
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// ゲームシステム用変数（よくわからなかったらとりあえずそのままにしておいてください）
// キーボード入力管理用のKeyboardManager
KeyboardManager keyman;
// フォント（環境によって違ったらヤバそうなので一応スケッチに付属させたVLゴシックを使うことにしている）
PFont font;

// Minimライブラリ用の変数
Minim minim;
// ゲームシステム用変数ここまで


// 以下にグローバル変数を宣言します
PImage PlayerImageNormal;
PImage PlayerImageLike;
PImage PlayerImageUnlike;
PImage LikeImage;
PImage UnlikeImage;
PImage TitleLogoImage;
int updownimage = 100;
int leftrightimage = 100;
int PlayerWidth = 128;
int LikeWidth = 32;
int UnlikeWidth = 40;
int PlayerX = 100;
int[]LikeMoveX = new int[10];
int[]LikeMoveY = new int[10];
int[]UnlikeMoveX = new int[10];
int[]UnlikeMoveY = new int[10];
int UnlikemoveX = 600;
int AtariMin = updownimage - 50;
int AtariMax = updownimage + 50;
int ResultPoint = 0 ;
int LikeNum = 10;
int UnlikeNum = 5;
int frame = 0;
int scoreFrame =0;
int animationFrame = 10;
int animIndex = 0;
int mode = 0;
AudioPlayer music;
// グローバル変数ここまで


// スケッチ実行時に最初に１度だけ実行されます
void setup() {
  // ゲームの初期化
  // ゲームシステムの初期化（よくわからなかったらとりあえずそのままにしておいてください）
  print("文字列描画を初期化中......");
  // KeyboardManagerのインスタンスを作成
  keyman = new KeyboardManager();
  // フォントを読み込む
  font = createFont("fonts/VL-PGothic-Regular.ttf", 24);
  if(font == null) {
    // ここで読み込めていない場合はWindowsと同じで'\'で区切るのかもしれない
    font = createFont("fonts\\VL-PGothic-Regular.ttf", 24);
  }
  textFont(font);
  // 文字描画位置を設定する（座標が左上）
  textAlign(LEFT, TOP);
  println("\t[ OK ]");
  
  print("ビデオを初期化中......");
  // 画面サイズを設定（左から順に幅と高さ）
  size(800, 600);
  // フレームレート（単位はフレーム毎秒）
  // １秒間にここに指定した回数だけdraw()が呼ばれる
  frameRate(30);
  println("\t[ OK ]");
  
  print("サウンドシステムを初期化中......");
  // 音声ライブラリ初期化
  minim = new Minim(this);
  println("\t[ OK ]");
  
  println("完了.");
  music = minim.loadFile("105231.mp3");
  // ゲームシステムの初期化ここまで
  
  
  // 以下に追加の初期化処理を書きます
  PlayerImageNormal = loadImage("Dotpara2.png");
  PlayerImageLike = loadImage("Dotpara.png");
  PlayerImageUnlike = loadImage("Dotpara1.png");
  LikeImage = loadImage("Dotpara-iine.png");
  UnlikeImage = loadImage("Dotpara-unlike.png");
  TitleLogoImage = loadImage("dotparatitle.png");
  for(int i = 0; i < LikeNum;  i++  ) {
    LikeMoveY[i] = (int)random(600);
    UnlikeMoveY[i] = (int)random(600);
    LikeMoveX[i] = (int)random(800, 1600);
    UnlikeMoveX[i] = (int)random(800, 1600); 
  }
  
  // 初期化処理ここまで
}

// ゲームメインループ
void draw(){
  // キー入力情報の更新
  keyman.updateKeys();

  // 画面の消去（背景色をここで指定する）
  background(255, 255, 255);
  // 以下にゲームの処理を書きます
  switch(mode){
    case 0:
      Title();
      break;
    case 1:
      Game();
      break;
    case 2:
      Score();
      break;
  }
  // ゲームの処理ここまで
}

void Title(){
  frame = 0;
  image(TitleLogoImage, 150, 100);
  fill(0);
  textSize(40);
  text("shiftキーでスタート!!!",200,400);
  if (keyman.getSpecialKey(SHIFT) ){
    mode = 1;
  }
  ResultPoint = 0;
}
  


void Game(){
  music.play();
  fill(0);
  text(ResultPoint,720,560);
  frame++;
  for (int i = 0; i < LikeNum;  i++) {
    LikeMoveX[i] -= 10;
    if(LikeMoveX[i] < -100) { 
      LikeMoveX[i] = 900;
    }
    image(LikeImage, LikeMoveX[i], LikeMoveY[i]);
  }
  
  for (int i = 0; i < UnlikeNum;  i++) {
    UnlikeMoveX[i] -= 10;
     if(UnlikeMoveX[i] < -100) { 
      UnlikeMoveX[i] = 900;
    }
    image(UnlikeImage, UnlikeMoveX[i], UnlikeMoveY[i]);
  }
  
  if (keyman.getSpecialKey(UP) ){
    image(PlayerImageNormal, PlayerX, updownimage);
    updownimage = updownimage - 5;
  }
  else if (keyman.getSpecialKey(DOWN) ){ 
    image(PlayerImageNormal, PlayerX, updownimage);
    updownimage = updownimage + 5;
  }

  image(PlayerImageNormal, 100, updownimage);
    for(int i = 0; i < LikeNum;  i++  ) {
      if( (PlayerWidth/2 + LikeWidth/2) > Math.abs(LikeMoveX[i] - PlayerX))
      {
        if((PlayerWidth/2 + LikeWidth/2) > Math.abs(LikeMoveY[i] - updownimage)){
          image(PlayerImageLike, PlayerX, updownimage);
          ResultPoint = ResultPoint + 1;
        }
      }
    }
    for(int i = 0; i < UnlikeNum;  i++  ) {
      if( (PlayerWidth/2 + LikeWidth/2) > Math.abs(UnlikeMoveX[i] - PlayerX))
      {
        if((PlayerWidth/2 + UnlikeWidth/2) > Math.abs(UnlikeMoveY[i] - updownimage)){
          image(PlayerImageUnlike, PlayerX, updownimage);
          ResultPoint = ResultPoint - 1;
        }
      }
    }
  
  AtariMin = updownimage - 50;
  AtariMax = updownimage + 50;
  if(frame > 900) {
    // 終了処理
    mode=2;
    music.pause();
    music.rewind();
  }
}

void Score(){
  scoreFrame++;
  if(scoreFrame % animationFrame == 0){
    animIndex++;
    animIndex %= 3;
  }
  fill(0);
  textSize(200);
  text(ResultPoint,300,200);
  switch(animIndex){
    case 0:
      image(PlayerImageNormal, 100, 220);
      break;
    case 1:
      image(PlayerImageLike, 100, 220);
      break;
    case 2:
      image(PlayerImageUnlike, 100, 220);
      break;
  }
  fill(0);
  textSize(25);
  text("ゲットしたいいね",300, 140);
  fill(0);
  textSize(30);
  text("ALTキーでタイトルに戻る",300,500);
  if (keyman.getSpecialKey(ALT) ){
    mode = 0;
  }
}





// 何かキーが押されたときに行う処理を書きます

void keyPressed() {
  // 押されたキーを確認する（KeyboardManager keymanを動作させるために必要）
  keyman.keyPressedHook();
}
// 何かキーが離されたときに行う処理を書きます
void keyReleased() {
  // 離されたキーを確認する（KeyboardManager keymanを動作させるために必要）
  keyman.keyReleasedHook();
}
