import SimpleOpenNI.*;
SimpleOpenNI  kinect;
PImage gray;
//線の色を変える場合に使う変数
int R;
int G;
int B;
int stage;

void setup() {
  kinect = new SimpleOpenNI(this);  
  if (kinect.enableDepth() == false) {// 深度カメラを有効にする
    println("Can't open the depthMap, maybe the camera is not connected!"); 
    exit();
    return;
  }
  kinect.enableScene();// 人物検出を有効にする  
  if (kinect.enableRGB() == false) {// RGBカメラを有効にする
    println("Can't open the rgbMap, maybe the camera is not connected or there is no rgbSensor!"); 
    exit();
    return;
  }  
  kinect.alternativeViewPointDepthToImage();// 画像データと深度データの位置合わせをする
  kinect.setMirror(true);
  size(kinect.depthWidth(), kinect.depthHeight());// キャンバスの大きさ
}

void draw() {  
  kinect.update();// カメラ情報を更新する
  PImage maskImg = makeImgForMask(kinect.sceneImage());// sceneImageの人の部分を取り出すマスク用画像を作る
  PImage maskedImg = kinect.rgbImage(); // RGBカメラの映像がマスク対象
  maskedImg.mask(maskImg); // 人物の形で繰り抜いて
  background(0, 64, 0);
  image(maskedImg, 0, 0); // 表示する
  gray = createImage(kinect.depthWidth(), kinect.depthHeight(), RGB);
  //kinect.filter(GRAY);
  float a;
  for (int y=1; y<kinect.depthHeight ()-1; y++) {
    for (int x=1; x<kinect.depthWidth ()-1; x++) {
      a =  - red(get(x, y-1)) - red(get(x-1, y)) + 4*red(get(x, y)) - red(get(x+1, y)) - red(get(x, y+1)); 
      gray.set(x, y, color(abs(a)));
    }
  }
  //colorWave();//線の色変えたい場合はここコメントアウト解除させる
  tint(255, 255, 255);
  image(gray, 0, 0);
}


PImage makeImgForMask(PImage img) {// 深度映像から人物だけを抜き出すようなマスク用画像を返す
  color cBlack = color(0, 0, 0);
  color cWhite = color(255, 255, 255);
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      color c = img.get(x, y);// 人が写っていない白、灰色、黒はRGB値が同じ
      if (red(c) == green(c) & green(c) == blue(c)) {
        img.set(x, y, cBlack); // 黒でマスクする
      } else {// 何らかの色が付いている部分は人が写っている
        img.set(x, y, cWhite); // 白で人の部分を残す
      }
    }
  }
  return img;
}

void colorWave() {//上の説明の部分の文字の色の変化の関数
  if (stage==0) {
    G++;
    if (G>=255) {
      stage=1;
      G=255;
    }
  }
  if (stage==1) {
    R--;
    if (R<0) {
      stage=2;
      R=0;
    }
  }

  if (stage==2) {
    B++;
    if (B>255) {
      stage=3;
      B=255;
    }
  }
  if (stage==3) {
    G--;
    if (G<0) {
      stage=4;
      G=0;
    }
  }
  if (stage==4) {
    R++;
    if (R>255) {
      B--;
      R=255;
      if (B<0) {
        stage=0;
        B=0;
      }
    }
  }
}

