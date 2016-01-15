// Writen by Simon Lansbergen, (c) 2016.
//
// Log: 12-1-2016, created program.
//      14-1-2016, added fixed high to low to high pulse.
//
// program: 
// runs a loop with two pulses (high), each 2 msec long 
// and 10 msec separation. Loop has an initial delay of 10 sec 
// and remains low for 5 min after executing the TTL 
// two pulses. VCC = 5V
//
// this is the actual TTL convention used by the stimulus PC

void setup() {
  pinMode(12, OUTPUT);      // TTL signal out - Tx
  pinMode(13, OUTPUT);      // Onboard LED
}

void loop() {
  digitalWrite(12, HIGH);   // signal on
  delay(10000);             // wait 10 sec before starting after reset
   
  digitalWrite(12, LOW);    // signal off
  digitalWrite(13, HIGH);   // onboard LED on
  
  delay(1);                 // delay(1) = 1 msec
                            // for a High pulse of 1msec
  
  digitalWrite(12, HIGH);   // signal on

  delay(50);                // delay for 50 msec for led blink
  digitalWrite(13, LOW);    // onboard LED off
  
  delay(300000);            // delay(300000) = 5 min 
}
