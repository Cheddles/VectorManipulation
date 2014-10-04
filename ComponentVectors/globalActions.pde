// this file contains globally-available-methods for ComponentVectors

void deleteAll(){
    //use current dimensions to clear display
  horizontalSize=width;
  verticalSize=height;
  setup();
}

void deleteCurrentVector(){
  for (int i=0; i<vectorCollection.size(); i++){
    currentVector= (Vector) vectorCollection.get(i);
    if (currentVector.selected){
      vectorCollection.remove(i);
      i=i-1;  //to account for renumbering a shorter array list
    }
  }
      bDelete.selected=false;
}


