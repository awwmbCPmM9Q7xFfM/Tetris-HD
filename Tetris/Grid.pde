public class Grid {
  int size;
  int h;
  int w;
  Block[][] grid;
  int blockLocation;
  int[][] currentBlockxy;
  int[][] previewBlockxy;
  color holdBlock;
  int cenX;
  int turns = 0;
  int cenY;
  
  public Grid(int row, int col, int size_){ 
    currentBlockxy = new int[4][2];
    previewBlockxy = new int[4][2];
    h = row+4;
    w = col;
    size =size_;
    blockLocation = (w/2)-2;
    grid = new Block[row+4][col];
  }
  public Grid() { // Standard 10x20 grid
    this(20, 10, 20);
  }
  
  void removeCurrentBlocks(){
    for (int i = 0; i < 4; i++){
      grid[currentBlockxy[i][0]][currentBlockxy[i][1]] = null; 
    }
  }
  color getColor(){
    return grid[currentBlockxy[0][0]][currentBlockxy[0][1]].c;
  }
  void clearCurrentBool() {
    for (int i = 0; i<4; i++) {
      if (grid[currentBlockxy[i][0]][currentBlockxy[i][1]] != null)grid[currentBlockxy[i][0]][currentBlockxy[i][1]].isCurrent = false;
    }
  }
  boolean checkLost() {
    for (int i = 0; i<w; i++) {
      if (grid[3][i] != null && grid[3][i].isCurrent == false) return true;
    }
    return false;
  }
  void add(Block[][] next) { // for use with tetromino nextblock
    turns = 0;
    int count = 0;
    for (int i=0; i<4; i++) {
      for (int j=0; j<3; j++) {
        grid[i][blockLocation+j] = next[i][j];
        if (grid[i][blockLocation+j] != null) {
          grid[i][blockLocation+j].isCurrent = true;
          currentBlockxy[count][0] = i;
          currentBlockxy[count][1] = blockLocation+j;
          count++;
        }
      }
    }
    if(grid[currentBlockxy[0][0]][currentBlockxy[0][1]].c == S){
        cenX = currentBlockxy[3][0];
        cenY = currentBlockxy[3][1];
    } else{
        cenX = currentBlockxy[2][0];
        cenY = currentBlockxy[2][1];
    }  
  }
  void removeRow(int row) {
    for (int i = 0; i < grid[row].length; i++) { // remove current row
      grid[row][i] = null;
    }
    for (int i = row-1; i>=0; i--) {
      for (int j = 0; j<grid[row].length; j++) { // mv top blocks down
        grid[i+1][j] = grid[i][j];
        grid[i][j] = null;
      }
    }
  }
  //check if row is full
  void removeFullRows() {
    int amt = 0;
    for (int i = 0; i < 4; i++) {
      boolean isFull = true;
      for (int j = 0; j < w; j++) {
        if (grid[currentBlockxy[i][0]][j] == null) {
          isFull = false;
          break;
        }
      }
      if (isFull) {
        removeRow(currentBlockxy[i][0]);
        i--;
        amt++;
        cenX++;
      }
    }
    linesRemoved+=amt;
    score += (100*pow(amt, 2));
  }


  boolean canLockIn() {
    for (int i = 0; i<4; i++) {
      if (currentBlockxy[i][0]+1==grid.length) return true;
      if (grid[currentBlockxy[i][0]+1][currentBlockxy[i][1]] != null && grid[currentBlockxy[i][0]+1][currentBlockxy[i][1]].isCurrent == false) {
        return true;
      }
    }
    return false;
  }
  boolean canMoveLeft() {
    for (int i = 0; i<4; i++) {
      if (currentBlockxy[i][1]==0) return false;
      if (grid[currentBlockxy[i][0]][currentBlockxy[i][1]-1] != null && grid[currentBlockxy[i][0]][currentBlockxy[i][1]-1].isCurrent == false) {
        return false;
      }
    }
    return true;
  }
  boolean canMoveRight() {
    for (int i = 0; i<4; i++) {
      if (currentBlockxy[i][1]+1==w) return false;
      if (grid[currentBlockxy[i][0]][currentBlockxy[i][1]+1] != null && grid[currentBlockxy[i][0]][currentBlockxy[i][1]+1].isCurrent == false) {
        return false;
      }
    }
    return true;
  }
  void clearTable() {
    for (int i = 0; i < h; i++) {
      for (int j = 0; j<w; j++) {
        grid[i][j] = null;
      }
    }
  }

  void moveLeft() {
    if (canMoveLeft()) {
       
      color col = grid[currentBlockxy[0][0]][currentBlockxy[0][1]].c;    
      for (int i = 0; i<4; i++) {
        grid[currentBlockxy[i][0]][currentBlockxy[i][1]] = null;
      }
      for (int i = 0; i<4; i++) {
        if (currentBlockxy[i][1]-1 >= 0) {
          grid[currentBlockxy[i][0]][currentBlockxy[i][1]-1] = new Block(col);
          grid[currentBlockxy[i][0]][currentBlockxy[i][1]-1].isCurrent = true;
          currentBlockxy[i][1]--;
        }
      }
       
      makePreview();
      cenY--;
      if(toBePressed)delay = 60 - ((level-1) * 2);
      if (blockLocation>=1)blockLocation--;
    }
  }
  void moveRight() {
    if (canMoveRight()) {
      color col = grid[currentBlockxy[0][0]][currentBlockxy[0][1]].c;    
      for (int i = 0; i<4; i++) {
        grid[currentBlockxy[i][0]][currentBlockxy[i][1]] = null;
      }
      for (int i = 0; i<4; i++) {
        if (currentBlockxy[i][1]+1 < 10) {
          grid[currentBlockxy[i][0]][currentBlockxy[i][1]+1] = new Block(col);
          grid[currentBlockxy[i][0]][currentBlockxy[i][1]+1].isCurrent = true;
          currentBlockxy[i][1]++;
        }
      }
       
      makePreview();
      cenY++;
      if(toBePressed) delay = 60 - ((level-1) * 2);
      if (blockLocation<7)blockLocation++;
    }
  }
  void moveDown() {
    if (!canLockIn()) {
      color col = grid[currentBlockxy[0][0]][currentBlockxy[0][1]].c;    
      for (int i = 0; i<4; i++) {
        grid[currentBlockxy[i][0]][currentBlockxy[i][1]] = null;
      }
      for (int i = 0; i<4; i++) {
        grid[currentBlockxy[i][0]+1][currentBlockxy[i][1]] = new Block(col);
        grid[currentBlockxy[i][0]+1][currentBlockxy[i][1]].isCurrent = true;
        currentBlockxy[i][0]++;
      }
      cenX++;
       
      makePreview();
    }
  }

  boolean canLockInPrev() {
    for (int i = 0; i<4; i++) {
      if (previewBlockxy[i][0]+1==grid.length) return true;
      if (grid[previewBlockxy[i][0]+1][previewBlockxy[i][1]] != null && grid[previewBlockxy[i][0]+1][previewBlockxy[i][1]].isCurrent == false) {
        return true;
      }
    }
    return false;
  }
  void makePreview() {
    for (int i = 0; i<4; i++) { //set preview blocks to null
      if (grid[previewBlockxy[i][0]][previewBlockxy[i][1]] != null && grid[previewBlockxy[i][0]][previewBlockxy[i][1]].isPreview == true) grid[previewBlockxy[i][0]][previewBlockxy[i][1]] = null;
    }
    color newcolor = grid[currentBlockxy[0][0]][currentBlockxy[0][1]].c;
    int min = Integer.MAX_VALUE;
    for (int i = 0; i<4; i++) { // set preview coords to current
      min = min(min, currentBlockxy[i][0]);      
      previewBlockxy[i][0]=currentBlockxy[i][0];
      previewBlockxy[i][1]=currentBlockxy[i][1];
    }
    while (!canLockInPrev()) { // update preview by checking if the blocks below arent taken
      for (int i = 0; i<4; i++) {
        previewBlockxy[i][0]++;
      }
    }
    for (int i = 0; i<4; i++) {
      if (grid[previewBlockxy[i][0]][previewBlockxy[i][1]] == null) {
        grid[previewBlockxy[i][0]][previewBlockxy[i][1]] = new Block(newcolor);
        grid[previewBlockxy[i][0]][previewBlockxy[i][1]].isCurrent = true;
        grid[previewBlockxy[i][0]][previewBlockxy[i][1]].isPreview = true;
      }
    }
  }

  void dropDown() {
    for (int i = 0; i<4; i++) {
      grid[previewBlockxy[i][0]][previewBlockxy[i][1]] = grid[currentBlockxy[i][0]][currentBlockxy[i][1]];
      grid[currentBlockxy[i][0]][currentBlockxy[i][1]] = null;
      currentBlockxy[i][0] = previewBlockxy[i][0];
      currentBlockxy[i][1] = previewBlockxy[i][1];
    }
  }
  boolean canRotate(color col, boolean reverse, int orgX, int orgY){
    if (col == O) return false;
    if (col == I) {
      if (turns == 3) if ((orgX <= 0 || orgX >= h-2) || (orgY <= 1 || orgY >= w-1)) return false;
      if (turns == 0) if ((orgX <= 1 || orgX >= h-1) || (orgY <= 1 || orgY >= w-1)) return false;
      if (turns == 1) if ((orgX <= 1 || orgX >= h-1) || (orgY <= 0 || orgY >= w-2)) return false;
      if (turns == 2) if ((orgX <= 0 || orgX >= h-2) || (orgY <= 0 || orgY >= w-2)) return false;
      if ((turns == 0 && !reverse) || (turns == 2 && reverse)){
        for (int i = 0; i < 4; i++){
          if (turns == 2){
            if (grid[orgX+1][orgY-1+i] != null && grid[orgX+1][orgY-1+i].isCurrent == false) return false;
          } else {if (grid[orgX][orgY-2+i] != null && grid[orgX][orgY-2+i].isCurrent == false) return false;}
        }
      }else if ((turns == 1 && !reverse) || (turns == 3 && reverse)){
        for (int i = 0; i < 4; i++){
          if (turns == 3){
            if (grid[orgX-1+i][orgY-1] != null && grid[orgX-1+i][orgY-1].isCurrent == false) return false;
          } else {if (grid[orgX-2+i][orgY] != null && grid[orgX-2+i][orgY].isCurrent == false) return false;}
        }
      } else if ((turns == 2 && !reverse) || (turns == 0 && reverse)){
        for (int i = 0; i < 4; i++){
          if (turns == 0){
            if (grid[orgX-1][orgY-2+i] != null && grid[orgX-1][orgY-2+i].isCurrent == false) return false;
          } else {if (grid[orgX][orgY-1+i] != null && grid[orgX][orgY-1+i].isCurrent == false) return false;}
        }
      } else if ((turns == 3 && !reverse) || (turns == 1 && reverse)){
        for (int i = 0; i < 4; i++){
          if (turns == 1){
            if (grid[orgX-2+i][orgY+1] != null && grid[orgX-2+i][orgY+1].isCurrent == false) return false;
          } else {if (grid[orgX-1+i][orgY] != null && grid[orgX-1+i][orgY].isCurrent == false) return false;}
        }
      }
    } else{
      if ((orgX <= 0 || orgX >= h-1) || (orgY <= 0 || orgY >= w-1)) return false;
      for(int i = 0; i<3; i++){
        for(int j = 0; j<3; j++){
          if (grid[orgX-1+i][orgY-1+j] != null && grid[orgX-1+i][orgY-1+j].isCurrent){
            if(reverse){
              if (grid[orgX+1-j][orgY-1+i]!=null && grid[orgX+1-j][orgY-1+i].isCurrent == false){
               return false; 
              }
            }else{
              if (grid[orgX-1+j][orgY+1-i]!=null && grid[orgX-1+j][orgY+1-i].isCurrent == false){
                 return false; 
              }
            }
          }
        }
      }
    }
    return true;
  }
  void rotateCounter( boolean rev) {
    color col = grid[currentBlockxy[0][0]][currentBlockxy[0][1]].c;
    if (canRotate(col, rev, cenX, cenY)){

      if (col == I){
        //for(int i = 0 ; i < 4; i++){
        //  grid[currentBlockxy[i][0]][currentBlockxy[i][1]] = null;
        //}
        //grid[currentBlockxy[1][0]][currentBlockxy[1][1]] = new Block(col,true);
        //if (turns == 1){
        //  for(int i = 0; i<4;i++){
        //     if (i != 1){
        //       currentBlockxy[i][1]+= (i-1);
        //       currentBlockxy[i][0] = currentBlockxy[1][0];
        //       grid[currentBlockxy[1][0]][currentBlockxy[i][1]] = new Block(col,true);
        //     }
        //  }
        //  turns++;
        //} else{
        //  for(int i = 0; i<4;i++){
        //     if (i != 1){
        //       currentBlockxy[i][0]+= (i-1);
        //       currentBlockxy[i][1] = currentBlockxy[1][1];
        //       grid[currentBlockxy[i][0]][currentBlockxy[i][1]] = new Block(col,true);
        //     }
        //  }
        //  turns--;
        //}
      } else {
        int place = 0;
        for(int i = 0; i<3; i++){
          for(int j = 0; j< 3; j++){
            if (grid[cenX-1+i][cenY-1+j] != null && grid[cenX-1+i][cenY-1+j].isCurrent && grid[cenX-1+i][cenY-1+j].isPreview == false ){
              if (rev){
                currentBlockxy[place][0] = cenX+1-j;
                currentBlockxy[place][1] = cenY-1+i;
              }else{
                currentBlockxy[place][0] = cenX-1+j;
                currentBlockxy[place][1] = cenY+1-i; 
              }
              place++;
              grid[cenX-1+i][cenY-1+j] = null;
            }
          }
        }
        for(int i = 0; i < 4; i++){
          grid[currentBlockxy[i][0]][currentBlockxy[i][1]] = new Block(col,true);
        }
      }
    }
      if(toBePressed) delay = 60 - ((level-1) * 2);
       
      makePreview();
  }


}
