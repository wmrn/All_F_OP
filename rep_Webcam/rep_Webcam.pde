//ラプラシアンフィルタとWebcameraを合わせただけ
//でもこれだと後ろもうつっちゃう…。
import processing.video.*;
Capture video;
PImage gray;
int R;//上の文字の色の変化に使う変数
int G;
int B;
int stage;

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  video.start();
}

void draw() {
  if (video.available() == true) {
    video.read();
    gray = createImage(video.width, video.height, RGB);
    video.filter(GRAY);
    float a;
    for (int y=1; y<video.height-1; y++) {
      for (int x=1; x<video.width-1; x++) {
        a =  - red(video.get(x, y-1)) - red(video.get(x-1, y)) + 4*red(video.get(x, y)) - red(video.get(x+1, y)) - red(video.get(x, y+1)); 
        gray.set(x, y, color(abs(a)));
      }
    }
    //colorWave();
    tint(255, 255, 255);
    image(gray, 0, 0);
  }
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

