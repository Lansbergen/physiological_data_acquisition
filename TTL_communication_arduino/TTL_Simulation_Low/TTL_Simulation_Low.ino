// Writen by Simon Lansbergen, (c) 2016.
//
// Log: 14-1-2016, created program.
//
// program: 
// runs a loop with no pulses. VCC = 0V -> LOW
//

void setup() {
    pinMode(12, OUTPUT);      // TTL signal out - Tx
}

void loop() {
    digitalWrite(12, LOW);    // signal off
    delay(300000);            // delay(300000) = 5 min 
}
