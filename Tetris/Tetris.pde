Grid map;
int score;
int mode;
Tetromino pieces;
boolean lose = false;
boolean notLose = false;
int delay;
int x = map.w/2;
int y = 0;

void setup() {
<<<<<<< HEAD
  size(200,400);
=======
  size(400,500);
>>>>>>> 5812babc3ada64947e36938aa4f1bb444765d12b
  map = new Grid();
  pieces = new Tetromino();
  map.add(pieces.nextBlock);
  pieces.getNextBlock();
}

void draw() {
  background(255);

  drawGrid(map.grid, 0, 0);
  drawGrid(pieces.nextBlock, 220, 0);
  if (map.canLockIn()){
    map.clearCurrent();
    map.add(pieces.nextBlock);
    pieces.getNextBlock();
  }

  //  if (notLose) {
  //    if (delay == 0) {
          //pieces.moveDown();
  //      delay += 60;
  //    }
  //    if (delay > 0) {
  //      delay--;
  //    }
  //  }
  //}
  //if (lose) {
  //  noStroke();
  //  fill(255);
  //  rect(100,100, 100, 20);
  //  text("Game Over!", 105,105);
  }


void keyPressed() { // use switch statement lol

  switch (key){
    case 'a':
      map.moveLeft();
      break;
    case 'd':
      map.moveRight();
      break;
    case ' ':
      map.dropDown();
      break;
    case 'w':
      map.rotateCounter();
      break;
    case 's':
      map.moveDown();
      break;
    case 'p':
      pause();
      break;

  }
}

void drawGrid(Block[][] ary){
  for(int i = 0; i < ary.length;i++){
   for(int j = 0; j<ary[0].length;j++){
    if (ary[i][j] == null){
      if (i<4){
        fill(184, 73, 81);
      } else {fill(150);}
    } else {fill(ary[i][j].c);}
    rect(j*map.size,i*map.size,map.size,map.size,5);
   }
  }
}


  
