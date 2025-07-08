void setup() {
  pinMode(2,OUTPUT);
  digitalWrite(2,1);
  pinMode(4,OUTPUT);
}
int j;
void loop() {
  pinMode(3,INPUT);
  digitalWrite(4,0);
  delay(1);
  for(int i=0;i<100;i++){
    if(digitalRead(3)){ j=15; break; }
    delayMicroseconds(50);
  }
  if(--j>0){
      pinMode(3,OUTPUT);
      digitalWrite(4,1);
      digitalWrite(3,0);
  }
  else j=0;
  delay(15);
}
