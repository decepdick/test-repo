// demo.js - Harmless mshta demo

// 1. Show a greeting popup
WScript.Echo("Hello! This is a demo script running via mshta.exe");

// 2. Create an array of messages
var messages = [
    "Message 1: JavaScript is running safely!",
    "Message 2: You can display multiple alerts.",
    "Message 3: This script writes to console only, no files."
];

// 3. Loop through messages and display each
for (var i = 0; i < messages.length; i++) {
    WScript.Echo(messages[i]);
}

// 4. Perform a simple calculation
var a = 5, b = 10;
var sum = a + b;
WScript.Echo("Sum of " + a + " + " + b + " = " + sum);

// 5. Show completion message
WScript.Echo("Demo script finished executing!");
